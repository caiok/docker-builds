# Default Bash profile

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias egrep='egrep --color'
alias fgrep='fgrep --color'
alias grep='grep --color'

alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
alias showdiff='diff -bBiy'

alias ls='ls --color=auto --time-style=+"%d.%m.%Y %H:%M"'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'

export PS1='\[\e[0;32m\][[${debian_chroot:+($debian_chroot)}\u@\h:\w]]\$\[\e[0m\] '
