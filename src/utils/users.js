import { UserType } from '@/types/User'

export const headers = [
  {
    title: 'Name',
    key: 'name',
    align: 'start',
    sortable: false,
  },
  {
    title: 'Actions',
    key: 'actions',
    sortable: false
  }
]

export const USER_TYPES_MAP = new Map([
  [UserType.WITH_NUMBER, 'Users.types.withNumber'],
  [UserType.WITH_PASSWORD, 'Users.types.withPassword']
])

// feature:add-user
