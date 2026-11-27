case "$-" in *i*) ;; *) return ;; esac
[ -r /etc/profile ] && . /etc/profile
# PS1: timestamp verde, user ROJO (root), host default, pwd azul, # final
PS1='\[\e[32m\]\t\[\e[0m\] \[\e[1;31m\]\u\[\e[0m\]@\h \[\e[34m\]\W\[\e[0m\]\$ '
HISTFILE=~/.bash_history
HISTSIZE=1000
HISTFILESIZE=2000
