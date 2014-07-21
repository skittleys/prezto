# https://github.com/digitalformula/zsh.prompts/downloads
# required by agnoster theme

# function to get the short version of the current path
# requires PWD_LENGTH variable to be set
# defaults to 30, if not set
function get_short_path() {
    HOME_TILDE=~
    LONG_PATH=$(pwd)
    if [[ $LONG_PATH == $HOME_TILDE ]]; then
        LONG_PATH="~"
    elif [[ $HOME == ${LONG_PATH:0:${#HOME}} ]]; then
        LONG_PATH="~${LONG_PATH:${#HOME}}"
    fi

    # check to see if the prompt path length has been specified
    if [ ! -n "$PWD_LENGTH" ]; then
            export PWD_LENGTH=30
    fi


    if [ ${#LONG_PATH} -gt $PWD_LENGTH ]; then
            echo "...${LONG_PATH: -$PWD_LENGTH}"
    else
            echo $LONG_PATH
    fi
}