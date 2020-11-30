#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
export LC_ALL=en_US.UTF-8

#export VAGRANT_HOME=/data/.vagrant.d

# add alias ##############################################
alias ls='ls --color=auto'
alias load-vm='sudo systemctl start vmware-networks; sudo systemctl start vmware-usbarbitrator; sudo systemctl start vmware-hostd'
alias load-vm-full='sudo systemctl start vmware-networks; sudo systemctl start vmware-usbarbitrator; sudo systemctl start vmware-hostd; sudo vmware-modconfig --console --install-all'
alias rp1='cat /dev/random | tr -dc "a-zA-Z0-9" | fold -w 24 | head -1'
alias rp2='cat /dev/random | tr -dc "a-zA-Z0-9@^&%" | fold -w 32 | head -1'
alias java8='sudo archlinux-java set java-8-openjdk/jre'
alias java10='sudo archlinux-java set java-10-openjdk'
alias pserver='python -m http.server 8888'
alias rrm='trash-put'
###########################################################

PS1="\[\e[1;32m\]\u\[\e[m\][\[\e[1;34m\]\W\[\e[m\]]\$ "
