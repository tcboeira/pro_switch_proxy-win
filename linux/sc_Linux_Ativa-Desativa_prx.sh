#!/usr/bin/env bash
# ==============================================================================
# Nome: sc_Linux_Ativa-Desativa_prx.sh
# Data: 02/10/2026
# Versão: 1.0 (Linux - Ubuntu / GNOME)
# Autor: Thiago Boeira
#        tcboeira@gmail.com
#
# Função/Descrição:
#   Alterna (ativa ou desativa) o proxy do sistema no Ubuntu (GNOME).
#   Equivalente ao sc_Win_Ativa-Desativa_prx.ps1.
# ==============================================================================

# Definições do Servidor de Proxy
PROXY_HOST="proxy.estado.intra.rs.gov.br"
PROXY_PORT=3128

# Lista de exceções / bypass (formato aceito pelo gsettings GVariant array de strings)
PROXY_IGNORE="['localhost', '127.0.0.0/8', '::1', '*intranet.*', '*.local', '*.soe.rs.gov.br', '*.sefa.gpdb.producao.sefaz.rs.gov.br', '*.hml.rs.gov.br', '*.intra.rs.gov.br', '*.reders', '*.rede.rs', '*.dmz.procergs', '*.procergs', '*.procergs.com.br', '*.banrisul.com.br', '10.124.*', '10.125.*', '10.126.*', '10.127.*', '172.16.*', '192.168.*', '200.198.128.*', '200.233.*', '200.198.169.*', '200.189.134.*', '172.28.*', '*.procergs.rs.gov.br', '*.hml.cloud', '*.compras.rs.gov.br', '*.pregaobanrisul.com.br']"

# Função para exibir notificação na área de trabalho
show_notify() {
    local title="$1"
    local message="$2"
    local icon="$3"
    local timeout_ms="${4:-4000}"

    if command -v notify-send >/dev/null 2>&1; then
        notify-send -t "$timeout_ms" -i "$icon" "$title" "$message"
    else
        echo "[$title] $message"
    fi
}

# Verifica se o gsettings está disponível
if ! command -v gsettings >/dev/null 2>&1; then
    show_notify "Erro de Configuração" "gsettings não encontrado. Este script requer ambiente GNOME/Ubuntu Desktop." "dialog-error" 5000
    exit 1
fi

# Consulta o modo atual do proxy ('none' ou 'manual')
CURRENT_MODE=$(gsettings get org.gnome.system.proxy mode | tr -d "'")

if [ "$CURRENT_MODE" = "manual" ]; then
    # ==========================
    # DESATIVAR PROXY
    # ==========================
    show_notify "Configuração de Proxy" "Desativando o proxy... Por favor aguarde." "network-idle" 2000

    gsettings set org.gnome.system.proxy mode 'none'

    # Validação
    NEW_MODE=$(gsettings get org.gnome.system.proxy mode | tr -d "'")
    if [ "$NEW_MODE" = "none" ]; then
        show_notify "Configuração de Proxy" "Proxy DESATIVADO com sucesso." "network-offline" 4000
    else
        show_notify "Configuração de Proxy" "Falha ao desativar o proxy. Verifique as permissões locais." "dialog-error" 5000
    fi

else
    # ==========================
    # ATIVAR E CONFIGURAR PROXY
    # ==========================
    show_notify "Configuração de Proxy" "Configurando e ativando o proxy... Aguarde." "network-idle" 2000

    # Configura HTTP
    gsettings set org.gnome.system.proxy.http host "$PROXY_HOST"
    gsettings set org.gnome.system.proxy.http port "$PROXY_PORT"
    gsettings set org.gnome.system.proxy.http enabled true

    # Configura HTTPS
    gsettings set org.gnome.system.proxy.https host "$PROXY_HOST"
    gsettings set org.gnome.system.proxy.https port "$PROXY_PORT"

    # Configura Lista de Exceções
    gsettings set org.gnome.system.proxy ignore-hosts "$PROXY_IGNORE"

    # Habilita o modo manual
    gsettings set org.gnome.system.proxy mode 'manual'

    # Validação
    NEW_MODE=$(gsettings get org.gnome.system.proxy mode | tr -d "'")
    if [ "$NEW_MODE" = "manual" ]; then
        show_notify "Configuração de Proxy" "Proxy ATIVADO com sucesso.\nA navegação pode levar alguns segundos para refletir a mudança." "network-transmit-receive" 4000
    else
        show_notify "Configuração de Proxy" "Falha ao ativar o proxy." "dialog-error" 5000
    fi
fi
