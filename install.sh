#!/bin/bash


############# Deps, apps ##############
sudo apt-get install -y python-pip tree tmux
#sudo apt-get install -y vim


############# Vim ##############
if [ -h ~/.vimrc ]; then
    rm -f ~/.vimrc
fi
if [ -f ~/.vimrc ]; then
    mv --backup ~/.vimrc ~/.vimrc.bak
fi
ln -s ~/dotfiles/home/vimrc ~/.vimrc
sudo sh -c "echo TERM=xterm-256color >> /etc/environment"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
sudo aptitude install exuberant-ctags
vim +BundleInstall +qa


############# Tmux ##############
if [ -h ~/.tmux.conf ]; then
    rm -f ~/.tmux.conf
fi
if [ -f ~/.tmux.conf ]; then
    mv --backup ~/.tmux.conf ~/.tmux.conf.bak
fi
ln -s ~/dotfiles/home/tmux.conf ~/.tmux.conf


############# ZSH ##############
if [ -h ~/.zshrc ]; then
    rm -f ~/.zshrc
fi
if [ -f ~/.zshrc ]; then
    mv --backup ~/.zshrc ~/.zshrc.bak
fi
ln -s ~/dotfiles/home/zshrc ~/.zshrc
