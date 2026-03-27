REM 
REM 	Nome: sc_Win_Ativa-Desativa_prx-atalho.bat
REM 	Data: 22/09/2025 - 8h41
REM 	Versão: 1.0
REM 	Criado: Thiago Boeira
REM 			tcboeira@gmail.com
		
REM 	Função/Descrição:	É o "atalho" de chamado para o Script PS "of.ps1 // sc_Win_Ativa-Desativa_prx.ps1", que desativa ou ativa o proxy quando da presenção ou não no ambiente fisico da empresa
REM


@echo off
powershell -ExecutionPolicy Bypass -File "%~dp00sc_Win_Ativa-Desativa_prx.ps1"



