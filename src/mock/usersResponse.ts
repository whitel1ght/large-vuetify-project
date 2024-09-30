import type { User } from '@/types/User'
import { UserType } from '@/types/User'

export const usersResponse: User[] = [
  {
    id: 'one',
    type: UserType.WITH_PASSWORD,
    name: 'John',
    surname: 'Doe',
    password: 'Password123'
  },
  {
    id: 'two',
    type: UserType.WITH_NUMBER,
    name: 'Jane Doe',
    phoneNumber: 1234567890,
    messengers: ['Telegram', 'WhatsApp']
  },
  {
    id: 'three',
    type: UserType.WITH_TOKEN,
    name: 'John Smith',
    accessToken: '#sad@hdsdfasdflasdajdaduqwejasndasbdabd',
    refreshToken: 'asdasadansvnsdnfdaskdasjdjadjajsdjasjdajs'
  }
]
