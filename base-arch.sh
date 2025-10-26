#!/bin/bash

BASE_DIR=$(pwd)

# ============================================================
# Définir le fuseau horaire Europe/Paris
sudo ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime    
#sudo hwclock --systohc   => # Synchroniser l’horloge matérielle (BIOS/UEFI) avec l’horloge système

# ============================================================
#  MISE À JOUR DU SYSTÈME ET PAQUETS DE BASE
# ============================================================

# Mise à jour complète du système
sudo pacman -Syu --noconfirm

# Installation des paquets de base essentiels
sudo pacman -S --needed --noconfirm base-devel git
# Préparation du dossier pour les clones AUR
user=spire
mkdir -p /home/$user/git
# ============================================================
#  INSTALLATION ET CONFIGURATION SSH (OpenSSH)
# ============================================================

# Installation d'OpenSSH
sudo pacman -S --noconfirm openssh

# Activation et démarrage du service SSH
sudo systemctl enable --now sshd

# Optionnel : Autoriser SSH dans le pare-feu (si UFW est installé)
# sudo ufw allow ssh
###############################################################################################################################################################################
# ============================================================
#  INSTALLATION DE YAY (Gestionnaire AUR)
# ============================================================
# Important : Exécutez ce script en tant qu'utilisateur normal, pas en root
cd /home/$user/git
# Clonage et installation de yay
git clone https://aur.archlinux.org/yay.git
cd yay
yes 'o' | makepkg -sri --noconfirm --needed --nocheck
#makepkg -si 
#yay --version
# ============================================================
#  INSTALLATION DE PAMAC (Gestionnaire de paquets graphique) 
# pamac-manager &
# ============================================================

yay -S --noconfirm --needed pamac-all


# ============================================================
#  INSTALLATION DE FLATPAK (Support des paquets Flatpak)
# ============================================================

sudo pacman -S --noconfirm flatpak

# Configuration du dépôt Flathub
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# ============================================================
#  INSTALLATION DE SNAPD (Support des paquets Snap)
# Note: N'utilisez pas "yay -S snapd" (installation basique non automatisée)
# ============================================================
export PATH=$PATH:/var/lib/snapd/snap/bin

yay -S --noconfirm --answerclean All snapd

# Activation du service snapd
sudo systemctl enable --now snapd.socket

# Création du lien symbolique pour /snap
sudo ln -sf /var/lib/snapd/snap /snap

 ###############################################################################################################################################################################  



# Lancement du script d'installation
cd "$BASE_DIR"
echo ""
echo "Lancement du script d'installation..."
chmod +x ./install-software.sh
./install-software.sh


