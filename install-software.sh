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
AUR_FILE="$LISTS_DIR/aur.txt"

# ============================================================
#  DETECTION DE LA DISTRIBUTION
# ============================================================

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        OS_FAMILY=$ID_LIKE
    else
        echo "Impossible de detecter le systeme d'exploitation"
        exit 1
    fi
}

# ============================================================
#  INSTALLATION SELON LA DISTRIBUTION
# ============================================================

install_packages() {
    echo "Detection du systeme..."
    detect_os
    
    # Installation des paquets natifs
    if [ -f "$PACKAGES_FILE" ]; then
        case "$OS" in
            arch|manjaro|endeavouros)
                echo "Distribution detectee : Arch Linux / $OS"
                echo "Installation avec yay..."
                while IFS= read -r package || [[ -n "$package" ]]; do
                    package=$(echo "$package" | sed 's/\r$//' | xargs)
                    [[ -z "$package" || "$package" =~ ^# ]] && continue
                    echo "  Installation de $package..."
                    yay -S --noconfirm --needed "$package" 2>/dev/null || echo "  ATTENTION: $package non disponible"
                done < "$PACKAGES_FILE"
                ;;
                
            ubuntu|debian|linuxmint|pop)
                echo "Distribution detectee : Debian/Ubuntu / $OS"
                echo "Mise a jour des depots..."
                sudo apt update
                echo "Installation avec apt..."
                while IFS= read -r package || [[ -n "$package" ]]; do
                    package=$(echo "$package" | sed 's/\r$//' | xargs)
                    [[ -z "$package" || "$package" =~ ^# ]] && continue
                    echo "  Installation de $package..."
                    sudo apt install -y "$package" 2>/dev/null || echo "  ATTENTION: $package non disponible, continuant..."
                done < "$PACKAGES_FILE"
                ;;
                
            rocky|rhel|centos|fedora|almalinux)
                echo "Distribution detectee : Red Hat / $OS"
                if command -v dnf &> /dev/null; then
                    while IFS= read -r package || [[ -n "$package" ]]; do
                        package=$(echo "$package" | sed 's/\r$//' | xargs)
                        [[ -z "$package" || "$package" =~ ^# ]] && continue
                        echo "  Installation de $package..."
                        sudo dnf install -y "$package" 2>/dev/null || echo "  ATTENTION: $package non disponible"
                    done < "$PACKAGES_FILE"
                else
                    while IFS= read -r package || [[ -n "$package" ]]; do
                        package=$(echo "$package" | sed 's/\r$//' | xargs)
                        [[ -z "$package" || "$package" =~ ^# ]] && continue
                        echo "  Installation de $package..."
                        sudo yum install -y "$package" 2>/dev/null || echo "  ATTENTION: $package non disponible"
                    done < "$PACKAGES_FILE"
                fi
                ;;
                
            opensuse*|suse)
                echo "Distribution detectee : openSUSE / $OS"
                while IFS= read -r package || [[ -n "$package" ]]; do
                    package=$(echo "$package" | sed 's/\r$//' | xargs)
                    [[ -z "$package" || "$package" =~ ^# ]] && continue
                    echo "  Installation de $package..."
                    sudo zypper install -y "$package" 2>/dev/null || echo "  ATTENTION: $package non disponible"
                done < "$PACKAGES_FILE"
                ;;
                
            *)
                echo "Distribution non supportee : $OS"
                echo "Distributions supportees : Arch, Ubuntu/Debian, Rocky/RHEL/Fedora, openSUSE"
                exit 1
                ;;
        esac
    fi
    
    # Installation des paquets Flatpak
    if [ -f "$FLATPAK_FILE" ]; then
        echo ""
        echo "Installation des paquets Flatpak..."
        if command -v flatpak &> /dev/null; then
            while IFS= read -r flatpak_app || [[ -n "$flatpak_app" ]]; do
                flatpak_app=$(echo "$flatpak_app" | sed 's/\r$//' | xargs)
                [[ -z "$flatpak_app" || "$flatpak_app" =~ ^# ]] && continue
                echo "  Installation de $flatpak_app..."
                sudo flatpak install -y flathub "$flatpak_app" 2>&1 | grep -v "Looking for matches" | grep -v "Skipping"
            done < "$FLATPAK_FILE"
        else
            echo "ATTENTION: Flatpak n'est pas installe, paquets ignores"
        fi
    fi

    # Installation des paquets Snap
    if [ -f "$SNAP_FILE" ]; then
        echo ""
        echo "Installation des paquets Snap..."
        if command -v snap &> /dev/null; then
            while IFS= read -r snap_app || [[ -n "$snap_app" ]]; do
                snap_app=$(echo "$snap_app" | sed 's/\r$//' | xargs)
                [[ -z "$snap_app" || "$snap_app" =~ ^# ]] && continue
                echo "  Installation de $snap_app..."
                sudo snap install "$snap_app" 2>&1 | grep -v "already installed"
            done < "$SNAP_FILE"
        else
            echo "ATTENTION: Snap n'est pas installe, paquets ignores"
        fi
    fi
    
    echo ""
    echo "Installation terminee!"
    
    # Installation supplementaire Outlook
    echo ""
    echo "Installation de Outlook For Linux (edge)..."
    sudo snap install --edge outlook-for-linux 2>&1 | grep -v "already installed"
    
    echo ""
    echo "Installation complete terminee!"
}



# ============================================================
# Installation des paquets AUR (Arch User Repository)
# ============================================================

if [ -f "$AUR_FILE" ]; then
    echo ""
    echo "Installation des paquets AUR..."
    if command -v yay &> /dev/null; then
        while IFS= read -r aur_pkg || [[ -n "$aur_pkg" ]]; do
            aur_pkg=$(echo "$aur_pkg" | sed 's/\r$//' | xargs)
            [[ -z "$aur_pkg" || "$aur_pkg" =~ ^# ]] && continue
            echo "  Installation de $aur_pkg depuis AUR..."
            yay -S --noconfirm --needed "$aur_pkg" 2>/dev/null || echo "  ATTENTION: $aur_pkg non disponible dans AUR"
        done < "$AUR_FILE"
    else
        echo "ATTENTION: yay n'est pas installe, impossible d'installer les paquets AUR."
    fi
fi


# ============================================================
#  EXECUTION
# ============================================================

install_packages
