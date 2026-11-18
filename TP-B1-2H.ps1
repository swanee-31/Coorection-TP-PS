function Invoke-SystemAudit {
    [CmdletBinding()]
    param(
        [int]$SeuilMemoire = 150
    )

    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "       RAPPORT D'AUDIT SYSTEME           " -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan

    # ---------------------------------------------------------
    # Partie 2 : Inventaire Système et exploration .NET
    # ---------------------------------------------------------
    Write-Host "`n[+] Informations de l'OS (Get-CimInstance) :" -ForegroundColor Yellow
    $OSInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $RamGo = [math]::Round($OSInfo.TotalVisibleMemorySize / 1MB, 2)
    Write-Host "Système d'exploitation : $($OSInfo.Caption)"
    Write-Host "Mémoire RAM visible    : $RamGo Go"

    Write-Host "`n[+] Variables d'environnement (.NET System.Environment) :" -ForegroundColor Yellow
    Write-Host "Nom de la machine      : $([System.Environment]::MachineName)"
    Write-Host "Utilisateur courant    : $([System.Environment]::UserName)"

    Write-Host "`n[+] Espace Disque (.NET System.IO.DriveInfo) :" -ForegroundColor Yellow
    $Drives = [System.IO.DriveInfo]::GetDrives()
    foreach ($Drive in $Drives) {
        if ($Drive.IsReady) {
            $FreeSpaceGB = [math]::Round($Drive.TotalFreeSpace / 1GB, 2)
            $TotalSpaceGB = [math]::Round($Drive.TotalSize / 1GB, 2)
            Write-Host "Lecteur $($Drive.Name) - Espace libre : $FreeSpaceGB Go sur $TotalSpaceGB Go"
        }
    }

    # ---------------------------------------------------------
    # Partie 3 : Tests Réseau et Résolution DNS
    # ---------------------------------------------------------
    Write-Host "`n[+] Test de connectivité (Test-Connection) :" -ForegroundColor Yellow
    $CibleIP = "8.8.8.8"
    
    # Le paramètre -Quiet renvoie un booléen (True/False)
    $PingResult = Test-Connection -ComputerName $CibleIP -Count 1 -Quiet
    if ($PingResult) {
        Write-Host "Ping vers $CibleIP : SUCCÈS" -ForegroundColor Green
    } else {
        Write-Host "Ping vers $CibleIP : ÉCHEC" -ForegroundColor Red
    }

    Write-Host "`n[+] Résolution DNS inverse (.NET System.Net.Dns) :" -ForegroundColor Yellow
    try {
        $HostEntry = [System.Net.Dns]::GetHostEntry($CibleIP)
        Write-Host "Le nom d'hôte pour $CibleIP est : $($HostEntry.HostName)"
    } catch {
        Write-Host "Échec de la résolution DNS pour $CibleIP" -ForegroundColor Red
    }

    # ---------------------------------------------------------
    # Partie 4 : Pipeline et Processus
    # ---------------------------------------------------------
    Write-Host "`n[+] Processus consommant plus de $SeuilMemoire Mo (Pipeline) :" -ForegroundColor Yellow
    
    # Calcul du seuil en octets (MB = Mégaoctets natif en PowerShell)
    $SeuilOctets = $SeuilMemoire * 1MB

    # Filtrage via Where-Object et sélection via Select-Object
    Get-Process | 
        Where-Object { $_.WS -gt $SeuilOctets } | 
        Select-Object ProcessName, Id, WS |
        Sort-Object WS -Descending |
        Format-Table -AutoSize

    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "             FIN DE L'AUDIT              " -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
}

# Exécution de la fonction pour tester le script
Invoke-SystemAudit -SeuilMemoire 150