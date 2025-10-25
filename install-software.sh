#!/bin/bash

# ============================================================
#  INSTALLATION UNIVERSELLE DE LOGICIELS
#  Supporte : Arch, Ubuntu/Debian, Rocky/RHEL/Fedora
#  Formats : Paquets natifs, Flatpak, Snap
# ============================================================

LISTS_DIR="./lists"
PACKAGES_FILE="$LISTS_DIR/packages.txt"
FLATPAK_FILE="$LISTS_DIR/flatpak.txt"
SNAP_FILE="$LISTS_DIR/snap.txt"

# ============================================================
#  DÉTECTION DE LA DISTRIBUTION
# ============================================================

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_FAMILY=$ID_LIKE
    else
        echo "❌ Impossible de détecter le système d'exploitation"
        exit 1
    fi
}



# ============================================================
#  INSTALLATION SELON LA DISTRIBUTION
# ============================================================

install_packages() {
    echo "🔍 Détection du système..."
    detect_os
    
    # Installation des paquets natifs
    if [ -f "$PACKAGES_FILE" ]; then
        case "$OS" in
            arch|manjaro|endeavouros)
                echo "📦 Distribution détectée : Arch Linux / $OS"
                echo "📥 Installation avec yay..."
                yay -S --noconfirm --needed $(cat $PACKAGES_FILE)
                ;;
                
            ubuntu|debian|linuxmint|pop)
                echo "📦 Distribution détectée : Debian/Ubuntu / $OS"
                echo "📥 Mise à jour des dépôts..."
                sudo apt update
                echo "📥 Installation avec apt..."
                cat $PACKAGES_FILE | xargs sudo apt install -y
                ;;
                
            rocky|rhel|centos|fedora|almalinux)
                echo "📦 Distribution détectée : Red Hat / $OS"
                if command -v dnf &> /dev/null; then
                    echo "📥 Installation avec dnf..."
                    cat $PACKAGES_FILE | xargs sudo dnf install -y
                else
                    echo "📥 Installation avec yum..."
                    cat $PACKAGES_FILE | xargs sudo yum install -y
                fi
                ;;
                
            opensuse*|suse)
                echo "📦 Distribution détectée : openSUSE / $OS"
                echo "📥 Installation avec zypper..."
                cat $PACKAGES_FILE | xargs sudo zypper install -y
                ;;
                
            *)
                echo "❌ Distribution non supportée : $OS"
                echo "Distributions supportées : Arch, Ubuntu/Debian, Rocky/RHEL/Fedora, openSUSE"
                exit 1
                ;;
        esac
    fi
    
    # Installation des paquets Flatpak  #flatpak list

    if [ -f "$FLATPAK_FILE" ]; then
        echo ""
        echo "📦 Installation des paquets Flatpak..."
        if command -v flatpak &> /dev/null; then
            cat $FLATPAK_FILE | xargs -I {} flatpak install -y flathub {}
        else
            echo "⚠️  Flatpak n'est pas installé, paquets ignorés"
        fi
    fi
    
    # Installation des paquets Snap  #snap list

    if [ -f "$SNAP_FILE" ]; then
        echo ""
        echo "📦 Installation des paquets Snap..."
        if command -v snap &> /dev/null; then
            cat $SNAP_FILE | xargs -I {} sudo snap install {}
        else
            echo "⚠️  Snap n'est pas installé, paquets ignorés"
        fi
    fi
    
    echo ""
    echo "✅ Installation terminée !"
}

# ============================================================
#  EXÉCUTION
# ============================================================

install_packages