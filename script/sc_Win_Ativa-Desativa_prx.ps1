<#
	Nome: sc_Win_Ativa-Desativa_prx.ps1
	Data: 22/09/2025 - 8h41
	Ultima Revisão: 27/03/2026 - 14h20
	
	Versão: 2.0
	Criado: Thiago Boeira
			tcboeira@gmail.com
		
	Função/Descrição:	Facilitar a ação de ativar ou desativar o proxy quando da presenção ou não no ambiente fisico da empresa

	NOTA: É chamado via atalho (duplo clique) em Desktop, via arquivo "of.bat // sc_Win_Ativa-Desativa_prx-atalho.bat"

	###########################
	# Anotações de Alterações #
	#
	Versão // Data - Hora // Alteração-Descrição

	2.0 // 27/03/2026 - 14h20 // - Revisão completa do script com melhorias e correções

	1.1 // 22/09/2025 - 8h41 // - Alterado para que não exiba/abra tela de Opções de Internert
								- Trecho 1.0 obsoletado destacado/comentado após o Script atual, em curso

	1.0 // 22/09/2025 - 8h41 // - Criação

#>

# Caminho da chave de configuração
	$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

# Lê o estado atual
	$current = Get-ItemProperty -Path $regPath -Name ProxyEnable

	try {
		if ($current.ProxyEnable -eq 1) {
			Write-Output "Proxy está ATIVADO -> Desativando..."
			Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 0 -ErrorAction Stop
		} else {
			Write-Output "Proxy está DESATIVADO -> Ativando..."
			Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 1 -ErrorAction Stop
		}
	}
	catch {
		Write-Host "Não foi possível alterar o proxy. Pode estar bloqueado por política (GPO)." -ForegroundColor Yellow
		exit
	}

##################################################
# VALIDAÇÃO 

	$new = Get-ItemProperty -Path $regPath -Name ProxyEnable

	if ($new.ProxyEnable -eq $current.ProxyEnable) {
		Write-Host "A alteração não foi aplicada. Possível bloqueio por GPO." -ForegroundColor Yellow
		exit
	}

##################################################
# Atualiza configuração em tempo real

$signature = @"
    [DllImport("wininet.dll", SetLastError=true)]
    public static extern bool InternetSetOption(int hInternet, int dwOption, IntPtr lpBuffer, int dwBufferLength);
"@

	Add-Type -MemberDefinition $signature -Namespace WinInet -Name NativeMethods

	$INTERNET_OPTION_SETTINGS_CHANGED = 39
	$INTERNET_OPTION_REFRESH = 37

	[WinInet.NativeMethods]::InternetSetOption(0, $INTERNET_OPTION_SETTINGS_CHANGED, [IntPtr]::Zero, 0) | Out-Null
	[WinInet.NativeMethods]::InternetSetOption(0, $INTERNET_OPTION_REFRESH, [IntPtr]::Zero, 0) | Out-Null

<#
#########################
# Trecho 1.0 obsoletado #
#

	# Caminho da chave de configuração
		$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

	# Lê o estado atual
		$current = Get-ItemProperty -Path $regPath -Name ProxyEnable

		if ($current.ProxyEnable -eq 1) {
			Write-Output "Proxy está ATIVADO -> Desativando..."
			Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 0
		} else {
			Write-Output "Proxy está DESATIVADO -> Ativando..."
			Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 1
		}

	# Força atualização imediata da configuração
		RunDll32.exe inetcpl.cpl,LaunchConnectionDialog
#>