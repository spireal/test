#!/bin/bash

# ============================================================
#  INSTALLATION MULTI-OS DE CONKY, CONKY MANAGER ET THEMES
#  Compatible: Arch Linux, Debian/Ubuntu, Rocky Linux/RHEL
#  Installation complète automatique sans menu
# ============================================================

set -e

user=${SUDO_USER:-$USER}

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Détection du système d'exploitation ===${NC}"

# Détection de la distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
else
    echo -e "${RED}Impossible de détecter le système d'exploitation${NC}"
    exit 1
fi

echo -e "${GREEN}Distribution détectée: $OS${NC}"

# ============================================================
# INSTALLATION DE CONKY
# ============================================================

install_conky() {
    echo -e "${GREEN}=== Installation de Conky ===${NC}"
    
    case $OS in
        arch|manjaro|endeavouros)
            echo -e "${YELLOW}Installation via pacman...${NC}"
            sudo pacman -S --needed --noconfirm conky
            ;;
            
        ubuntu|debian|linuxmint|pop)
            echo -e "${YELLOW}Installation via apt...${NC}"
            sudo apt update
            sudo apt install -y conky-all
            ;;
            
        rocky|rhel|centos|fedora|almalinux)
            echo -e "${YELLOW}Installation via dnf/yum...${NC}"
            if command -v dnf &> /dev/null; then
                sudo dnf install -y conky
            else
                sudo yum install -y conky
            fi
            ;;
            
        *)
            echo -e "${RED}Distribution non supportée: $OS${NC}"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}✓ Conky installé avec succès${NC}"
}

# ============================================================
# INSTALLATION DE CONKY MANAGER 2
# ============================================================

install_conky_manager() {
    echo -e "${GREEN}=== Installation de Conky Manager 2 ===${NC}"
    
    case $OS in
        arch|manjaro|endeavouros)
            echo -e "${YELLOW}Installation via AUR (yay)...${NC}"
            
            # Vérifier si yay est installé
            if ! command -v yay &> /dev/null; then
                echo -e "${YELLOW}Installation de yay...${NC}"
                sudo pacman -S --needed --noconfirm git base-devel
                cd /tmp
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
                cd ..
                rm -rf yay
            fi
            
            yay -S --noconfirm --needed conky-manager2
            ;;
            
        ubuntu|debian|linuxmint|pop|rocky|rhel|centos|fedora|almalinux)
            echo -e "${YELLOW}Compilation depuis les sources...${NC}"
            
            # Installation des dépendances
            if [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]] || [[ "$OS" == "linuxmint" ]] || [[ "$OS" == "pop" ]]; then
                sudo apt update
                sudo apt install -y git cmake g++ libgtk-3-dev libglib2.0-dev \
                    libcurl4-openssl-dev valac libgee-0.8-dev libjson-glib-dev gettext
            else
                if command -v dnf &> /dev/null; then
                    sudo dnf install -y git cmake gcc-c++ gtk3-devel glib2-devel \
                        libcurl-devel vala libgee-devel json-glib-devel gettext
                else
                    sudo yum install -y git cmake gcc-c++ gtk3-devel glib2-devel \
                        libcurl-devel vala libgee-devel json-glib-devel gettext
                fi
            fi
            
            # Cloner et compiler Conky Manager 2
            cd /tmp
            if [ -d "conky-manager2" ]; then
                rm -rf conky-manager2
            fi
            git clone https://github.com/zcot/conky-manager2.git
            cd conky-manager2
            make
            sudo make install
            cd ..
            rm -rf conky-manager2
            ;;
    esac
    
    echo -e "${GREEN}✓ Conky Manager 2 installé avec succès${NC}"
}

# ============================================================
# INSTALLATION DES THEMES AUREOLA
# ============================================================

install_aureola_themes() {
    echo -e "${GREEN}=== Installation des thèmes Aureola ===${NC}"
    
    # Cloner le dépôt Aureola
    cd /home/$user
    
    if [ -d "Aureola" ]; then
        echo -e "${YELLOW}Le dossier Aureola existe déjà, mise à jour...${NC}"
        cd Aureola
        sudo -u $user git pull
    else
        echo -e "${YELLOW}Clonage du dépôt Aureola...${NC}"
        sudo -u $user git clone https://github.com/erikdubois/Aureola
        cd Aureola
    fi
    
    # Rendre le script exécutable et l'exécuter
    chmod +x get-aureola-from-github-to-local-drive-v1.sh
    sudo -u $user ./get-aureola-from-github-to-local-drive-v1.sh
    
    echo -e "${GREEN}✓ Thèmes Aureola installés avec succès${NC}"
}

# ============================================================
# CONFIGURATION DU THEME ASURA
# ============================================================

configure_asura_theme() {
    echo -e "${GREEN}=== Configuration du thème Asura ===${NC}"
    
    # Vérifier si le thème existe
    if [ ! -d "/home/$user/.aureola/asura" ]; then
        echo -e "${RED}Le thème Asura n'a pas été trouvé${NC}"
        return 1
    fi
    
    # Modifier le format d'heure (12h -> 24h)
    echo -e "${YELLOW}Configuration du format d'heure en 24h...${NC}"
    sed -i 's/\${time %I:%M}/\${time %H:%M}/g' /home/$user/.aureola/asura/conky.conf
    
    # Installer le thème
    cd /home/$user/.aureola/asura
    chmod +x install-conky.sh
    sudo -u $user ./install-conky.sh
    
    echo -e "${GREEN}✓ Thème Asura configuré et installé${NC}"
}

# ============================================================
# COPIE DE LA CONFIGURATION PAR DEFAUT
# ============================================================

setup_default_config() {
    echo -e "${GREEN}=== Configuration par défaut de Conky ===${NC}"
    
    # Chercher le fichier de configuration par défaut
    if [ -f /etc/conky/conky.conf ]; then
        CONFIG_SOURCE=/etc/conky/conky.conf
    elif [ -f /usr/share/doc/conky/conky.conf ]; then
        CONFIG_SOURCE=/usr/share/doc/conky/conky.conf
    else
        echo -e "${YELLOW}Fichier de configuration par défaut non trouvé, création d'un fichier minimal...${NC}"
        sudo -u $user conky -C > /home/$user/.conkyrc 2>/dev/null || true
        return
    fi
    
    if [ ! -f /home/$user/.conkyrc ]; then
        cp $CONFIG_SOURCE /home/$user/.conkyrc
        chown $user:$user /home/$user/.conkyrc
        echo -e "${GREEN}✓ Configuration par défaut copiée${NC}"
    else
        echo -e "${YELLOW}Le fichier .conkyrc existe déjà, pas de modification${NC}"
    fi
}

# ============================================================
# EXECUTION COMPLETE AUTOMATIQUE
# ============================================================

main() {
    # Vérifier si le script est exécuté en root pour les installations
    if [ "$EUID" -eq 0 ] && [ -z "$SUDO_USER" ]; then
        echo -e "${RED}Ne pas exécuter ce script directement en tant que root${NC}"
        echo -e "${YELLOW}Utilisez: sudo ./install-conky.sh${NC}"
        exit 1
    fi
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  INSTALLATION COMPLETE AUTOMATIQUE DE CONKY          ║${NC}"
    echo -e "${GREEN}║  Distribution: $OS                                    ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}\n"
    
    # Installation de tous les composants
    install_conky
    setup_default_config
    install_conky_manager
    install_aureola_themes
    configure_asura_theme
    
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓✓✓ INSTALLATION TERMINEE AVEC SUCCES! ✓✓✓          ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${YELLOW}Pour lancer Conky Manager, utilisez:${NC}"
    echo -e "${GREEN}conky-manager2${NC}\n"
}

# Lancement du script
main