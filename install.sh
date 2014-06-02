# Easily install Prezto on new setups
# Thanks to Sorin Ionescu's README
# and Chionsas' PKGBUILD in the AUR (https://aur.archlinux.org/packages/prezto-git/)

mkdir /usr/lib/prezto

## must use --recursive option to make sure external submodules are pulled in
# git clone --recursive https://github.com/sorin-ionescu/prezto.git /usr/lib/prezto

setopt EXTENDED_GLOB

# want to make symlinks to all runcoms except zshrc
for rcfile in "/usr/lib/prezto/runcoms/^(zshrc|README.md); do
  ln -s "$rcfile" "$HOME/.${rcfile:t}"
done

# create a user-specific .zshrc
[[ -e $HOME/.zshrc ]] && cp $HOME/.zshrc $HOME/zshrc-backup && echo "backed up .zshrc to zshrc-backup"
echo -e "source /usr/lib/prezto/runcoms/zshrc\n\nDEFAULT_USER="`whoami` >| $HOME/.zshrc
