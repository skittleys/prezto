#
# Loads prompt themes.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Extra functions for features in prompts
source "${ZDOTDIR:-$HOME}/modules/prompt/functions/get_short_path.zsh"
source "${ZDOTDIR:-$HOME}/modules/prompt/functions/git-omz.zsh" 


# Load and execute the prompt theming system.
autoload -Uz promptinit && promptinit

# Load the prompt theme.
zstyle -a ':prezto:module:prompt' theme 'prompt_argv'
if (( $#prompt_argv > 0 )); then
  prompt "$prompt_argv[@]"
else
  prompt 'off'
fi
unset prompt_argv

