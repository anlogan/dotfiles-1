#!/bin/bash
alias !='sudo'
alias ..='cd ..'
alias less='less -F'
alias pp='powerpill'
alias spp='sudo powerpill'
alias sls='slurpy -c -s'
alias sld='slurpy -c -d'
alias grep='grep --color'
alias ls='ls --color=auto'
alias ll='ls -la'
alias lsd='ls -l | grep ^[dl] --color=none'
alias md5='md5sum'
alias cdg='cd $(git rev-parse --git-dir)/..'
alias webshare='python /usr/lib/python2.6/SimpleHTTPServer.py 8001'
alias hman='man -Hchromium-browser'
alias mkchpkg='sudo makechrootpkg -c -r /mnt/Entropy/cleanroot'

qp() {
	pacman-color -Qi $1 2> /dev/null
	if [[ $? -gt 0 ]]; then
		echo "$1 not found, searching..."
		pacman-color -Qs $1
		[[ $? -gt 0 ]] && echo "No local results for $1"
	fi
}

dsz() {
	[[ -z $1 ]] && target=$(pwd) || target=$1
	[[ ! -d $target ]] && echo "'$target' is not a directory" && return 1
	du -sh $(du -s $(find $(readlink -f $target) -maxdepth 1 -type d) | sort -n | awk '{print $2}')
}

calc() {
	echo "scale=3; $*" | bc
}

unwork() {
	if [[ -z $1 ]]; then
		echo "USAGE: unwork [dirname]"
	else
		if [[ -d $1 ]]; then
			count=0
			for f in `find $1 -name .svn`; do 
				rm -r $f
				count=$((count + 1))
			done
			echo "SUCCESS. Directory is no longer a working copy ($count .svns removed)."
			unset count
		else
			echo "ERROR: $1 is not a directory"
		fi
	fi
}

man2pdf() {
    if [[ -z $1 ]]; then
    	echo "USAGE: man2pdf [manpage]"
    else
    	if [[ `find /usr/share/man -name $1\* | wc -l` -gt 0 ]]; then
		out=/tmp/$1.pdf
		if [[ ! -e $out ]]; then
			man -t $1 | ps2pdf - > $out
		fi
		if [[ -e $out ]]; then
			/usr/bin/evince $out
		fi
	else
		echo "ERROR: manpage \"$1\" not found."
	fi
    fi
}

ex () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "'$1': unrecognized file compression" ;;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}

ljoin() {
	local OLDIFS=$IFS
	IFS=${1:?"Missing separator"}; shift
	echo "$*"
	IFS=$OLDIFS
}

function scr {
	if screen -ls | grep -q Main; then
		screen -xr Main
	else
		screen -S Main
	fi
}
