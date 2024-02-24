def Settings(**kwargs):
  if kwargs.get('language') == 'cfamily':
    return {
      'flags': [
        '-Wall',
        '-Wextra',
        '-Wno-unused-includes',
        '-std=c++17',
        # For `current` headers.
        '-I', './current/',
        '-I', '../current/',
        '-I', '../../current/',
        # For `#include <gtest/test.h>`, when using `googletest` via `CMakeLists.txt`.
        '-isystem', './googletest/googletest/include',
        '-isystem', '../googletest/googletest/include',
        '-isystem', '../../googletest/googletest/include',
        # For `leveldb`.
        '-I', './leveldb/include',
        '-I', '../leveldb/include',
        '-I', '../../leveldb/include',
      ]
    }
  else:
    return {}
