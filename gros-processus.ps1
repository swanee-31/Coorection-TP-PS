# Définition de la fonction avancée Get-GrosProcessus
function Get-GrosProcessus {
    [CmdletBinding()]
    param (
        [int]$SeuilMo = 100,  # Seuil par défaut : 100 Mo
        [string]$NomProcessus = "*"  # Filtre par défaut : tous les processus
    )

    # Récupérer les processus et appliquer les filtres
    Get-Process | Where-Object {
        $_.ProcessName -like $NomProcessus -and $_.WS -gt ($SeuilMo * 1MB)
    } | Select-Object ProcessName, Id, WS
}

# Test de la fonction avec les paramètres par défaut
Get-GrosProcessus

# Test de la fonction avec des paramètres spécifiques
Get-GrosProcessus -NomProcessus "*chrome*" -SeuilMo 50

# Test de la fonction avec tri des résultats
Get-GrosProcessus -SeuilMo 80 | Sort-Object -Property WS -Descending


