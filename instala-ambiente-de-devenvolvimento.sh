#! /bin/bash

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DIRETORIO_DOWNLOADS="$HOME/downloads/programas"

instala_pkg_via_wget() {
    wget -c "$URL_GOOGLE_CHROME" -P "$DIRETORIO_DOWNLOADS"
    sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb
}

instala_git() {
    sudo apt update
    sudo apt install -y git
}

instala_docker() {
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt update
    apt-cache policy docker-ce
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # inicia o docker com o boot
    sudo usermod -aG docker ${USER}
    su - ${USER}
}

instala_vscode() {
    sudo snap install code --classic
}

instala_zsh() {
    sudo apt install -y zsh
    sudo chsh -s $(which zsh)
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    wget -c https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -P "$DIRETORIO_DOWNLOADS"
    mkdir $DIRETORIO_DOWNLOADS/fire_code
    unzip $DIRETORIO_DOWNLOADS/Fira_Code_v6.2.zip -d $DIRETORIO_DOWNLOADS/fire_code

    if [ ! -d $HOME/.local/share/fonts ]; then
        mkdir $HOME/.local
        mkdir $HOME/.local/share
        mkdir $HOME/.local/share/fonts
    fi

    cp $DIRETORIO_DOWNLOADS/fire_code/ttf/*.ttf $HOME/.local/share/fonts
    rm -r $DIRETORIO_DOWNLOADS/fire_code $DIRETORIO_DOWNLOADS/Fira_Code_v6.2.zip

    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
    ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

    sed 's/ZSH_THEME="robbyrussell"/ZSH_THEME="spaceship"/g' $HOME/.zshrc
}

# Gerencie várias versões de runtime com uma única ferramenta CLI
# https://asdf-vm.com/
instala_asdf() {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.2
    . $HOME/.asdf/asdf.sh
    . $HOME/.asdf/completions/asdf.bash

    asdf plugin-add dotnet-core https://github.com/emersonsoares/asdf-dotnet-core.git
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

    asdf install dotnet-core 6.0.405
    asdf install dotnet-core 3.1.426

    asdf install nodejs 18.13.0
    asdf install nodejs 16.9.1
    asdf install nodejs 14.21.2
}

check_ok() {
    echo "------------------------------------------------------------------------------------------------------"
    dotnet --version
    git --version
    docker --version
    zsh --version
}

main() {
    # instala dependencias
    sudo apt install -y wget curl snapd unzip
    sudo apt --fix-broken install

    if [ ! -d $DIRETORIO_DOWNLOADS ]; then
        sudo mkdir $HOME/downloads | sudo mkdir $DIRETORIO_DOWNLOADS
    fi

    instala_git
    instala_asdf
    instala_docker

    # instala_zsh

    ### para ambiente grafico
    # instala_pkg_via_wget
    # instala_vscode

    check_ok
}
main 2>logs.txt
if [ $? -eq 0 ]; then
    echo "Sucesso!"
else
    echo "Houve uma falha no processo!"
fi
