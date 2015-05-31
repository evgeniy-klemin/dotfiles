#!/bin/bash

# Config bash
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --all
echo "export BASH_IT_THEME='envy'" > ~/.bash_profile
sudo pip install argcomplete
source ~/.bash_it/bash_it.sh 2>/dev/null
bash-it disable plugin chruby
bash-it disable plugin chruby-auto
bash-it disable plugin z
bash-it disable plugin postgress

# Config vim
sudo apt-get install -y vim
if [ -h ~/.vimrc ]; then
    rm -f ~/.vimrc
fi
if [ -f ~/.vimrc ]; then
    mv --backup ~/.vimrc ~/.vimrc.bak
fi
ln -s ~/dotfiles/home/.vimrc ~/
sudo sh -c "echo TERM=xterm-256color >> /etc/environment"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
sudo aptitude install exuberant-ctags
vim +BundleInstall +qa

# Config tmux
sudo apt-get install -y tmux
if [ -h ~/.tmux.conf ]; then
    rm -f ~/.tmux.conf
fi
if [ -f ~/.tmux.conf ]; then
    mv --backup ~/.tmux.conf ~/.tmux.conf.bak
fi
ln -s ~/dotfiles/home/.tmux.conf ~/
