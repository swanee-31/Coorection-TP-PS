<#
.SYNOPSIS
    Blocage automatique des comptes Active Directory inactifs depuis plus de 90 jours.
.DESCRIPTION
    Recherche les comptes utilisateurs actifs inactifs depuis plus de 90 jours,
    les désactive, puis exporte un rapport CSV de traçabilité.
#>

Import-Module ActiveDirectory

# Paramétrage de connexion distante vers le contrôleur de domaine
$ServeurAD = "172.18.96.2"
$CheminCredential = ".\cred.xml"

# Chargement d'un compte d'administrateur persisté en XML
if (Test-Path $CheminCredential) {
    $Cred = Import-Clixml -Path $CheminCredential
}
else {
    Write-Host "Aucune crédential persistante détectée. Saisissez les identifiants d'un administrateur AD..." -ForegroundColor Yellow
    $Cred = Get-Credential
    $Cred | Export-Clixml -Path $CheminCredential
}

# Définition de la période d'inactivité
$DateLimite = (Get-Date).AddDays(-90)

# Recherche des comptes utilisateurs inactifs depuis 90 jours ou plus
$ComptesInactifs = Search-ADAccount -Server $ServeurAD -Credential $Cred -UsersOnly -AccountInactive -TimeSpan 90.00:00:00

# Tableau de résultats pour le rapport CSV
$RapportDesactivation = @()

foreach ($Compte in $ComptesInactifs) {
    $Utilisateur = Get-ADUser -Identity $Compte.SamAccountName -Server $ServeurAD -Credential $Cred -Properties Name, SamAccountName, Enabled, LastLogonDate

    # On ne traite que les comptes actuellement activés
    if ($Utilisateur.Enabled -ne $true) {
        continue
    }

    # Vérification explicite de la date de dernière connexion
    if ($null -eq $Utilisateur.LastLogonDate) {
        $DerniereConnexion = "Jamais"
    }
    else {
        $DerniereConnexion = $Utilisateur.LastLogonDate
    }

    Write-Host "Désactivation du compte : $($Utilisateur.Name) [$($Utilisateur.SamAccountName)] - Dernière connexion : $DerniereConnexion" -ForegroundColor Yellow

    Disable-ADAccount -Identity $Utilisateur.DistinguishedName -Server $ServeurAD -Credential $Cred

    $RapportDesactivation += [PSCustomObject]@{
        Name = $Utilisateur.Name
        SamAccountName = $Utilisateur.SamAccountName
        LastLogonDate = $DerniereConnexion
        StatutFinal = "Désactivé"
    }
}

# Export du rapport CSV avec date du jour dans le nom de fichier
$NomFichier = "Comptes_Desactives_$(Get-Date -Format yyyyMMdd).csv"
$RapportDesactivation | Export-Csv -Path $NomFichier -NoTypeInformation -Encoding UTF8

if ($RapportDesactivation.Count -gt 0) {
    Write-Host "Rapport exporté : $((Get-Location).Path)\$NomFichier" -ForegroundColor Green
}
else {
    Write-Host "Aucun compte actif inactif depuis plus de 90 jours n'a été trouvé." -ForegroundColor Cyan
}

Write-Host "--- Fin du traitement de désactivation ---" -ForegroundColor Cyan
