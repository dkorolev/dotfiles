def Settings(**kwargs):
  if kwargs.get('language') == 'cfamily':
    return {
      'flags': [
        '-Wall',
        '-Wextra',
        '-I', './current/',
        '-I', '../current/',
        '-I', '../../current/',
      ]
    }
  else:
    return {}
