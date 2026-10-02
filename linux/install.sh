#!/usr/bin/env bash
# ==============================================================================
# Nome: install.sh
# Data: 02/10/2026
# Versão: 1.0
# Autor: Thiago Boeira
#        tcboeira@gmail.com
#
# Função/Descrição:
#   Faz a instalação do script de Proxy no Ubuntu (GNOME), criando os diretórios,
#   copiando os scripts e gerando o atalho na Área de Trabalho e no Menu.
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_PATH="$HOME/.local/share/pro_switch_proxy"
DESKTOP_DIR="$HOME/Desktop"
APPLICATIONS_DIR="$HOME/.local/share/applications"

echo "=== Instalando Proxy ON-OFF (Linux / Ubuntu) ==="

# 1. Cria diretórios de destino
mkdir -p "$INSTALL_PATH"
mkdir -p "$APPLICATIONS_DIR"

# 2. Copia script principal
cp "$SCRIPT_DIR/sc_Linux_Ativa-Desativa_prx.sh" "$INSTALL_PATH/"
chmod +x "$INSTALL_PATH/sc_Linux_Ativa-Desativa_prx.sh"

# 3. Cria arquivo .desktop no menu de aplicativos
DESKTOP_FILE="$APPLICATIONS_DIR/proxy-toggle.desktop"
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Proxy ON-OFF
Comment=Ativa ou desativa o Proxy corporativo
Exec=$INSTALL_PATH/sc_Linux_Ativa-Desativa_prx.sh
Icon=network-vpn
Terminal=false
Categories=Network;Utility;
EOF
chmod +x "$DESKTOP_FILE"

# 4. Cria atalho na Área de Trabalho se a pasta existir
if [ -d "$DESKTOP_DIR" ]; then
    cp "$DESKTOP_FILE" "$DESKTOP_DIR/"
    chmod +x "$DESKTOP_DIR/proxy-toggle.desktop"
    
    # No Ubuntu/GNOME, marca o atalho da Área de Trabalho como confiável
    if command -v gio >/dev/null 2>&1; then
        gio set "$DESKTOP_DIR/proxy-toggle.desktop" metadata::trusted true 2>/dev/null || true
    fi
fi

echo "✔ Instalação concluída com sucesso!"
echo "Atalho criado em:"
echo " - Menu de Aplicativos"
if [ -d "$DESKTOP_DIR" ]; then
    echo " - Área de Trabalho ($DESKTOP_DIR/proxy-toggle.desktop)"
fi
