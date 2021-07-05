#!/bin/zsh


BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
RED='\033[0;31m'
LIGHT_RED='\033[1;31m'
GREEN='\033[0;32m'
LIGHT_GREEN='\033[1;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m'

FW_BOLD=$(tput bold)
FW_NORMAL=$(tput sgr0)

if [[ -n $1 || $1 != "--only-link" ]]
then
    echo "\n${YELLOW}${FW_BOLD}|> Checking Homebrew installation${NC}${FW_NORMAL}"
    which -s brew
    if [[ $? != 0 ]]
    then
        # Install brew
        echo "${BLUE}|-->${NC} ${FW_BOLD}Homebrew${FW_NORMAL} not installed, installing it now"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if [[ $(uname -s) == "Linux" ]]
        then
            test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
            test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
            test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
            echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
        fi

        which -s brew
        if [[ $? != 0 ]]
        then
            # brew still not installed
            echo "${RED}|--> Couldn't install ${FW_BOLD}Homebrew${FW_NORMAL}${RED}, exitting${NC}"
            exit 1
        else
            echo "${GREEN}|--> ${FW_BOLD}Homebrew${FW_NORMAL}${GREEN} installed successfully${NC}"
        fi
    else
        echo "${BLUE}|-->${NC} ${FW_BOLD}Homebrew${FW_NORMAL} installed, updating it"
        #brew update
    fi

    echo "\n${YELLOW}${FW_BOLD}|> Installing Homebrew packages${NC}${FW_NORMAL}"
    failedPackages=""
    for package in $(cat $(dirname $0)/packages.list)
    do
        #break
        if [[ -z $package ]]; then continue; fi

        if brew ls --versions "$package" > /dev/null
        then
            echo "${BLUE}|-->${NC} Package ${FW_BOLD}${package}${FW_NORMAL} is installed"
        else
            echo "${BLUE}|-->${NC} Package ${FW_BOLD}${package}${FW_NORMAL} is not installed"
            echo "${BLUE}|-->${NC} Installing ${FW_BOLD}${package}${FW_NORMAL}"
            brew install "$package"

            if brew ls --versions "$package" > /dev/null
            then
                echo "${GREEN}|--> Installed ${FW_BOLD}${package}${FW_NORMAL}${NC}"
            else
                echo "${RED}|--> Failed to install ${FW_BOLD}${package}${FW_NORMAL}${NC}"
                failedPackages+="${package}\n"
            fi
        fi
    done

    if [[ -n "$failedPackages" ]]
    then
        echo "\n${RED}|> Failed to install packages"
        echo "${RED}|> Try once more or install the packages manually and run the script again"
        echo "${RED}${FW_BOLD}|> Failed packages are:${FW_NORMAL}${NC}"

        for package in "$failedPackages"
        do
            echo "${BLUE}|-->${NC} ${FW_BOLD}${package}${FW_NORMAL}"
        done

        echo "${RED}${FW_BOLD}Quitting${NC}${FW_NORMAL}"
        exit 2
    else
        echo "${GREEN}|> All packages installed successfully${NC}"
    fi

    BASE_DIR=""
    if [[ -f "./packages.list" ]]
    then
        BASE_DIR=$(pwd)
    else
        url=$(dirname $0)
        if [[ -f "${url}/packages.list" ]]
        then
            BASE_DIR="$url"
        fi
    fi

    if [[ -z "${BASE_DIR}" ]]
    then
        echo "${RED}|> Couldn't find setup folder, quitting${NC}"
        exit 3
    fi
fi


ZSHRC_SUCCESS=1
echo "\n${YELLOW}${BOLD}|> Writing .zshrc and .vimrc${NC}${FW_NORMAL}"
echo "source ${BASE_DIR}/.zshrc" > ~/.zshrc
if [[ $? != 0 ]]
then
    echo "${RED}|--> Failed to create ${FW_BOLD}.zshrc${FW_NORMAL}${RED} file"
    echo "${RED}|--> To solve this, create a ${FW_BOLD}.zshrc${FW_NORMAL}${RED} file in your home directory ${FW_BOLD}(${HOME})${FW_NORMAL}${RED} with this content:"
    echo "${RED}|-->"
    echo "${RED}|-->\t\t${LIGHT_RED}source ${BASE_DIR}/.zshrc"
    echo "${RED}|-->"
    ZSHRC_SUCCESS=0
else
    echo "${GREEN}|--> Successfully wrote ${BOLD}.zshrc${FW_NORMAL}${NC}"
fi

echo "source ${BASE_DIR}/.vimrc" > ~/.vimrc
if [[ $? != 0 ]]
then
    if [[ $ZSHRC_SUCCESS == 0 ]]; then echo ""; fi
    echo "${RED}|--> Failed to create ${FW_BOLD}.vimrc${FW_NORMAL}${RED} file"
    echo "${RED}|--> To solve this, create a ${FW_BOLD}.vimrc${FW_NORMAL}${RED} file in your home directory ${FW_BOLD}(${HOME})${FW_NORMAL}${RED} with this content:"
    echo "${RED}|-->"
    echo "${RED}|-->\t\t${LIGHT_RED}source ${BASE_DIR}/.vimrc"
    echo "${RED}|-->"
else
    echo "${GREEN}|--> Successfully wrote ${BOLD}.vimrc${FW_NORMAL}${NC}"
fi

echo "source ${BASE_DIR}/.vimrc" > ~/.vimrc
