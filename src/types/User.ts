import type { UserWithNumber } from './UserWithNumber'
import type { UserWithPassword } from './UserWithPassword.ts'

export enum UserType {
  WITH_NUMBER,
  WITH_PASSWORD
}

export type User = UserWithNumber
  | UserWithPassword

// feature:add-user
