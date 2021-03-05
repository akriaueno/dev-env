#!/usr/bin/env bash -u
# expected OS is debian or ubuntu

REPO_PATH=$HOME/.dev-env
DOTFILES_PATH=$REPO_PATH/dotfiles
NVIM_PATH=$REPO_PATH/.config
PYENV_ROOT="$HOME/.pyenv"
PYTHON_VERSION=3.9.2
REQUIREMENTS="git neovim gcc make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl"
RECOMMENDED="bash-completion tmux"

install_recommended=0
rm_pyenvdir=0

ask_settings() {
  read -p "install $REQUIREMENTS ? (y/N): " yn
  case "$yn" in
    [yY]*) :;;
        *) echo "abort"; exit 1;;
  esac
  
  read -p "install $RECOMMENDED ? (y/N): " yn
  case "$yn" in
    [yY]*) install_recommended=1;;
        *) echo "not install recommended packages";;
  esac

  if [ -d $PYENV_ROOT ]; then
    read -p "remove $PYENV_ROOT ? (y/N): " yn
    case "$yn" in
      [yY]*) rm_pyenvdir=1;;
      *) echo "not remove $PYENV_ROOT";;
    esac
  fi
}

install_requirements () {
 sudo apt-get install -y $REQUIREMENTS;
}

check_shell () {
  ppid=$(ps -o ppid -p $$ | tail -n 1)
  ps -p $ppid | tail -n 1 | awk '
  match($0,/bash|zsh|fish|tcsh/) {
    print substr($0,RSTART,RLENGTH)
  }'
}

install_recommended () {
  if [ "$install_recommended" = 1 ]; then
    sudo apt-get install -y $RECOMMENDED
  fi
}

get_repo () {
  if [ -d "$REPO_PATH" ]; then
    cd $REPO_PATH
    git pull
    cd -
  else
    git clone https://github.com/akriaueno/dev-env.git $REPO_PATH
  fi
}

install_dotfiles () {
  ln -sb $DOTFILES_PATH/.profile $HOME
  ln -sb $DOTFILES_PATH/.bashrc $HOME
  ln -sb $DOTFILES_PATH/.config/nvim $HOME
  ln -sb $DOTFILES_PATH/.tmux.conf $HOME
  ln -sb $DOTFILES_PATH/.gitconfig $HOME
  ln -sb $DOTFILES_PATH/.git-completion.bash $HOME
  ln -sb $DOTFILES_PATH/.git-prompt.sh $HOME
  . $HOME/.profile
}

install_pyenv () {
  if [ "$install_recommended" = 1 ]; then
    rm -rf $PYENV_ROOT
  fi
  curl https://pyenv.run | bash
  . $HOME/.profile
  pyenv install $PYTHON_VERSION
}

mk_nvim_env () {
  cd $NVIM_PATH/python3
  python -m venv venv
  pip isntall -r requirements.txt
  cd -
}

shell=$(check_shell)
if [ "$shell" != 'bash' ]; then
  echo "run bash"
  exit 1
fi

set -x
pwd=$(pwd)
cd $HOME
ask_settings         || exit 1 &&
sudo apt-get update  || exit 1 &&
install_recommended  || exit 1 &&
install_requirements || exit 1 &&
get_repo             || exit 1 &&
install_dotfiles     || exit 1 &&
install_pyenv        || exit 1 &&
mk_nvim_env          || exit 1 &&
exec -l bash
cd $pwd
set +x
