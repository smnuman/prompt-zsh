#!/usr/bin/env zsh
# 🌀 Set prompt dynamically each time
function prompt-setup {
    # 🔴 Root identifier
    ROOT_TAG=$([[ $(id -u) -eq 0 ]] && echo "%K{230}%F{red} %B[ROOT]%b %f%k" || echo "")

    # 🕒 Time
    PROMPT_TIME="%K{15}%F{241}[%*]%f%k"

    # 🔹 Virtualenv
    VENV_NAME=$([[ -n "$VIRTUAL_ENV" ]] && echo "(%F{magenta}$(basename %"$VIRTUAL_ENV%")%f)" || echo "")

    # 📂 Full path for root (never ~ for 'root') or the user (using '~' for home)
    FULL_PATH=$([[ $(id -u) -eq 0 ]] && echo "%K{red}%F{white} %/ %f%k" || echo "%K{cyan} %F{blue}%~%f %k")

    # 🌱 Git segment using 'prompt-git-status.zsh' in ~/.config/zsh/prompt/
    # vcs_info 2>/dev/null
    # GIT_BRANCH="${vcs_info_msg_0_:-}"
    GIT_BRANCH=$([[ -f "$ZDOTDIR/prompt/prompt-git-status.zsh" ]] && { "git_prompt_segment" } || echo "")

    PROMPT_END=$([[ $(id -u) -eq 0 ]] && echo "%F{red}%#%f" || echo "%F{yellow}\$%f")

    # 🎯 Build final prompt string
    PROMPT="${PROMPT_TIME}${VENV_NAME}${FULL_PATH}${GIT_BRANCH} ${PROMPT_END} "
    RPROMPT="${ROOT_TAG}"
}
add-zsh-hook precmd prompt-setup
