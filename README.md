# 🔄 pro_switch_proxy-win

Ideia de ajudar de forma simples e direta usuários que precisam alterar configurações de proxy em uma máquina Windows, conforme a rede em que estão conectados.

![Windows](https://img.shields.io/badge/Windows-10+-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-lightgrey)
![Status](https://img.shields.io/badge/status-stable-brightgreen)

---

## 🔄 Proxy ON/OFF Toggle (Windows)

Ferramenta simples para **ativar ou desativar o Proxy do Windows com um clique**.

Ideal para usuários que precisam alternar rapidamente entre ambientes com e sem proxy (ex: rede corporativa vs. internet direta).

---

## ⚙️ Funcionalidades

- ✅ Ativa ou desativa o proxy automaticamente  
- ✅ Atualiza a configuração em tempo real (sem precisar reiniciar navegador)  
- ✅ Cria atalho na área de trabalho  
- ✅ Não requer privilégios administrativos  
- ✅ Instalador simples via script  

---

## 📦 Estrutura do Projeto

```
/Projeto
├── install.ps1
├── sc_Win_Ativa-Desativa_prx.ps1
├── sc_Win_Ativa-Desativa_prx-atalho.bat
└── icon.ico
```

---

## 🚀 Instalação

1. Baixe ou clone este repositório  
2. Execute o comando abaixo:

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

3. Um atalho chamado **"Proxy ON-OFF"** será criado na área de trabalho  

---

## 🖱️ Uso

Basta clicar no atalho criado na área de trabalho:

- Se o proxy estiver **ativado**, ele será desativado  
- Se estiver **desativado**, ele será ativado  

---

## ⚠️ Observações Importantes

### 🔐 Políticas de Empresa (GPO)

Em ambientes corporativos, o proxy pode ser controlado por políticas de grupo (GPO).

Nesses casos:

- ❌ A alteração pode não ser aplicada  
- ⚠️ O sistema exibirá mensagem informando possível bloqueio  

---

## 🧠 Funcionamento Técnico

A ferramenta:

1. Lê a chave de registro:
   ```
   HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings
   ```

2. Alterna o valor:
   - `1` → Proxy ativado  
   - `0` → Proxy desativado  

3. Aplica atualização imediata via `wininet.dll`

---

## 🛠️ Tecnologias Utilizadas

- PowerShell  
- Batch Script (.bat)  
- API do Windows (`wininet.dll`)  

---

## 📌 Requisitos

- Windows 10 ou superior  
- PowerShell 5.1+  

---

## 👤 Autor

**Thiago Boeira**

- GitHub: https://github.com/tcboeira  
- Email: tcboeira@gmail.com  

---

## 📦 Versão

**1.0**
