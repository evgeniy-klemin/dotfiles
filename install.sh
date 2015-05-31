#!/bin/bash


############# Deps, apps ##############
sudo apt-get install -y python-pip
sudo pip install argcomplete
sudo apt-get install -y tree


############# Bash-it ##############
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --none
if [ -h ~/.bash_profile ]; then
    rm -f ~/.bash_profile
fi
if [ -f ~/.bash_profile ]; then
    mv --backup ~/.bash_profile ~/.bash_profile.bak
fi
ln -s ~/dotfiles/home/.bash_profile ~/
source ~/.bash_it/bash_it.sh 2>/dev/null
# Aliases
bash-it enable alias ansible
bash-it enable alias clipboard
bash-it enable alias docker
bash-it enable alias git
bash-it enable alias tmux
bash-it enable alias vagrant
bash-it enable alias vim
# Plugins
bash-it enable plugin base
bash-it enable plugin docker
bash-it enable plugin git
bash-it enable plugin virtualenv
# Completion
bash-it enable completion bash-it
bash-it enable completion brew
bash-it enable completion defaults
bash-it enable completion dirs
bash-it enable completion django
bash-it enable completion fabric-completion
bash-it enable completion gem
bash-it enable completion git
bash-it enable completion gulp
bash-it enable completion pip
bash-it enable completion ssh
bash-it enable completion tmux
bash-it enable completion vagrant
bash-it enable completion virtualbox


############# Vim ##############
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


############# Tmux ##############
sudo apt-get install -y tmux
if [ -h ~/.tmux.conf ]; then
    rm -f ~/.tmux.conf
fi
if [ -f ~/.tmux.conf ]; then
    mv --backup ~/.tmux.conf ~/.tmux.conf.bak
fi
ln -s ~/dotfiles/home/.tmux.conf ~/
