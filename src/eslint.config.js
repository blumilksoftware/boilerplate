import blumilkDefault from '@blumilksoftware/eslint-config'

export default [
    ...blumilkDefault,
    {
        rules: {
            'tailwindcss/no-custom-classname': 0,
        }
    }
]
