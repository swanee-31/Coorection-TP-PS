<#
.SYNOPSIS
    Script d'onboarding automatisé pour la création des utilisateurs depuis un CSV.
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

# 2. Préparation de l'environnement
$DomaineRacine = "DC=lab,DC=local"
$FichierCSV = ".\NouveauxEmployes.csv"

# Mot de passe par défaut converti en chaîne sécurisée
$MotDePasseDefaut = ConvertTo-SecureString "TempP@ssw0rd2026!" -AsPlainText -Force

# Vérification/Création du groupe global "GG_Tous_Employes" à la racine
$NomGroupe = "GG_Tous_Employes"
if (-not (Get-ADGroup -Filter "Name -eq '$NomGroupe'" -Server $ServeurAD -Credential $Cred)) {
    Write-Host "Création du groupe $NomGroupe..." -ForegroundColor Yellow
    New-ADGroup -Name $NomGroupe -GroupCategory Security -GroupScope Global -Path $DomaineRacine -Server $ServeurAD -Credential $Cred
}

# 3. Lecture du fichier CSV
$NouveauxEmployes = Import-Csv -Path $FichierCSV

foreach ($Employe in $NouveauxEmployes) {
    
    # Génération du SamAccountName (1ère lettre prénom + nom, le tout en minuscules)
    $SamAccount = "$($Employe.Prénom.Substring(0,1))$($Employe.Nom)".ToLower()
    
    # Définition de l'OU de destination
    $NomOU = $Employe.Département
    $CheminOU = "OU=$NomOU,$DomaineRacine"

    # 4. Vérification et création de l'OU si elle n'existe pas
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$NomOU'" -Server $ServeurAD -Credential $Cred)) {
        Write-Host "L'OU $NomOU n'existe pas. Création en cours..." -ForegroundColor Yellow
        New-ADOrganizationalUnit -Name $NomOU -Path $DomaineRacine -Server $ServeurAD -Credential $Cred
    }

    # 5. Vérification si l'utilisateur existe déjà
    if (Get-ADUser -Filter "SamAccountName -eq '$SamAccount'" -Server $ServeurAD -Credential $Cred) {
        Write-Host "L'utilisateur $SamAccount existe déjà. Ignoré." -ForegroundColor Red
    }
    else {
        # 6. Création de l'utilisateur
        Write-Host "Création de l'utilisateur : $SamAccount dans $NomOU" -ForegroundColor Green
        New-ADUser -Name "$($Employe.Prénom) $($Employe.Nom)" `
                   -GivenName $Employe.Prénom `
                   -Surname $Employe.Nom `
                   -SamAccountName $SamAccount `
                   -UserPrincipalName "$SamAccount@lab.local" `
                   -Title $Employe.Titre `
                   -Department $Employe.Département `
                   -Path $CheminOU `
                   -AccountPassword $MotDePasseDefaut `
                   -ChangePasswordAtLogon $true `
                   -Enabled $true `
                   -Server $ServeurAD `
                   -Credential $Cred

        # 7. Ajout au groupe global
        Add-ADGroupMember -Identity $NomGroupe -Members $SamAccount -Server $ServeurAD -Credential $Cred
    }
}

Write-Host "--- Fin du traitement d'Onboarding ---" -ForegroundColor Cyan