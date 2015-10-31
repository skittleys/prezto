#
# Loads prompt themes.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Extra functions for features in prompts
source "/usr/lib/prezto/modules/prompt/functions/get_short_path.zsh"
source "/usr/lib/prezto/modules/prompt/functions/git-omz.zsh" 
source "/usr/lib/prezto/modules/prompt/zsh-vcs-prompt/zshrc.sh" 

# Load and execute the prompt theming system.
autoload -Uz promptinit && promptinit

# Load the prompt theme.
zstyle -a ':prezto:module:prompt' theme 'prompt_argv'
if [[ "$TERM" == (dumb|linux|*bsd*) ]] || (( $#prompt_argv < 1 )); then
  prompt 'off'
else
  prompt "$prompt_argv[@]"
fi
unset prompt_argv
