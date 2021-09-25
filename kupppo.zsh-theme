# vim:et sts=2 sw=2 ft=zsh
#
# A customizable version of the steeef theme from
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/steeef.zsh-theme
#
# Requires the `git-info` zmodule to be included in the .zimrc file.

prompt_kupppo_git() {
  [[ -n ${git_info} ]] && print -n " ${(e)git_info[prompt]}"
}

prompt_kupppo_rgit() {
  [[ -n ${git_info} ]] && print -n " ${(e)git_info[rprompt]}"
}

prompt_kupppo_virtualenv() {
  [[ -n ${VIRTUAL_ENV} ]] && print -n " [%F{green}${VIRTUAL_ENV:t}%f]"
}

prompt_kupppo_precmd() {
  (( ${+functions[git-info]} )) && git-info
}

prompt_kupppo_setup() {
  [[ -n ${VIRTUAL_ENV} ]] && export VIRTUAL_ENV_DISABLE_PROMPT=1

  local col_user
  local col_mid
  local col_fg
  local col_unidx
  local col_idx
  local col_untrk
  # use extended color palette if available
  if (( terminfo[colors] >= 256 )); then
    col_user="%F{${1:-135}}"
    col_mid="%F{${2:-237}}"
    col_fg="%{%F{white}%}"
    col_unidx="%F{${5:-166}}"
    col_idx="%F{${7:-118}}"
    col_untrk="%F{${9:-161}}"
  else
    col_user="%F{${1:-magenta}}"
    col_mid="%F{${2:-grey}}"
    col_fg="%F{${3:-white}}"
    col_unidx="%F{${5:-yellow}}"
    col_idx="%F{${7:-green}}"
    col_untrk="%F{${9:-red}}"
  fi
  local ind_unidx=${6:-●}
  local ind_idx=${8:-●}
  local ind_untrk=${10:-●}
  local col_stash=${11:+%F{${11}}}
  local ind_stash=${12}

  autoload -Uz add-zsh-hook && add-zsh-hook precmd prompt_kupppo_precmd

  prompt_opts=(cr percent sp subst)

  zstyle ':zim:git-info' verbose 'yes'
  zstyle ':zim:git-info:branch' format "${col_fg}[%b]%f"
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:action' format "(${col_idx}%s%f)"
  zstyle ':zim:git-info:unindexed' format "${col_unidx}${ind_unidx}"
  zstyle ':zim:git-info:indexed' format "${col_idx}${ind_idx}"
  zstyle ':zim:git-info:untracked' format "${col_untrk}${ind_untrk}"
  if [[ -n ${ind_stash} ]]; then
    zstyle ':zim:git-info:stashed' format "${col_stash}${ind_stash}"
  fi
  zstyle ':zim:git-info:keys' format \
    'prompt' "%c%I%i%u%f%S%f%s" \
    'rprompt' "%b"

  PS1="${col_mid}λ —%f ${col_fg}%B%2~%b%f\$(prompt_kupppo_git)%f\$(prompt_kupppo_virtualenv)%(!.#.) "
  RPS1="\$(prompt_kupppo_rgit) ${col_mid}%*%f"

}

prompt_kupppo_setup "${@}"
