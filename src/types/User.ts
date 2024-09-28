import type { UserWithNumber } from './UserWithNumber'
import type { UserWithToken } from './UserWithToken.ts'
import type { UserWithPassword } from './UserWithPassword.ts'

export type User = UserWithNumber | UserWithToken | UserWithPassword
