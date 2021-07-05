#/bin/bash

which -s brew
if [[ $? != 0 ]]
then
    # Install brew
    echo 'Homebrew not installed, installing it now.'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo 'Homebrew installed, updating it.'
    brew update
fi


