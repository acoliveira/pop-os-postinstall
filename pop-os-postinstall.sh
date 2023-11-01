#!/usr/bin/env bash
#
# pos-os-postinstall.sh - Instalar e configura programas no Pop!_OS (20.04 LTS ou superior)
#
# Website:       https://diolinux.com.br
# Autor:         Dionatan Simioni
#
# ------------------------------------------------------------------------ #
#
# COMO USAR?
#   $ ./pos-os-postinstall.sh
#
# ----------------------------- VARIÁVEIS ----------------------------- #
set -e

##URLS

#https://www.pling.com/p/2033080/
#https://www.youtube.com/watch?v=AnNx-Se9wkc&t=356s

#install conky-all jq moc lua5.3 build-essential libreadline-dev

#sudo nano /etc/environment >> MUFFIN_NO_SHADOWS=1

#Glava
#Correção do Glava
# https://www.youtube.com/watch?v=gol4iFL99go
# https://github.com/jarcode-foss/glava/pull/185/commits/a2d494319c824e676399df1d3c250baf4da87b83
# https://gitlab.com/wild-turtles-publicly-release/glava/glava.git

#sudo nala install libgl1-mesa-dev libpulse0 libpulse-dev libxext6 libxext-dev libxrender-dev libxcomposite-dev liblua5.3-dev lua-filesystem libobs0 libobs-dev meson build-essential gcc
#sudo ldconfig
#https://github.com/jarcode-foss/glava
#sudo apt-get install libgl1-mesa-dev libpulse0 libpulse-dev libxext6 libxext-dev libxrender-dev libxcomposite-dev liblua5.3-dev liblua5.3 lua-lgi lua-filesystem libobs0 libobs-dev meson build-essential gcc 



URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"
URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.24.3-1_amd64.deb?source=website"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_INSOMNIA="https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website"
URL_INSYNC="https://cdn.insynchq.com/builds/linux/insync_3.8.6.50504-lunar_amd64.deb"
URL_VSCODE="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
URL_NALA="https://gitlab.com/volian/nala/uploads/4509f695f7a531282e0d8aba71eb3134/nala_0.13.0_all.deb"

##DIRETÓRIOS E ARQUIVOS

DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"
FILE="/home/$USER/.config/gtk-3.0/bookmarks"


#CORES

VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'


#FUNÇÕES

# Atualizando repositório e fazendo atualização do sistema

apt_update()
{
  sudo apt update && sudo apt dist-upgrade -y
}

# -------------------------------------------------------------------------------- #
# -------------------------------TESTES E REQUISITOS----------------------------------------- #

# Internet conectando?
testes_internet()
{
  if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
    echo -e "${VERMELHO}[ERROR] - Seu computador não tem conexão com a Internet. Verifique a rede.${SEM_COR}"
    exit 1
  else
    echo -e "${VERDE}[INFO] - Conexão com a Internet funcionando normalmente.${SEM_COR}"
  fi
}

# ------------------------------------------------------------------------------ #

remover_ipv6()
{
## Removendo IPV6
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
  sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
}

## Removendo travas eventuais do apt ##
travas_apt()
{
  sudo rm /var/lib/dpkg/lock-frontend
  sudo rm /var/cache/apt/archives/lock
}

## Adicionando/Confirmando arquitetura de 32 bits ##
add_archi386()
{
  sudo dpkg --add-architecture i386
}

## Atualizando o repositório ##
just_apt_update()
{
  sudo apt update -y
}

##DEB SOFTWARES TO INSTALL

#curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
#sudo nala install speedtest

## gnuradio

PROGRAMAS_PARA_INSTALAR=(
  apt-transport-https
  build-essential
  cpu-x
  curl
  folder-color
  fonts-firacode
  git
  gnome-sushi
  gparted
  gufw
  hardinfo
  lutris
  nala
  neofetch
  notepadqq
  ratbagd
  ripgrep
  snapd
  solaar
  speedtest
  stacer
  steam-devices
  steam-installer
  synaptic
  terminator
  tilix
  timeshift
  ubuntu-restricted-extras
  v4l2loopback-utils
  virtualbox
  vlc
  wget
  winff
  zsh

)

# ---------------------------------------------------------------------- #

## Download e instalaçao de programas externos ##
install_debs()
{

  echo -e "${VERDE}[INFO] - Baixando pacotes .deb${SEM_COR}"

  mkdir "$DIRETORIO_DOWNLOADS"
  #wget -c "$URL_NALA"                -P "$DIRETORIO_DOWNLOADS" -O "nala.deb"
  #wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS" -O "chrome.deb"
  #wget -c "$URL_4K_VIDEO_DOWNLOADER" -P "$DIRETORIO_DOWNLOADS" -O "4kvideo.deb"
  wget -c "$URL_INSYNC"              -P "$DIRETORIO_DOWNLOADS" -O "insync.deb"
  wget -c "$URL_INSOMNIA"            -P "$DIRETORIO_DOWNLOADS" -O "insomnia.deb"
  #wget -c "$URL_VSCODE"              -P "$DIRETORIO_DOWNLOADS" -O "vscode.deb"

  ## Instalando pacotes .deb baixados na sessão anterior ##
  echo -e "${VERDE}[INFO] - Instalando pacotes .deb baixados${SEM_COR}"
  sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

  # Instalar programas no apt
  echo -e "${VERDE}[INFO] - Instalando pacotes apt do repositório${SEM_COR}"

  for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
    if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
      echo "============================================================================"
      echo "[INSTALANDO] - $nome_do_programa"
      echo "============================================================================"
      sudo apt install "$nome_do_programa" -y
    else
      echo "[INSTALADO] - $nome_do_programa"
    fi
  done

}

## Instalando pacotes Flatpak ##
install_flatpaks()
{

  echo -e "${VERDE}[INFO] - Instalando pacotes flatpak${SEM_COR}"

  flatpak install flathub com.bitwarden.desktop -y
  flatpak install flathub com.brave.Browser -y
  flatpak install flathub com.discordapp.Discord -y
  flatpak install flathub com.obsproject.Studio -y
  flatpak install flathub org.chromium.Chromium -y
  flatpak install flathub org.electrum.electrum -y
  flatpak install flathub org.flameshot.Flameshot -y
  flatpak install flathub org.freedesktop.Piper -y
  flatpak install flathub org.gimp.GIMP -y
  flatpak install flathub org.gnome.Boxes -y
  flatpak install flathub org.qbittorrent.qBittorrent -y
  flatpak install flathub org.telegram.desktop -y
  flatpak install flathub com.simplenote.Simplenote -y
}

## Instalando pacotes Snap ##
install_snaps()
{
  echo -e "${VERDE}[INFO] - Instalando pacotes snap${SEM_COR}"
  sudo snap install authy
}


# -------------------------------------------------------------------------- #
# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #


## Finalização, atualização e limpeza##
system_clean()
{
  apt_update -y
  flatpak update -y
  sudo apt autoclean -y
  sudo apt autoremove -y
  nautilus -q
}


# -------------------------------------------------------------------------- #
# ----------------------------- CONFIGS EXTRAS ----------------------------- #

#Cria pastas para produtividade no nautilus
extra_config()
{
  mkdir /home/$USER/TEMP
  #mkdir /home/$USER/EDITAR 
  #mkdir /home/$USER/Resolve
  mkdir /home/$USER/AppImage
  mkdir /home/$USER/Vídeos/'OBS Rec'

  #Adiciona atalhos ao Nautilus

  if test -f "$FILE"; then
      echo "$FILE já existe"
  else
      echo "$FILE não existe, criando..."
      touch /home/$USER/.config/gkt-3.0/bookmarks
  fi

  #echo "file:///home/$USER/EDITAR 🔵 EDITAR" >> $FILE
  echo "file:///home/$USER/AppImage" >> $FILE
  #echo "file:///home/$USER/Resolve 🔴 Resolve" >> $FILE
  echo "file:///home/$USER/TEMP 🕖 TEMP" >> $FILE
}

ohmyzsh()
{
  #https://ohmyz.sh/#install
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  
  #https://ruanklein.com/posts/instalando-oh-my-zsh-com-zinit/
  sh -c "$(curl -fsSL https://git.io/zinit-install)"
  zinit light zsh-users/zsh-autosuggestions
  zinit light zdharma-continuum/fast-syntax-highlighting
}

# -------------------------------------------------------------------------------- #
# -------------------------------EXECUÇÃO----------------------------------------- #

remover_ipv6
travas_apt
testes_internet
travas_apt
apt_update
travas_apt
add_archi386
just_apt_update
install_debs
install_flatpaks
install_snaps
extra_config
apt_update
system_clean

## finalização

echo -e "${VERDE}[INFO] - Script finalizado, instalação concluída! :)${SEM_COR}"
