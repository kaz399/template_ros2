git_branch() {
    __git_ps1 '(git:%s)'
}

function set_prompt {
    history -a
    if [ -n "${VIRTUAL_ENV}" ] ; then
        VENV="\[\033[35m\](venv:$(basename ${VIRTUAL_ENV}))\[\033[00m\]"
    else
        VENV=""
    fi
    PS1="${VENV}\[\033[32m\]\$HOSTNAME\[\033[00m\]:\[\033[36m\]\w\[\033[31m\]$(git_branch)\[\033[00m\]\n\$ "
}

PROMPT_COMMAND='set_prompt'
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME:+$FUNCNAME(): }'

