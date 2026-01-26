#
# ~/.bashrc
#

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

(cat ~/.cache/wal/sequences &)

# Media aliases
alias play='mpv'
alias imgs='sxiv'


# Created by `pipx` on 2025-11-15 13:12:21
export PATH="$PATH:/home/harman/.local/bin"
alias pokemon='pokemon-colorscripts-go'
alias poke='pokemon-colorscripts-go'
alias rain='terminal-rain'
alias fish='asciiquarium'
alias aquarium='asciiquarium'
alias msg='notify-send'
alias projects='cd ~/Coding/Projects'
alias map='npx mapscii'
alias clock='tty-clock -c -s -x -t'
alias cpp='cd ~/Coding/Learning/Learning-C++'
alias insta='instagram-cli'
eval "$(starship init bash)"


