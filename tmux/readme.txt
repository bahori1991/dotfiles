how to install latest version of tmux
references:https://www.tohoho-web.com/ex/tmux.html

# Ubuntu 24.04
apt -y install curl gcc make libevent-dev ncurses-dev automake byacc

# Get tmux-*.tar.gz file
curl -kLO https://github.com/tmux/tmux/releases/download/3.6a/tmux-3.6a.tar.gz

# Extend tmux-*.tar.gz file
tar zxvf ./tmux-*.tar.gz

# Compile extended files
cd tmux-*
./configure
make
sudo make install

# Remove tar.gz and extended files
rm -rf ./tmux-*.tar.gz
rm -rf tmux-*
