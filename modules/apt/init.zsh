# Aliases and functions for Debian- and Ubuntu-based distros
# Inspired by OMZ's Debian plugin
# and the functions contained in Prezto's dpkg module

########################
##      Aliases       ##
########################

## apt-cache
alias mad='apt-cache madison'
alias acs='apt-cache search'
alias acp='apt-cache policy'
alias acsh='apt-cache show'
alias acsp='apt-cache showpkg'
alias acshp='apt-cache showpkg'
alias rdep='apt-cache rdepends'

## apt-get
alias inst='sudo apt-get install'
alias apt-up='sudo apt-get update && sudo apt-get upgrade'
alias ad='sudo apt-get update'
alias ag='sudo apt-get upgrade'
alias asou='apt-get source'
alias abd='sudo apt-get build-dep'

## dpkg
alias sapt='sudo aptitude'
alias syn='sudo synaptic 2> /dev/null &'
alias findpkg='dpkg -l | grep'

# apt-file
alias afs='apt-file search --regexp'

## packaging
alias dquilt="quilt --quiltrc=$HOME/.quiltrc-dpkg"
alias piu="sudo piuparts -b /var/cache/pbuilder/piuparts/piupartz.tgz -m http://cdn.debian.net/debian"


########################
##     Functions      ##
########################
# create a simple script that can be used to 'duplicate' a system
apt-copy() {
    print '#!/bin/sh'"\n" > apt-copy.sh

    cmd='$apt_pref install'

    for p in ${(f)"$(aptitude search -F "%p" --disable-columns \~i)"}; {
        cmd="${cmd} ${p}"
    }

    print $cmd "\n" >> apt-copy.sh

    chmod +x apt-copy.sh
}

# Prints apt history
# Usage:
#   apt-history install
#   apt-history upgrade
#   apt-history remove
#   apt-history rollback
#   apt-history list
# Based On: http://linuxcommando.blogspot.com/2008/08/how-to-show-apt-log-history.html
apt-history () {
  case "$1" in
    install)
      zgrep --no-filename 'install ' $(ls -rt /var/log/dpkg*)
      ;;
    upgrade|remove)
      zgrep --no-filename $1 $(ls -rt /var/log/dpkg*)
      ;;
    rollback)
      zgrep --no-filename upgrade $(ls -rt /var/log/dpkg*) | \
        grep "$2" -A10000000 | \
        grep "$3" -B10000000 | \
        awk '{print $4"="$5}'
      ;;
    list)
      zcat $(ls -rt /var/log/dpkg*)
      ;;
    *)
      echo "Parameters:"
      echo " install - Lists all packages that have been installed."
      echo " upgrade - Lists all packages that have been upgraded."
      echo " remove - Lists all packages that have been removed."
      echo " rollback - Lists rollback information."
      echo " list - Lists all contains of dpkg logs."
      ;;
  esac
}

# Kernel-package building shortcut
kerndeb () {
    # temporarily unset MAKEFLAGS ( '-j3' will fail )
    MAKEFLAGS=$( print - $MAKEFLAGS | perl -pe 's/-j\s*[\d]+//g' )
    print '$MAKEFLAGS set to '"'$MAKEFLAGS'"
	appendage='-custom' # this shows up in $ (uname -r )
    revision=$(date +"%Y%m%d") # this shows up in the .deb file name

    make-kpkg clean

    time fakeroot make-kpkg --append-to-version "$appendage" --revision \
        "$revision" kernel_image kernel_headers
}

# List packages by size
apt-list-packages() {
    dpkg-query -W --showformat='${Installed-Size} ${Package} ${Status}\n' | \
    grep -v deinstall | \
    sort -n | \
    awk '{print $1" "$2}'
}

# CowBuilder

cb-shell() {
    chr=$1 ; shift
    sudo cowbuilder \
    	--bindmount $HOME \
    	--login \
    	--basepath=/var/cache/pbuilder/base-${chr}.cow $@
}

cb-shell-save() {
    cb-shell "$@" --save-after-login
}

## skittleys' own invention
desc() {
if [[ -n $1 ]]; then
	for i in $@
	do 
		res=$(apt-cache show $i | grep --color=never -m 1 "Description\(-en\)\?:" | sed "s/Description\(-en\)\?: //")
		echo -e "\e[33m$i\e[0m: $res"
	done
    fi
}
