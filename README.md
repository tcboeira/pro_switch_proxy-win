# 🔄 pro_switch_proxy

Ideia de ajudar de forma simples e direta usuários que precisam alterar configurações de proxy em suas máquinas, tanto no **Windows** quanto no **Linux (Ubuntu)**, conforme a rede em que estão conectados.

![Windows](https://img.shields.io/badge/Windows-10+-blue)
![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04+-orange)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-lightgrey)
![Bash](https://img.shields.io/badge/Bash-4.0+-black)
![Status](https://img.shields.io/badge/status-stable-brightgreen)

---

## 🔄 Proxy ON/OFF Toggle (Windows & Linux)

Ferramenta simples para **ativar ou desativar o Proxy com apenas um clique**.

Ideal para usuários que precisam alternar rapidamente entre ambientes com e sem proxy (ex: rede corporativa presencial vs. trabalho remoto / internet direta).

---

## ⚙️ Funcionalidades

- ✅ Ativa ou desativa o proxy automaticamente  
- ✅ Atualiza a configuração em tempo real (sem precisar reiniciar navegador)  
- ✅ Notificações visuais e mensagens temporárias na tela  
- ✅ Cria atalho na área de trabalho e menu de aplicativos  
- ✅ Não requer privilégios administrativos (`root` / `admin`)  
- ✅ Instalador simples via script para cada sistema operacional  

---

## 📦 Estrutura do Projeto

```
/Projeto
├── script/               # Versão Windows (PowerShell / BAT)
│   ├── install.ps1
│   ├── sc_Win_Ativa-Desativa_prx.ps1
│   ├── sc_Win_Ativa-Desativa_prx-atalho.bat
│   └── icon.ico
└── linux/                # Versão Linux (Ubuntu 26.04 / GNOME)
    ├── install.sh
    ├── sc_Linux_Ativa-Desativa_prx.sh
    └── README.md
```

---

## 🚀 Instalação

### 🪟 No Windows:

1. Abra o PowerShell na pasta `script/` (ou execute a partir da raiz):
```powershell
powershell -ExecutionPolicy Bypass -File script\install.ps1
```
2. Um atalho chamado **"Proxy ON-OFF"** será criado na Área de Trabalho.

### 🐧 No Linux (Ubuntu / GNOME):

1. Abra o terminal na pasta `linux/`:
```bash
cd linux
chmod +x install.sh sc_Linux_Ativa-Desativa_prx.sh
./install.sh
```
2. Um atalho chamado **"Proxy ON-OFF"** será criado na Área de Trabalho (`~/Desktop`) e no Menu de Aplicativos.

---

## 🖱️ Uso

Basta clicar duas vezes no atalho criado na área de trabalho:

- Se o proxy estiver **ativado**, ele será desativado  
- Se o proxy estiver **desativado**, ele será ativado  
- Uma mensagem/notificação temporária confirma a mudança de estado na tela.

---

## ⚠️ Observações Importantes

### 🔐 Políticas Corporativas (GPO no Windows / Bloqueios Locais)

Em ambientes corporativos, o proxy pode ser controlado por políticas de grupo centralizadas.

Nesses casos:

- ❌ A alteração pode não ser aplicada ou ser revertida pelo sistema operacional  
- ⚠️ O sistema exibirá mensagem informando possível bloqueio  

---

## 🧠 Funcionamento Técnico

### Windows:
1. Lê a chave de registro:
   ```
   HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings
   ```
2. Alterna o valor `ProxyEnable`:
   - `1` → Proxy ativado (configura `ProxyServer` e `ProxyOverride`)  
   - `0` → Proxy desativado  
3. Aplica atualização imediata via `wininet.dll` (`InternetSetOption`).

### Linux (Ubuntu / GNOME):
1. Consulta o modo atual através do GSettings:
   ```bash
   gsettings get org.gnome.system.proxy mode
   ```
2. Alterna o schema `org.gnome.system.proxy`:
   - `'manual'` → Ativado (define hosts HTTP/HTTPS e lista de exceções `ignore-hosts`)  
   - `'none'` → Desativado (conexão direta)  
3. O D-Bus propaga a alteração imediatamente para o sistema e navegadores, emitindo notificação nativa via `notify-send`.

---

## 🛠️ Tecnologias Utilizadas

- **Windows:** PowerShell 5.1+, Batch Script (`.bat`), Windows Forms (popups), API nativa (`wininet.dll`).
- **Linux:** Bash, GSettings / D-Bus (`org.gnome.system.proxy`), Libnotify (`notify-send`), Desktop Entry (`.desktop`).

---

## 📌 Requisitos

- **Windows:** Windows 10 ou superior, PowerShell 5.1+  
- **Linux:** Ubuntu 20.04+ (testado e otimizado para 24.04 e 26.04 GNOME), `gsettings`, `notify-send`  

---

## 👤 Autor

**Thiago Boeira**

- GitHub: https://github.com/tcboeira  
- Email: tcboeira@gmail.com  

---

## 📦 Versão

**2.0** (Suporte Multiplataforma Windows & Linux)
