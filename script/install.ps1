<#
	Nome: install.ps1
	Data: 27/03/2026 - 14h20
    Ultima Revisão: 

	Versão: 1.0
	Criado: Thiago Boeira
			tcboeira@gmail.com
		
	Função/Descrição:	Faz a "instalação" do Script de ativação/desativação do proxy, copiando os arquivos necessários para uma pasta local do usuário e criando um atalho na área de trabalho para facilitar o acesso.

	###########################
	# Anotações de Alterações #
	#
	Versão // Data - Hora // Alteração-Descrição

	1.0 // 27/03/2026 - 14h20 // - Criação

#>


###############################
# Condição execução e LOG local

    # Caminho base da aplicação
        $installPath = "$env:LOCALAPPDATA\PRO_ActivePROXY"

    # Garante pasta base
        if (!(Test-Path $installPath)) {
            New-Item -ItemType Directory -Path $installPath | Out-Null
        }

    # Define pasta de logs
        $PathLogs = Join-Path $installPath "Logs"

    # Cria pasta de logs se não existir
        if (!(Test-Path $PathLogs)) {
            New-Item -ItemType Directory -Path $PathLogs | Out-Null
        }

    # Garante execução no diretório do script
        Set-Location -Path $PSScriptRoot

###################################
# Início captura de LOG de execução
    $HR1 = Get-Date
    $logFile = Join-Path $PathLogs ("install-PRX-{0}.log" -f (Get-Date -Format "yyyy-MM-dd_HH-mm-ss"))

    Write-Host "v============================================================================================v"
    Write-Host ""
        Start-Transcript -Path $logFile -NoClobber
    Write-Host ""
    Write-Host "^============================================================================================^"

###################################
# EXECUÇÃO PRINCIPAL (TRY / FINALLY)
    try {

############################
# CORPO DO SCRIPT - INICIO #
############################

    ##################################################
    # Caminhos de origem dos arquivos
    $ps1Source  = "$PSScriptRoot\sc_Win_Ativa-Desativa_prx.ps1"
    $batSource  = "$PSScriptRoot\sc_Win_Ativa-Desativa_prx-atalho.bat"
    $iconSource = "$PSScriptRoot\icon.ico"

    ##################################################
    # Validação dos arquivos obrigatórios
    if (!(Test-Path $ps1Source)) {
        Write-Host "Erro: Arquivo PS1 não encontrado!" -ForegroundColor Red
        exit
    }

    if (!(Test-Path $batSource)) {
        Write-Host "Erro: Arquivo BAT não encontrado!" -ForegroundColor Red
        exit
    }

    ##################################################
    # Copia arquivos principais
        Copy-Item $ps1Source -Destination $installPath -Force
        Copy-Item $batSource -Destination $installPath -Force

    
    ##################################################
    # Copia ícone (se existir)
    $iconDestination = Join-Path $installPath "icon.ico"

    if (Test-Path $iconSource) {
        Copy-Item $iconSource -Destination $iconDestination -Force
    }

    ##################################################
    # Criação do atalho na área de trabalho
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = Join-Path $desktop "Proxy ON-OFF.lnk"

    # Remove atalho existente (evita duplicidade)
    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
    }

    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($shortcutPath)

##################################################
# Define execução via CMD (seguro para caminhos com espaço)
    $shortcut.TargetPath = "$env:SystemRoot\System32\cmd.exe"
    $shortcut.Arguments = "/c `"$installPath\sc_Win_Ativa-Desativa_prx-atalho.bat`""
    $shortcut.WorkingDirectory = $installPath


##################################################
# Define ícone (customizado ou padrão)
    if (Test-Path $iconDestination) {
        $shortcut.IconLocation = "$iconDestination,0"
    } else {
        $shortcut.IconLocation = "$env:SystemRoot\System32\SHELL32.dll,27"
    }

##################################################
# Executar minimizado (sem abrir janela visível)
    $shortcut.WindowStyle = 7

##################################################
# Salva o atalho
    $shortcut.Save()

##################################################
# Mensagem final
    Write-Host "Instalação concluída com sucesso!" -ForegroundColor Green
    Write-Host "Atalho criado na área de trabalho: Proxy ON-OFF"

#########################
# CORPO DO SCRIPT - FIM #
#########################

    }
    finally {

###################################
# FINALIZAÇÃO E LOG
    $HR2 = Get-Date
    $H3 = $HR2 - $HR1

    Write-Host "V============================================================================================V"
    Write-Host "Inicio da execução é..........: " -NoNewline ; Write-Host "" $HR1 -ForegroundColor Yellow
    Write-Host "Fim da execução é.............: " -NoNewline ; Write-Host "" $HR2 -ForegroundColor Yellow

    Write-Host ""
    Write-Host "Tempo de execução: $($H3.Hours)h $($H3.Minutes)m $($H3.Seconds)s" -ForegroundColor Yellow
    Write-Host "^============================================================================================^"

    # Finaliza transcript com segurança
    try {
        Stop-Transcript
    } catch {}

    Write-Host "Fim da Execução..."
    Write-Host "^============================================================================================^"

    }





    