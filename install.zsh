#!/bin/zsh

# Easily install Prezto on new setups
# Thanks to Sorin Ionescu's README
# and Chionsas' PKGBUILD in the AUR (https://aur.archlinux.org/packages/prezto-git/)

# mkdir -v /usr/lib/prezto

## must use --recursive option to make sure external submodules are pulled in
# git clone --recursive https://github.com/skittleys/prezto.git /usr/lib/prezto

setopt EXTENDED_GLOB

# Give write permissions to sudoers group
if [ 'grep -E -e "^sudo:" /etc/group' ]; then
        sudo chgrp -R sudo /usr/lib/prezto
        sudo chgrp -R sudo /etc/zsh
elif [ 'grep -E -e "^wheel:" /etc/group' ]; then
        sudo chgrp -R wheel /usr/lib/prezto
        sudo chgrp -R wheel /etc/zsh
else
        echo "Neither group wheel nor sudo exists. Permissions have not been changed."
        exit 2
fi

# want to make symlinks to all runcoms except zshrc
for rcfile in /usr/lib/prezto/runcoms/^(zshrc|README.md); do
  ln -vs "$rcfile" "$HOME/.${rcfile:t}"
done

# link zsh files in /etc to runcoms (zshrc after)
zlist=('/etc/zsh/zlogin' 'etc/zsh/zlogout' 'etc/zsh/zpreztorc' 'etc/zsh/zshenv')
for zfile in ${zlist[@]}; do
	rcfile=$(basename $zfile)
	if [ -f /usr/lib/prezto/runcoms/$rcfile ]; then
		echo "source /usr/lib/prezto/runcoms/$rcfile" >| "/etc/zsh/$rcfile" && echo "/etc/zsh/$rcfile modified"
	fi
done

# create /etc/zsh/zshrc
echo -e "source /etc/zsh/zpreztorc\nsource /usr/lib/prezto/init.zsh\nsource /usr/lib/prezto/runcoms/zshrc" >| /etc/zsh/zshrc && echo "/etc/zsh/zshrc modified"

# create a user-specific .zshrc
[[ -e $HOME/.zshrc ]] && cp $HOME/.zshrc $HOME/zshrc-backup && echo "backed up .zshrc to zshrc-backup"
echo -e "source /usr/lib/prezto/runcoms/zshrc\n\nDEFAULT_USER="`whoami` >| $HOME/.zshrc && echo "created .zshrc"

