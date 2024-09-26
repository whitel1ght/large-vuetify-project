const modules = import.meta.glob('@/lang/en/**/*.json', {
  eager: true,
  import: 'default'
})

const messages = {}

for (const file of Object.keys(modules)) {
  if (file === './index.js') continue

  const path = file
    .replace('/src/lang/', '')
    .replace(/(\.\/|\.json$)/g, '')
    .split('/')

  path.reduce((acc, item, i) => {
    if (acc[item]) return acc[item]

    acc[item] = i + 1 === path.length ? JSON.parse(JSON.stringify(modules[file])) : {}

    return acc[item]
  }, messages)
}

export default messages

