def Settings(**kwargs):
  if kwargs.get('language') == 'cfamily':
    return {
      'flags': [
        '-Wall',
        '-Wextra',
        '-Wno-unused-includes',
        '-std=c++17',
        # Treat `.h` headers as `.hpp` / C++ ones.
        '-x', 'c++',
        # For `current` headers.
        '-I', './current/',
        '-I', '../current/',
        '-I', '../../current/',
        # For `cmake`-based builds of C++ projects using `C5T/Current`.
        '-DC5T_CMAKE_PROJECT',
        '-I', '.current/inc',
        '-I', '.current_debug/inc',
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
