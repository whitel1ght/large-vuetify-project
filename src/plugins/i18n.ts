import messages from '@/lang'
import { createI18n } from 'vue-i18n'

const i18n = createI18n({
  legacy: false,
  locale: 'en',
  fallbackLocale: 'en',
  messages,
  // fallbackWarn: false,
  // missingWarn: false
})

export default i18n

