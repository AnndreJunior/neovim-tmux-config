FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        bash \
        curl \
        git \
        sudo && \
    pacman -Sc --noconfirm

WORKDIR /app

CMD ["/bin/bash"]