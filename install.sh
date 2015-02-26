#!/usr/bin/env bash
function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ]; then
        if [ `readlink ${target}` == ${source} ]; then
            echo "Link already exist, skipping ..."
        return 2
        else
            echo "File exist, move to ${target}.bak"
            mv ${target} ${target}.bak
        fi
    fi

    ln -sf ${source} ${target}
}

if [ "$1" = "vim" ]; then
    for i in _vim*
    do
       link_file $i
    done
else
    for i in _*
    do
        link_file $i
    done
fi

git submodule sync
git submodule init
git submodule update
git submodule foreach git pull origin master
git submodule foreach git submodule init
git submodule foreach git submodule update

# setup command-t
cd _vim/bundle/command-t
rake make
