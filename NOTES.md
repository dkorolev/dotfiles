# Random Notes

## Fullscreen `meld` in Windows

```
sudo vim /usr/share/glib-2.0/schemas/org.gnome.meld.gschema.xml
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
```

## Headers for `ycm`

```
echo | clang -v -E -x c++ -
```

Looks for the lines between:

```
#include <...> search starts here:
 /usr/bin/../lib/gcc/x86_64-linux-gnu/12/../../../../include/c++
 /usr/lib/llvm-14/lib/clang/14.0.0/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list.
```

And add them into `~/.ycm_extra_conf.py` as:
```
flags = [
  '-isystem', '/usr/include/c++/11'
  '-isystem', '/usr/bin/../lib/gcc/x86_64-linux-gnu/12/../../../../include/c++',
  '-isystem', '/usr/lib/llvm-14/lib/clang/14.0.0/include',
  '-isystem', '/usr/local/include',
  '-isystem', '/usr/include/x86_64-linux-gnu',
  '-isystem', '/usr/include',
]
```

Also, you may want to run with the existing `clangd`:

```
set rtp+=~/.vim/pack/plugins/opt/YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_clangd_binary_path = '/usr/bin/clangd'
```

## `nvm`

```
curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh -o install_nvm.sh
```
