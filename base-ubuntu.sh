#!/bin/bash
#version 23 sans snap/flatpak
 # ====================================================================================
# 🛠️  Mises à jour système
# ====================================================================================
sudo apt update && sudo apt upgrade -y
# ====================================================================================
# 📦 Installation de snapd et flatpak si nécessaires
# ====================================================================================
sudo apt install snapd flatpak -y
# ====================================================================================

# ====================================================================================

# 🖥️  Environnements de bureau 
#sudo apt install -y cinnamon-desktop-environment gnome-tweaks
# ====================================================================================
#   #  apt install -y kde-full
# ====================================================================================
# 📦 Dépendances générales
# ====================================================================================
sudo apt install wget apt-transport-https software-properties-common -y

# ====================================================================================
# 🌐 Installation de Google Chrome
# ====================================================================================
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
sudo dpkg -i /tmp/google-chrome.deb || sudo apt --fix-broken install -y

# ====================================================================================
# 🧰 Outils de virtualisation
# ====================================================================================
sudo apt install open-vm-tools open-vm-tools-desktop os-prober -y


# ====================================================================================
# 📁 Gestion de fichiers et accès distant
#penser  a enableopen sshs
# ====================================================================================
sudo apt install openssh-server putty samba -y


# ====================================================================================
# 💽 Gestion de disque et paquets
# ====================================================================================
sudo apt install gparted synaptic -y



# ====================================================================================
# 🛠️ Résolution des dépendances manquantes
# ====================================================================================
echo "🔄 Vérification et résolution des dépendances manquantes..."
sudo apt --fix-broken install -y





# ====================================================================================
# 🖥️ Installation de TeamViewer
echo "🔧 Téléchargement de TeamViewer..."
wget -q https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -O /tmp/teamviewer.deb

echo "📦 Installation du paquet .deb..."
sudo dpkg -i /tmp/teamviewer.deb || sudo apt --fix-broken install -y

echo "⚙️ Activation et démarrage du service teamviewerd..."
sudo systemctl enable --now teamviewerd

echo "✅ Installation terminée. Version installée :"
teamviewer --version


echo "🔍 Récupération de l'ID TeamViewer..."
teamviewer info | grep "TeamViewer ID" | awk -F': ' '{print "🆔 ID TeamViewer :", $2}'
# ====================================================================================



sudo apt install -y kew
kew path "/nas/ds218/music/" # Définir le chemin de la bibliothèque musicale








# 💡 Note : alias vim=nvim et vi=nvim à envisager
# 👉 https://www.reddit.com/r/neovim/comments/1chdkpe/alias_vim_to_neovim_on_macos/?tl=fr

# ====================================================================================
# 🗄️ Backup
# ====================================================================================
# Exécution manuelle possible d’une sauvegarde GRUB
# sudo cp /boot/grub/grub.cfg ~/grub.cfg.backup.$date

