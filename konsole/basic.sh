#!/bin/zsh

# Instalar konsole
echo "[*] Instalando Konsole..."
sudo apt update && sudo apt install konsole -y

# Instalar Oh My Zsh
echo "[*] Instalando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh ya está instalado."
fi

# Instalar el tema Powerlevel10k
echo "[*] Instalando tema Powerlevel10k..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
else
    echo "Powerlevel10k ya está instalado."
fi

# Configurar ZSH_THEME en .zshrc
echo "[*] Configurando ZSH_THEME..."
ZSHRC="$HOME/.zshrc"
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"
else
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
fi

# Configurar perfil de Konsole con esquema de colores "Breeze"
echo "[*] Configurando Konsole con esquema de colores 'Breeze'..."
KONSOLE_DIR="$HOME/.local/share/konsole"
mkdir -p "$KONSOLE_DIR"

PROFILE_NAME="Powerlevel10k"
PROFILE_FILE="$KONSOLE_DIR/${PROFILE_NAME}.profile"

cat > "$PROFILE_FILE" <<EOF
[Appearance]
ColorScheme=Breeze

[General]
Name=Powerlevel10k
Command=/usr/bin/zsh
EOF

# Hacer que este perfil sea el predeterminado en Konsole
KONSOLERC="$HOME/.config/konsolerc"
mkdir -p "$HOME/.config"
if [ -f "$KONSOLERC" ]; then
    cp "$KONSOLERC" "$KONSOLERC.bak.$(date +%Y%m%d%H%M%S)"
fi

if grep -q '^DefaultProfile=' "$KONSOLERC" 2>/dev/null; then
    sed -i "s|^DefaultProfile=.*|DefaultProfile=${PROFILE_NAME}.profile|" "$KONSOLERC"
else
    if ! grep -q '^\[Desktop Entry\]' "$KONSOLERC" 2>/dev/null; then
        echo "[Desktop Entry]" >> "$KONSOLERC"
    fi
    echo "DefaultProfile=${PROFILE_NAME}.profile" >> "$KONSOLERC"
fi

echo "[✔] Instalación y configuración completada."
echo "   - ZSH_THEME: powerlevel10k/powerlevel10k"
echo "   - Konsole: esquema de colores 'Dark Pastels'"
echo "⚡ Abre Konsole nuevamente o ejecuta: source ~/.zshrc"
