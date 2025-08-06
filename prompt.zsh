#!/usr/bin/env zsh
# 🌀 Set prompt dynamically each time
function prompt-setup {
    # 🔴 Root identifier
    ROOT_TAG=$([[ $(id -u) -eq 0 ]] && echo "%K{230} %F{red}%B[ROOT]%b%f %k" || echo "")

    COLOR_RESET=$(echo "%f %k")

    ROOT_COLOR=$([[ $(id -u) -eq 0 ]] && echo "%K{white} %F{red}" || echo "%K{15} %F{241}")
    ROOT_PATH_COLOR=$([[ $(id -u) -eq 0 ]] && echo "%K{red} %F{white}" || echo "%K{cyan} %F{blue}")
    ROOT_PROMPT_COLOR=$([[ $(id -u) -eq 0 ]] && echo "%K{white} %F{red}" || echo " %F{yellow}")
    PROMPT_COLOR_RESET=$([[ $(id -u) -eq 0 ]] && echo "%f %k" || echo "%f")

    ROOT_PATH_ELEMENT=$([[ $(id -u) -eq 0 ]] && echo "%/" || echo "%~")
    # ROOT_PATH_END=$(echo "%f %k")

    # 🕒 Time
    PROMPT_TIME="${ROOT_COLOR}[%*]${COLOR_RESET}"

    # 🔹 Virtualenv
    VENV_NAME=$([[ -n "$VIRTUAL_ENV" ]] && echo "(%F{magenta}$(basename %"$VIRTUAL_ENV%")%f)" || echo "")

    # 📂 Full path for root (never ~ for 'root') or the user (using '~' for home)
    FULL_PATH="${ROOT_PATH_COLOR}${ROOT_PATH_ELEMENT}${COLOR_RESET}"
    # FULL_PATH=$([[ $(id -u) -eq 0 ]] && echo "%K{red}%F{white} %/ %f%k" || echo "%K{cyan} %F{blue}%~%f %k")

    # 🌱 Git segment using 'prompt-git-status.zsh' in ~/.config/zsh/prompt/
    GIT_BRANCH=$([[ -f "$ZDOTDIR/prompt/prompt-git-status.zsh" ]] &&  "git_prompt_segment" || echo "")

    PROMPT_END="${ROOT_PROMPT_COLOR}%(!.#.$)${PROMPT_COLOR_RESET}"
    # PROMPT_END=$([[ $(id -u) -eq 0 ]] && echo "${ROOT_COLOR}%#${COLOR_RESET}" 2>/dev/null || echo " %F{yellow}\$%f" 2>/dev/null)

    # 🎯 Build final prompt string
    PROMPT="${PROMPT_TIME}${VENV_NAME}${FULL_PATH}${GIT_BRANCH}${PROMPT_END} "
    RPROMPT="${ROOT_TAG}"
}
add-zsh-hook precmd prompt-setup
