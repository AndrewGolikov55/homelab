# Перед началом работы прогнать скрипт командой:
# curl -sS https://starship.rs/install.sh | sh

# Контроль истории
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Отслежить размер окна
shopt -s checkwinsize

# Алиасы
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Импорт переменных окружения из /etc/environment
if [ -f /etc/environment ]; then
    set -a
    . /etc/environment
    set +a
fi

eval "$(starship init bash)"
