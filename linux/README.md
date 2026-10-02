# 🔄 Proxy ON/OFF Toggle (Linux - Ubuntu 26.04 / GNOME)

Versão para Linux/Ubuntu do alternador rápido de Proxy corporativo.

## ⚙️ Funcionalidades

- ✅ Ativa ou desativa o proxy do GNOME com um clique
- ✅ Atualiza imediatamente a configuração da sessão (navegadores Chrome, Firefox, Edge, etc.)
- ✅ Emite notificações visuais nativas do desktop (`notify-send`)
- ✅ Não requer privilégios de superusuário (`root` / `sudo`)
- ✅ Script instalador automático com criação de atalho na Área de Trabalho e Menu de Aplicativos

---

## 🚀 Instalação no Ubuntu

1. Abra o terminal na pasta `linux`:
```bash
chmod +x install.sh sc_Linux_Ativa-Desativa_prx.sh
./install.sh
```

2. O atalho **"Proxy ON-OFF"** será criado na Área de Trabalho (`~/Desktop`) e no menu de aplicativos do sistema (`~/.local/share/applications/`).

---

## 🖱️ Uso

Dê um duplo clique no atalho **Proxy ON-OFF** na Área de Trabalho ou execute pelo menu do GNOME:
- Se estiver **ativado**, ele será desativado.
- Se estiver **desativado**, ele será configurado e ativado.

> **Dica**: No Ubuntu, caso o atalho na área de trabalho exiba um pequeno "x" ou aviso na primeira execução, clique com o botão direito nele e selecione **"Permitir Execução"** (*Allow Launching*).

---

## 🛠️ Tecnologias Utilizadas

- **Bash**
- **GSettings / D-Bus** (`org.gnome.system.proxy`)
- **Desktop Entry** (`.desktop`)
- **Libnotify** (`notify-send`)
