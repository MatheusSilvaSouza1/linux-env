#! /bin/bash

URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DIRETORIO_DOWNLOADS="$HOME/downloads/programas"

# instala_dotnet() {
#     wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
#     sudo dpkg -i packages-microsoft-prod.deb
#     rm packages-microsoft-prod.deb
#     sudo apt update
#     sudo apt install -y apt-transport-https
#     sudo apt install -y dotnet-sdk-6.0 dotnet-sdk-3.1
# }

instala_pkg_via_wget() {
    if [ ! -d $DIRETORIO_DOWNLOADS ]; then
        sudo mkdir $HOME/downloads | sudo mkdir $DIRETORIO_DOWNLOADS
    fi

    wget -c "$URL_GOOGLE_CHROME" -P "$DIRETORIO_DOWNLOADS"
    sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb
    sudo rm -r $DIRETORIO_DOWNLOADS
}

instala_git() {
    sudo apt update
    sudo apt install -y git

    git config --global user.name "Matheus Silva" 
    git config --global user.email "matheus.silva@ferreiracosta.com"
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

    instala_git
    instala_asdf
    instala_docker

    instala_zsh

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
