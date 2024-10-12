#!/usr/bin/env perl

use Modern::Perl;
use autodie;
use Cwd qw(cwd);
use File::Copy;

# - read argumnet ts file
# - import to User.ts & extend enum & extend type User (src/types/User.ts)
# - update USER_TYPES_MAP (src/utils/users.js)
# - update userResponse (src/mock/userResponse.ts)
# - update json file with translations (src/lang/en/Users.json)
# - copy form from devtools/templates/UserForm.txt to src/components/forms/
# - import form to AddUserDialog (src/components/dialogs/AddUserDialog.vue)
# - import form to EditUserDialog (src/components/dialogs/EditUserDialog.vue)


# util functions
sub uncapitalize_first_char {
  my ($str) = @_;
  return lc(substr($str, 0, 1)) . substr($str, 1);
}

# trim whitespaces
sub trim {
  my $s = shift;
  $s =~ s/^\s+|\s+$//g;
  return $s;
}

# entry point
sub main {
  my $ts_file = $ARGV[0];

  my ($user_type, $enum_key, @keys) = parse_user_ts($ts_file);

  print "User type: ${user_type}\n";
  print "Keys: @keys\n";
  print "Enum key: ${enum_key}\n";

  update_user_ts($user_type, $enum_key);
  update_user_types_map($user_type, $enum_key);
  update_user_response($user_type, $enum_key, @keys);
  update_users_json($user_type, $enum_key, @keys);
  copy_user_form($user_type, $enum_key, @keys);
}

# sets user type, enum key and keys
# so we can update some files using this data
sub parse_user_ts {
  my ($user) = @_;
  open my $input, '<', $user;

  my @keys;
  my $user_type;
  my $enum_key;

  while (my $line = <$input>) {
    if ($line =~ /export interface (\S*) \{$/) {
      $user_type = $1;
    }

    if ($line =~ /(\S*): (\S*)$/) {
      push @keys, $1;
    }
  }

  $enum_key = substr(uc(join('_', split(/(?=[A-Z])/, $user_type))), 5);

  close $input;
  return ($user_type, $enum_key, @keys);
}

sub update_user_ts {
  my ($user_type, $enum_key) = @_;
  print "User type: $user_type\n";

  my $user_ts = 'src/types/User.ts';
  my $temp_file = 'src/types/User.ts.temp';

  open my $input, '<', $user_ts;
  open my $output, '>', $temp_file;

  while (my $line = <$input>) {
    print $output $line;

    if ($line =~ /import type \{ UserWithPassword./) {
      print $output "import type { $user_type } from './$user_type'\n";
    }

    if ($line =~ /export enum UserType \{/) {
      print $output "  ${enum_key},\n";
    }

    if ($line =~ /export type User./) {
      print $output "  | $user_type\n";
    }
  }

  close $input;
  close $output;

  move($temp_file, $user_ts);
}

sub update_user_types_map {
  my ($user_type, $enum_key) = @_;

  my $user_types_map = 'src/utils/users.js';
  my $temp_file = 'src/utils/users.js.temp';

  open my $input, '<', $user_types_map;
  open my $output, '>', $temp_file;

  while (my $line = <$input>) {
    print $output $line;

    if ($line =~ /export const USER_TYPES_MAP./){
      my $uncapitalized_user_type = uncapitalize_first_char($user_type);
      print $output "  [UserType.${enum_key}, 'Users.types.$uncapitalized_user_type'],\n";
    }
  }

  close $input;
  close $output;

  move($temp_file, $user_types_map);
}

sub update_user_response {
  my ($user_type, $enum_key, @keys) = @_;

  my $user_response = 'src/mock/usersResponse.ts';
  my $temp_file = 'src/mock/usersResponse.ts.temp';

  open my $input, '<', $user_response;
  open my $output, '>', $temp_file;

  while (my $line = <$input>) {
    print $output $line;

    if ($line =~ /export const usersResponse./){
      print $output "  {\n";
      for my $key (@keys) {
        if ($key eq 'type') {
          print $output "    $key: UserType.${enum_key},\n";
        } else {
          print $output "    $key: 'edit me',\n";
        }
      }
      print $output "  },\n";
    }
  }

  close $input;
  close $output;

  move($temp_file, $user_response);
}

sub update_users_json {
  my ($user_type, $enum_key, @keys) = @_;

  my $users_json = 'src/lang/en/Users.json';
  my $temp_file = 'src/lang/en/Users.json.temp';

  open my $input, '<', $users_json;
  open my $output, '>', $temp_file;

  while (my $line = <$input>) {
    print $output $line;

    if ($line =~ /.*"types": \{/){
      # WITH_TOKEN transform to withToken
      my $camelcase_enum_key = uncapitalize_first_char(join('', map { ucfirst(lc($_)) } split(/_/, $enum_key)));
      my $words_user_type = join(' ', split(/(?=[A-Z])/, $user_type));

      print $output "    \"$camelcase_enum_key\": \"$words_user_type\",\n";
    }
  }

  close $input;
  close $output;

  move($temp_file, $users_json);
}

sub copy_user_form {
  my ($user_type, $enum_key, @keys) = @_;

  my $form_file = 'src/components/forms/' . $user_type . 'Form.vue';
  my $temp_file = $form_file . '.temp';

  copy 'dev-tools/templates/UserForm.txt', $form_file;

  open my $input, '<', $form_file;
  open my $output, '>', $temp_file;

  my $user_ref = lcfirst($user_type) . 'Form';
  my $json_section = uncapitalize_first_char(join('', map { ucfirst(lc($_)) } split(/_/, $enum_key)));


  while (<$input>) {
    s/VAR_REF/$user_ref/g;
    s/VAR_TYPE/$user_type/g;
    s/VAR_ENUM_KEY/$enum_key/g;
    s/JSON_SECTION/$json_section/g;

    if (trim($_) eq "PLACEHOLDER DATA") {
      foreach my $key (@keys) {
        if ($key eq 'id' || $key eq 'name' || $key eq 'type') {
          next;
        }
        say $output "  $key: '',";
      }
      next;
    }

    if (trim($_) eq "PLACEHOLDER TEMPLATE") {
      open my $in, '<', 'dev-tools/templates/TextField.txt';
      my @template_lines = <$in>;
      close $in;

      foreach my $key (@keys) {
        if ($key eq 'id' || $key eq 'name' || $key eq 'type') {
          next;
        }
        foreach my $line (@template_lines) {
          my $modified_line = $line;
          $modified_line =~ s/FIELD/$key/g;
          print $output $modified_line;
        }
      }
      next;
    }

    print $output $_;
  }

  # make all replacements later
  while (<$input>) {
    print $output $_;
  }

  close $input;
  close $output;

  move($temp_file, $form_file);
}

main();
