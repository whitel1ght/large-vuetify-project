import type { UserWithNumber } from './UserWithNumber'
import type { UserWithToken } from './UserWithToken.ts'
import type { UserWithPassword } from './UserWithPassword.ts'

export enum UserType {
  WITH_NUMBER,
  WITH_TOKEN,
  WITH_PASSWORD
}

export type User = UserWithNumber
  | UserWithToken
  | UserWithPassword

// feature:add-user
