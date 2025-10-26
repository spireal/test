#!/bin/bash
#version 25
 # ====================================================================================
# 🛠️  Mises à jour système
# ====================================================================================
sudo apt update && sudo apt upgrade -y
# ====================================================================================
# 📦 Installation de snapd et flatpak si nécessaires
# ====================================================================================
sudo apt install snapd flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# 🖥️  Environnements de bureau 
#sudo apt install -y cinnamon-desktop-environment gnome-tweaks
# ====================================================================================
#   #  apt install -y kde-full
# ====================================================================================
# 📦 Dépendances générales
# ====================================================================================
sudo apt install wget apt-transport-https software-properties-common -y
sudo apt install open-vm-tools open-vm-tools-desktop os-prober -y
sudo apt install openssh-server putty samba -y
#penser  a enableopen sshs ????
sudo apt install gparted synaptic -y

# ====================================================================================
# 🌐 Installation de Google Chrome
# ====================================================================================
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
sudo dpkg -i /tmp/google-chrome.deb || sudo apt --fix-broken install -y





# ====================================================================================
# 🛠️ Résolution des dépendances manquantes
# ====================================================================================
echo "🔄 Vérification et résolution des dépendances manquantes..."
sudo apt --fix-broken install -y




# Lancement du script d'installation
echo ""
echo "Lancement du script d'installation..."
chmod +x ./install-software.sh
./install-software.sh






#sudo apt install -y kew
# kew path "/nas/ds218/music/" # Définir le chemin de la bibliothèque musicale

# 💡 Note : alias vim=nvim et vi=nvim à envisager
# 👉 https://www.reddit.com/r/neovim/comments/1chdkpe/alias_vim_to_neovim_on_macos/?tl=fr

# ====================================================================================
# 🗄️ Backup
# ====================================================================================
# Exécution manuelle possible d’une sauvegarde GRUB
# sudo cp /boot/grub/grub.cfg ~/grub.cfg.backup.$date

