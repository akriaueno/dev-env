#!/usr/bin/env bash
# expected OS is debian or ubuntu

REPO_PATH=$HOME/.dev-env
DOTFILES_PATH=$REPO_PATH/dotfiles
NVIM_PATH=$REPO_PATH/.config
PYTHON_VERSION=3.9.2

check_shell () {
  ppid=$(ps -o ppid -p $$ | tail -n 1)
  ps -p $ppid | tail -n 1 | awk '
  match($0,/bash|zsh|fish|tcsh/) {
    print substr($0,RSTART,RLENGTH)
  }'
}

install_recommended_packages () {
  packages="bash-completion tmux"
  read -p "install $packages ? (y/N): " yn
  case "$yn" in
    [yY]*) set -x; sudo apt-get install $packages; set +x;;
    *) echo "not installed recommended packages";;
  esac
}


check_requirements () {
  requirements="
git neovim gcc make build-essential libssl-dev zlib1g-dev
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm
libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev
liblzma-dev python-openssl
"
  read -p "install $requirements ? (y/N): " yn
  case "$yn" in
    [yY]*) set -x; sudo apt-get install "$requirements"; set +x;;
    *) echo "abort"; exit 1;;
  esac
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
}

install_pyenv () {
  PYENV_ROOT="$HOME/.pyenv"
  if [ -d $PYENV_ROOT ]; then
    read -p "remove $PYENV_ROOT ? (y/N): " yn
    case "$yn" in
      [yY]*) rm -rf $PYENV_ROOT;;
      *) echo "not remove $PYENV_ROOT";;
    esac
  fi
  curl https://pyenv.run | bash &&
  . $HOME/.profile &&
  pyenv install $PYTHON_VERSION
}

mk_nvim_env () {
  cd $NVIM_PATH/python3
  python -m venv venv &&
  pip isntall -r requirements.txt
  cd -
}

shell=$(check_shell)
if [ "$shell" != 'bash' ]; then
  echo "run bash"
  exit 1
fi

pwd=$(pwd)
cd $HOME
install_recommended_packages &&
check_requirements &&
get_repo &&
install_dotfiles &&
install_pyenv &&
mk_nvim_env &&
exec -l bash
cd $pwd
