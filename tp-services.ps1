
function VerifierEtRedemarrerService {
    param (
        [string]$ServiceName
    )

    # Tenter de récupérer le service
    $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if (-not $service) {
        # Si le service n'existe pas, afficher un message d'erreur en rouge
        Write-Host "Erreur : Le service '$ServiceName' n'existe pas." -ForegroundColor Red
        return
    }

    # Vérifier l'état du service
    if ($service.Status -eq 'Stopped') {
        # Redémarrer le service s'il est arrêté
        Write-Host "Info : Le service '$ServiceName' est arrêté. Tentative de redémarrage..." -ForegroundColor Yellow
        start-Service -Name $ServiceName 
        if ($service.Status -eq 'Running') {
            Write-Host "Succès : Le service '$ServiceName' a été redémarré." -ForegroundColor Green
        } else {
            Write-Host "Erreur : Échec du redémarrage du service '$ServiceName'." -ForegroundColor Red
        }
        
    } elseif ($service.Status -eq 'Running') {
        # Si le service est déjà en cours d'exécution
        Write-Host "Info : Le service '$ServiceName' est déjà en cours d'exécution. Aucune action requise." -ForegroundColor Yellow
    } else {
        # Autre état du service
        Write-Host "Info : Le service '$ServiceName' est dans l'état '$($service.Status)'. Aucune action effectuée." -ForegroundColor Cyan
    }
}

# Appel de la fonction avec un service existant et arrêté
VerifierEtRedemarrerService -ServiceName "wuauserv"

# Appel de la fonction avec un service inexistant
VerifierEtRedemarrerService -ServiceName "ServiceInconnuXYZ"