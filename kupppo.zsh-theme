# vim:et sts=2 sw=2 ft=zsh
# Requires the `git-info` zmodule to be included in the .zimrc file.

# Colors
local col_mid
local col_fg
local col_unidx
local col_idx
local col_untrk
if (( terminfo[colors] >= 256 )); then
  col_mid="%F{${1:-237}}"
  col_fg="%F{${2:-231}}"
  col_unidx="%F{${3:-202}}"
  col_idx="%F{${4:-118}}"
  col_untrk="%F{${5:-197}}"
else
  col_mid="%F{${1:-grey}}"
  col_fg="%F{${2:-white}}"
  col_unidx="%F{${3:-yellow}}"
  col_idx="%F{${4:-green}}"
  col_untrk="%F{${5:-red}}"
fi

# Indentifier
local ind=${6:-•}

# Sections
local prefix="${col_mid}λ —%f"
local dir="${col_fg}%B%2~%b%f"

git_prompt() {
  [[ -n ${git_info} ]] && print -n "${(e)git_info[prompt]}"
}

# Setup
if (( ${+functions[git-info]} )); then
  autoload -Uz add-zsh-hook && add-zsh-hook precmd git-info

  zstyle ':zim:git-info' verbose 'yes'
  zstyle ':zim:git-info:branch' format "${col_fg}[%b]%f"
  zstyle ':zim:git-info:commit' format "(%c)"
  zstyle ':zim:git-info:action' format "(${col_idx}%s%f)"
  zstyle ':zim:git-info:unindexed' format "%B${col_unidx}${ind}%b"
  zstyle ':zim:git-info:indexed' format "%B${col_idx}${ind}%b"
  zstyle ':zim:git-info:untracked' format "%B${col_untrk}${ind}%b"
  zstyle ':zim:git-info:keys' format \
    'prompt' "%b %c%i%I%u%f "

  PS1='$prefix $dir $(git_prompt)%f%(!.#.$) '
  RPS1="${col_mid}%m — %*%f"
fi
