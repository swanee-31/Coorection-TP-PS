<#
.SYNOPSIS
    Script de nettoyage (Rollback) pour annuler les créations du TP Onboarding.
    Version adaptée pour une exécution depuis un poste client distant (Standalone).
#>

Import-Module ActiveDirectory
# Fichier contenant les identifiants pour la connexion distante
$credXML = ".\cred.xml"

# 1. Configuration de la connexion distante
$ServeurAD = "172.18.96.2" # IP ou nom DNS du contrôleur de domaine

# test de connectivité avec le serveur AD avant de continuer
if (-not (Test-Connection -ComputerName $ServeurAD -Count 1 -Quiet)) {
    Write-Host "Impossible de joindre le serveur AD $ServeurAD." -ForegroundColor Red
    exit
}

# création des identifiants pour la connexion distante avec persistance dans un fichier XML
if (-not (Test-Path -Path $credXML)) {
    Write-Host "Le fichier XML de credentials $credXML est introuvable." -ForegroundColor Red
    Write-Host "Veuillez saisir les identifiants d'un administrateur du domaine..." -ForegroundColor Cyan
    $cred = Get-Credential 
    $cred | Export-Clixml -Path $credXML
    if (-not (Test-Path -Path $credXML)) {
        Write-Host "Le fichier XML de credentials $credXML n'a pas pu être créé." -ForegroundColor Red
        exit
    } else {
        Write-Host "Le fichier XML de credentials $credXML a été créé avec succès." -ForegroundColor Green
    }
}
$Cred = Import-Clixml -Path $credXML

# on teste l'authentification avec les identifiants fournis avant de continuer
Write-Host "Test de l'authentification sur le serveur $ServeurAD..." -ForegroundColor Cyan

try {
    # On exécute une requête très légère (récupérer les infos de base du domaine)
    # L'astuce cruciale est "-ErrorAction Stop" pour forcer le passage dans le bloc "catch" en cas de refus.
    $null = Get-ADDomain -Server $ServeurAD -Credential $cred -ErrorAction Stop
    
    Write-Host "Authentification réussie. La connexion AD est opérationnelle." -ForegroundColor Green
}
catch {
    # $_ représente l'erreur capturée
    Write-Host "Erreur critique : Impossible de s'authentifier ou de joindre l'AD." -ForegroundColor Red
    Write-Host "Détail : $($_.Exception.Message)" -ForegroundColor DarkRed
    
    # On quitte le script immédiatement pour éviter les erreurs en cascade
    exit 
}

# 2. Configuration des variables
$DomaineRacine = "DC=lab,DC=local"
$FichierCSV = ".\NouveauxEmployes.csv"
$NomGroupe = "GG_Tous_Employes"

Write-Host "--- Début du Rollback (Nettoyage de l'environnement) ---" -ForegroundColor Cyan

# 3. Suppression des utilisateurs
$Employes = Import-Csv -Path $FichierCSV
foreach ($Employe in $Employes) {
    $SamAccount = "$($Employe.Prénom.Substring(0,1))$($Employe.Nom)".ToLower()
    
    if (Get-ADUser -Filter "SamAccountName -eq '$SamAccount'" -Server $ServeurAD -Credential $Cred) {
        Write-Host "Suppression de l'utilisateur : $SamAccount" -ForegroundColor Red
        Remove-ADUser -Identity $SamAccount -Confirm:$false -Server $ServeurAD -Credential $Cred
    }
    else {
        Write-Host "L'utilisateur $SamAccount n'existe déjà plus." -ForegroundColor DarkGray
    }
}

# 4. Suppression des Unités Organisationnelles (OU)
# On extrait la liste unique des départements pour éviter de requêter plusieurs fois la même OU
$DepartementsUniques = $Employes.Département | Select-Object -Unique

foreach ($NomOU in $DepartementsUniques) {
    $OU = Get-ADOrganizationalUnit -Filter "Name -eq '$NomOU'" -SearchBase $DomaineRacine -SearchScope OneLevel -Server $ServeurAD -Credential $Cred
    
    if ($OU) {
        Write-Host "Suppression de l'OU : $NomOU" -ForegroundColor Red
        
        # ETAPE CRUCIALE : Désactiver la protection contre la suppression accidentelle
        Set-ADOrganizationalUnit -Identity $OU.DistinguishedName -ProtectedFromAccidentalDeletion $false -Server $ServeurAD -Credential $Cred
        
        # Suppression de l'OU
        Remove-ADOrganizationalUnit -Identity $OU.DistinguishedName -Recursive -Confirm:$false -Server $ServeurAD -Credential $Cred
    }
}

# 5. Suppression du groupe global
if (Get-ADGroup -Filter "Name -eq '$NomGroupe'" -Server $ServeurAD -Credential $Cred) {
    Write-Host "Suppression du groupe : $NomGroupe" -ForegroundColor Red
    Remove-ADGroup -Identity $NomGroupe -Confirm:$false -Server $ServeurAD -Credential $Cred
}

Write-Host "--- Rollback terminé. L'environnement est prêt pour une nouvelle démo. ---" -ForegroundColor Green