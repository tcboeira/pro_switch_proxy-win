<#
	Nome: sc_Win_Ativa-Desativa_prx.ps1
	Data: 22/09/2025 - 8h41
	Ultima Revisão: 08/04/2026 - 9h50
	
	Versão: 3.0
	Criado: Thiago Boeira
			tcboeira@gmail.com
		
	Função/Descrição:	Facilitar a ação de ativar ou desativar o proxy quando da presenção ou não no ambiente fisico da empresa

	NOTA: É chamado via atalho (duplo clique) em Desktop, via arquivo "of.bat // sc_Win_Ativa-Desativa_prx-atalho.bat"

	###########################
	# Anotações de Alterações #
	#
	Versão // Data - Hora // Alteração-Descrição

	3.0 // 08/04/2026 - 9h50 // - Incrementado com exibição de janelas poup-up, para uma experiencia mais amigavel
								- Excluido trecho 1.0 obsoletado destacado/comentado após o Script

	2.0 // 27/03/2026 - 14h20 // - Revisão completa do script com melhorias e correções

	1.1 // 22/09/2025 - 8h41 // - Alterado para que não exiba/abra tela de Opções de Internert
								- Trecho 1.0 obsoletado destacado/comentado após o Script atual, em curso

	1.0 // 22/09/2025 - 8h41 // - Criação

#>

###################################
# Caminho da chave de configuração
#
	$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"


################################
# Carrega assemblies para popup
#
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing


############################
# Função de popup temporário
#
	function Show-TempMessage {
		param (
			[string]$Message,
			[int]$Seconds = 4
		)

		$form = New-Object System.Windows.Forms.Form
		$form.Text = "Configuração de Proxy"
		$form.Size = New-Object System.Drawing.Size(400,150)
		$form.StartPosition = "CenterScreen"
		$form.TopMost = $true

		$form.FormBorderStyle = "FixedDialog"
		$form.MaximizeBox = $false
		$form.MinimizeBox = $false
		$form.BackColor = "White"
		$form.ShowIcon = $false

		$label = New-Object System.Windows.Forms.Label
		$label.Text = $Message
		$label.AutoSize = $false
		$label.Dock = "Fill"
		$label.TextAlign = "MiddleCenter"
		$label.Font = New-Object System.Drawing.Font("Segoe UI",10)

		$form.Controls.Add($label)

		$timer = New-Object System.Windows.Forms.Timer
		$timer.Interval = $Seconds * 1000
		$timer.Add_Tick({
			$timer.Stop()
			$form.Close()
		})

		$timer.Start()
		$form.ShowDialog()
	}


###################################
# WinInet (aplicar imediatamente)
#
$signature = @"
[DllImport("wininet.dll", SetLastError=true)]
public static extern bool InternetSetOption(int hInternet, int dwOption, IntPtr lpBuffer, int dwBufferLength);
"@

if (-not ("WinInet.NativeMethods" -as [type])) {
	Add-Type -MemberDefinition $signature -Namespace WinInet -Name NativeMethods
}

##########
# EXECUÇÃO
#
	try {
		$current = Get-ItemProperty -Path $regPath -Name ProxyEnable -ErrorAction Stop

		if ($current.ProxyEnable -eq 1) {

			Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 0 -ErrorAction Stop

		} else {

			Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 1 -ErrorAction Stop
		}

		# Aplica imediatamente
		[WinInet.NativeMethods]::InternetSetOption(0, 39, [IntPtr]::Zero, 0) | Out-Null
		[WinInet.NativeMethods]::InternetSetOption(0, 37, [IntPtr]::Zero, 0) | Out-Null

		# Popup de processamento
		Show-TempMessage "Alterando configuração de proxy...`nPor favor aguarde." 4
	}
	catch {
		Show-TempMessage "ERRO ao alterar o proxy.`nPode estar bloqueado por política (GPO)." 5
		exit
	}

##################################################
# VALIDAÇÃO FINAL
#
	Start-Sleep -Milliseconds 800

	$new = Get-ItemProperty -Path $regPath -Name ProxyEnable

	if ($new.ProxyEnable -eq $current.ProxyEnable) {

		Show-TempMessage "A alteração NÃO foi aplicada.`nPossível bloqueio por política (GPO)." 5
		exit

	} else {

		if ($new.ProxyEnable -eq 1) {
			Show-TempMessage "Proxy ATIVADO com sucesso.`nA navegação pode levar alguns segundos para refletir a mudança." 3
		} else {
			Show-TempMessage "Proxy DESATIVADO com sucesso." 3
		}
	}





	