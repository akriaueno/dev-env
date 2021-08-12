FROM debian:buster
SHELL ["/bin/bash", "-l", "-c"]
ENV login_user='debian'
ENV SSH_AUTH_SOCK='/tmp/ssh-agent.sock'

RUN useradd --uid 61000 --create-home --shell /bin/sh -G sudo,root $login_user
RUN apt-get update && apt-get install -y sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $login_user
WORKDIR /home/$login_user
COPY --chown=$login_user:$login_user install.sh .
RUN echo 'yyy' | ./install.sh
RUN rm ./install.sh
CMD bash -login
