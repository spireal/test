#!/bin/bash

# ====================================================================================
#     Mises à jour du système
# ====================================================================================
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm base-devel sudo   #  Installation des paquets de base


# ====================================================================================
#     Installation et activation du serveur SSH (OpenSSH)
sudo pacman -S --noconfirm openssh
sudo systemctl enable --now sshd   # Active le service SSH au démarrage
#sudo systemctl start sshd    # Démarre le service SSH maintenant
# sudo ufw allow ssh
# ====================================================================================
# Installer les pilotes NVIDIA 
sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
# Activation du service Bluetooth
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

# ====================================================================================
#ne pas faire en root
# --- Telecharger yay depuis l'AUR 
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
# ============================================================
# --- Installer Pamac depuis l’AUR (interface graphique de gestion de paquets) ---
https://www.linuxtricks.fr/wiki/arch-linux-parametrer-aur-et-installer-pamac
#yay -S --noconfirm pamac-aur
# > pamac-manager
###  yay -S pamac-aur   all???
#   yay -S --noconfirm --needed pamac-all
# pr le lancer pamac-manager &


yay -S --noconfirm --answerclean All snapd

# --- Installer Flatpak et Snap depuis les dépôts officiels ---
sudo pacman -S --noconfirm flatpak 
yay -S --noconfirm --answerclean All snapd

#yay -S snapd



# --- Configurer Flathub (le dépôt principal Flatpak) ---
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# --- Activer snapd et lier les snaps pour les fichiers .desktop ---
sudo systemctl enable --now snapd.socket
sudo ln -sf /var/lib/snapd/snap /snap


