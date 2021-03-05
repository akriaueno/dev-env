# dev-env
development environment

## install
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

### docker
```
echo "<github access token>" | sudo docker login https://docker.pkg.github.com -u <github username> --password-stdin
docker run -it docker.pkg.github.com/akriaueno/dev-env/dev-env:main
```
