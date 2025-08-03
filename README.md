# 🌀 Zsh Minimal Git-Aware Prompt

A **minimal yet powerful Git-aware Zsh prompt** system crafted with:

* Clear visual cues
* Upstream sync indicators
* Virtual environment detection
* Root vs User differentiation

## 🧱 Directory Structure

```
~/.config/zsh/
├── prompt/
│   ├── git-status.zsh         # git_prompt_segment function
│   └── prompt.zsh             # precmd hook building PROMPT & RPROMPT
├── zsh-prompt                # sourced from .zshrc
└── ...                       # other configs (env.zsh, exports, aliases, etc.)
```

## ⚙️ Setup Instructions

### 1. `prompt.zsh`

```zsh
#!/usr/bin/env zsh
# ~/.config/zsh/prompt/prompt.zsh

precmd() {
    ROOT_TAG=$([[ $(id -u) -eq 0 ]] && echo "%K{230}%F{red} %B[ROOT]%b %f%k" || echo "")
    PROMPT_TIME="%K{15}%F{241}[%*]%f%k"
    VENV_NAME=$([[ -n "$VIRTUAL_ENV" ]] && echo "(%F{magenta}$(basename "$VIRTUAL_ENV")%f)" || echo "")
    FULL_PATH=$([[ $(id -u) -eq 0 ]] && echo "%K{red}%F{white} %/ %f%k" || echo "%K{cyan} %F{blue}%~%f %k")
    GIT_BRANCH=$([[ -f "$ZDOTDIR/prompt/git-status.zsh" ]] && git_prompt_segment || echo "")
    PROMPT_END=$([[ $(id -u) -eq 0 ]] && echo "%F{red}#%f" || echo "%F{yellow}\$%f")
    PROMPT="${PROMPT_TIME}${VENV_NAME}${FULL_PATH}${GIT_BRANCH} ${PROMPT_END} "
    RPROMPT="${ROOT_TAG}"
}
```

### 2. `git-status.zsh`

```zsh
# ~/.config/zsh/prompt/git-status.zsh
function git_prompt_segment() {
  local BRANCH_NAME GIT_STATUS ARROWS

  if git rev-parse --is-inside-work-tree &>/dev/null; then
    BRANCH_NAME=$(git symbolic-ref --short -q HEAD 2>/dev/null || echo "HEAD")
    BRANCH_NAME=$([[ "$BRANCH_NAME" == "HEAD" ]] && echo "%F{magenta}🪂DETACHED%f" || echo "%F{cyan}${BRANCH_NAME}%f")

    if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
      GIT_STATUS=" %F{blue}✨%f"
    else
      local DIRTY_COUNT=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
      GIT_STATUS=$([[ "$DIRTY_COUNT" -gt 0 ]] && echo " %F{red}✗%f" || echo " %F{green}✓%f")
    fi

    ARROWS=""
    if git rev-parse --symbolic-full-name --verify -q "@{u}" >/dev/null 2>&1; then
      read BEHIND AHEAD <<< "$(git rev-list --left-right --count @{u}...HEAD 2>/dev/null || echo "0 0")"
      [[ "$AHEAD" -gt 0 ]] && ARROWS+=" %F{red}↑$AHEAD%f"
      [[ "$BEHIND" -gt 0 ]] && ARROWS+=" %F{yellow}↓$BEHIND%f"
    else
      ARROWS+=" %F{244}⎋%f"
    fi

    [[ -f "$(git rev-parse --git-dir)/MERGE_HEAD" ]] && ARROWS+=" %F{208}🔀%f"
    [[ -d "$(git rev-parse --git-dir)/rebase-apply" || -d "$(git rev-parse --git-dir)/rebase-merge" ]] && ARROWS+=" %F{202}⟳%f"

    echo "[ ${BRANCH_NAME}${GIT_STATUS}${ARROWS} ]"
  fi
}
```

### 3. `zsh-prompt`

```zsh
# ~/.config/zsh/zsh-prompt
# Source this to wire up the dynamic prompt

source "$ZDOTDIR/prompt/git-status.zsh"
source "$ZDOTDIR/prompt/prompt.zsh"
```

---

## ✅ Features

* **Root/User Status:** Easily distinguish root sessions
* **Current Time:** Clock for better terminal awareness
* **Virtualenv name** appears inline
* **Git Branch with sync markers:**

  * ✓ clean / ✗ dirty
  * ↑ ahead / ↓ behind / ⎋ no upstream
  * 🔀 merge / ⟳ rebase
* **Path Highlighting:**

  * `~` for home
  * Full path or `/` for root sessions

---

## 📜 Bonus: Your `.zshrc` setup

Your `.zshrc` leverages a **modular plugin loader** via `zsh_add_file`, `zsh_add_plugin`, etc. That's great for clean config management!

Include `zsh-prompt` like this:

```zsh
zsh_add_file "zsh-prompt"
```

---

## 📌 Notes

* Make sure your `ZDOTDIR` is exported (e.g., in `env.zsh`) before anything else:

  ```zsh
  export ZDOTDIR="$HOME/.config/zsh"
  ```
* Colours assume support for 256-colour terminals (which most modern ones support).
* `git rev-parse` is heavily used to prevent false positives outside a repo.

---

## 🧪 Tested On

* macOS Terminal & iTerm2
* Ubuntu + Zsh
* Oh-My-Zsh optional

---

## 💡 Credits

Prompt ideas and implementation by Numan Syed with enhancements by ChatGPT based on real usage scenarios.

---

## 📂 Future Ideas

* Optional async Git check
* Show stash count or last commit
* Docker context / Kube context segments
* Prompt theme switcher (light/dark)

Enjoy your micro setup. Make your shell YOUR space! ☕
