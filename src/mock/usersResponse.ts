import type { User } from '@/types/User.ts'

export const usersResponse: User[] = [
  {
    id: 'one',
    name: 'John',
    surname: 'Doe',
    password: 'Password123'
  },
  {
    id: 'two',
    name: 'Jane Doe',
    phoneNumber: 1234567890,
    messengers: ['Telegram', 'WhatsApp']
  },
  {
    id: 'three',
    name: 'John Smith',
    accessToken: '#sad@hdsdfasdflasdajdaduqwejasndasbdabd',
    refreshToken: 'asdasadansvnsdnfdaskdasjdjadjajsdjasjdajs'
  }
]
