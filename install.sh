#!/usr/bin/env bash
# expected OS is debian or ubuntu

REPO_PATH=$HOME/.dev-env
DOTFILES_PATH=$REPO_PATH/dotfiles
NVIM_PATH=$REPO_PATH/.config
PYTHON_VERSION=3.9.2

shell_checker () {
  ppid=$(ps -o ppid -p $$ | tail -n 1)
  ps -p $ppid | tail -n 1 | awk '
  match($0,/bash|zsh|fish|tcsh/) {
    print substr($0,RSTART,RLENGTH)
  }'
}

check_requirements () {
  requirements=(git curl)
  unmet=''
  for v in ${requirements[@]}; do
    type $v > /dev/null 2>&1 || unmet+=" $v"
  done
  if [ "$unmet" = '' ]; then
    return
  fi
  echo "not installed $unmet"
  read -p "install $unmet ? (y/N): " yn
  case "$yn" in
    [yY]*) set -x; sudo apt-get install $unmet; set +x;;
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

install_recommended_packages () {
  packages="bash-completion neovim tmux"
  read -p "install $packages ? (y/N): " yn
  case "$yn" in
    [yY]*) set -x; sudo apt-get install $packages; set +x;;
    *) echo "not installed recommended packages";;
  esac
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
  curl https://pyenv.run | bash &&
  exec -l bash &&
  pyenv install $PYTHON_VERSION
}

mk_nvim_env () {
  cd $NVIM_PATH/python3
  python -m venv venv &&
  pip isntall -r requirements.txt
  cd -
}

shell=$(shell_checker)
if [ "$shell" != 'bash' ]; then
  echo "run bash"
  exit 1
fi

pwd=$(pwd)
cd $HOME
check_requirements &&
install_recommended_packages &&
get_repo &&
install_dotfiles &&
install_pyenv &&
mk_nvim_env &&
exec -l bash
cd $pwd
