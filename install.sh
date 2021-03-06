#!/usr/bin/env bash
# expected OS is debian or ubuntu

REPO_PATH=$HOME/.dev-env
DOTFILES_PATH=$REPO_PATH/dotfiles
NVIM_PATH=$HOME/.config/nvim
PYENV_ROOT=$HOME/.pyenv
PYTHON_VERSION=3.9.2
REQUIREMENTS="git neovim gcc make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl"
RECOMMENDED="bash-completion tmux"

install_recommended=0
rm_pyenvdir=0

ask_settings() {
  read -n1 -p "install $REQUIREMENTS ? (y/N): " yn
  case "$yn" in
    [yY]*) :;;
        *) echo "abort"; exit 1;;
  esac
  
  read -n1 -p "install $RECOMMENDED ? (y/N): " yn
  case "$yn" in
    [yY]*) install_recommended=1;;
        *) echo "not install recommended packages";;
  esac

  if [ -d $PYENV_ROOT ]; then
    read -n1 -p "remove $PYENV_ROOT ? (y/N): " yn
    case "$yn" in
      [yY]*) rm_pyenvdir=1;;
      *) echo "not remove $PYENV_ROOT";;
    esac
  fi
}

install_requirements () {
 sudo apt-get install -y $REQUIREMENTS
}

install_recommended () {
  if [ "$install_recommended" = 1 ]; then
    sudo apt-get install -y $RECOMMENDED
  fi
}

get_repo () {
  if [ -d "$REPO_PATH" ]; then
    cd $REPO_PATH || exit 1
    git pull
    cd - || exit 1
  else
    git clone https://github.com/akriaueno/dev-env.git $REPO_PATH
  fi
}

install_dotfiles () {
  ln -sb $DOTFILES_PATH/.profile             $HOME
  ln -sb $DOTFILES_PATH/.bashrc              $HOME
  ln -sb $DOTFILES_PATH/.bash_aliases        $HOME
  ln -sb $DOTFILES_PATH/.config              $HOME
  ln -sb $DOTFILES_PATH/.tmux.conf           $HOME
  ln -sb $DOTFILES_PATH/.gitconfig           $HOME
  ln -sb $DOTFILES_PATH/.git-completion.bash $HOME
  ln -sb $DOTFILES_PATH/.git-prompt.sh       $HOME
  . $HOME/.profile
}

install_pyenv () {
  if [ "$rm_pyenvdir" = 1 ]; then
    rm -rf $PYENV_ROOT
  fi
  curl https://pyenv.run | bash
  $PYENV_ROOT/bin/pyenv install $PYTHON_VERSION
}

install_cargo () {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

mk_nvim_env () {
  PYTHON3=$PYENV_ROOT/versions/$PYTHON_VERSION/bin/python
  PIP=$NVIM_PATH/python3/venv/bin/pip
  mkdir -p $NVIM_PATH/python3
  cd $NVIM_PATH/python3 &&
  $PYTHON3 -m venv venv &&
  $PIP install -r requirements.txt &&
  nvim -e +":UpdateRemotePlugins" +:q
  cd -
}

set -x
predir=$(pwd)
cd "${HOME}"         || exit 1
ask_settings         || exit 1
sudo apt-get update  || exit 1
install_recommended  || exit 1
install_requirements || exit 1
get_repo             || exit 1
install_dotfiles     || exit 1

prll_pids=()
(install_pyenv && mk_nvim_env || exit 1)&
prll_pids+=($!)
(install_cargo                || exit 1)&
prll_pids+=($!)

for pid in ${prll_pids[@]}; do
  wait $pid; stat=$?
  if [ $stat -ne 0 ]; then
    kill ${prll_pids[@]} 2> /dev/null
    echo "error occured"
    exit $stat
  fi
done

cd $predir           || exit 1
set +x
