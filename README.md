# dev-env
[![CI](https://github.com/akriaueno/dev-env/actions/workflows/ci.yml/badge.svg)](https://github.com/akriaueno/dev-env/actions/workflows/ci.yml)
[![BCH compliance](https://bettercodehub.com/edge/badge/akriaueno/dev-env?branch=main)](https://bettercodehub.com/)

development environment

## Docker
```
docker run -v $HOME/docker/project:/home/debian/project -it --rm ghcr.io/akriaueno/dev-env:main
```

## Debian
### short version
``` bash
bash <(curl -sL https://git.io/akriaueno-install.sh)
```

### long version
``` bash
bash <(curl -s https://raw.githubusercontent.com/akriaueno/dev-env/main/install.sh)
```

### no intaractive
``` bash
echo "yyy" | bash <(curl -sL https://git.io/akriaueno-install.sh)
```
