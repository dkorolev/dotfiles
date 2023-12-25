# Random Notes

Since the repo is self-explanatory.

## Installing `ycm`

*Note: Obsoleted by `ubuntu-setup.sh`.*

This is slow, but has no dependencies.

```
# Clone, everything, shallow.
git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/Valloric/YouCompleteMe  ~/.vim/pack/plugins/opt/YouCompleteMe

# NOTE(dkorolev): `--all` can be replaced by `--clangd-completer` or `--clang-completer`, or even `--Rust` or `--Go`.
(cd ~/.vim/pack/plugins/opt/YouCompleteMe; ./install.py --all)

# NOTE(dkorolev): To complete the above, `set rtp+=~/.vim/pack/plugins/opt/YouCompleteMe` is required in `.vimrc`.
```

## Headers for `ycm`

*Note: Obsoleted by `ubuntu-setup.sh`.*

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

*TODO(dkorolev): Add into `ubuntu-setup.sh`?*

```
curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh -o install_nvm.sh
```
