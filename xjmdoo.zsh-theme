function return_status {
  echo -n "%(?,%{$fg_bold[green]%}$?,%{$fg_bold[red]%}$?)"
}

get_git_dirty() {
  git diff --quiet || echo '*'
}

function vcs_prompt {
    if jj root >/dev/null 2>&1; then
        id=$(jj log -n 1 -T 'self.change_id().shortest()' 2>/dev/null | sed 's/^[@[:space:]]*//')
        [[ -n "$id" ]] && echo "%F{magenta}[%F{green}${id}%F{magenta}]%f "
    else
        echo "${vcs_info_msg_0_}"
    fi
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*'   # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '%F{yellow}+'  # display this when there are staged changes
zstyle ':vcs_info:*' actionformats \
    '%F{5}%F{5}[%F{2}%b%F{3}|%F{1}%a%c%u%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}%F{5}[%F{2}%b%c%u%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git cvs svn

theme_precmd () {
    vcs_info
}

setopt prompt_subst
PROMPT='%{$fg[magenta]%}$(return_status)%{$reset_color%} %~/ %{$reset_color%}$(vcs_prompt)%{$reset_color%}'

autoload -U add-zsh-hook
add-zsh-hook precmd theme_precmd
