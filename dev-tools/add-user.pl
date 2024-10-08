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
# - create form (src/components/forms/)
# - import form to AddUserDialog (src/components/dialogs/AddUserDialog.vue)
# - import form to EditUserDialog (src/components/dialogs/EditUserDialog.vue)


# util functions
sub uncapitalize_first_char {
  my ($str) = @_;
  return lc(substr($str, 0, 1)) . substr($str, 1);
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

main();
