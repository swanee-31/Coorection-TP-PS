# Exemple d'utilisation d'un dictionnaire en PowerShell
# Instanciation du dictionnaire par appel de la méthode statique 'new' de la classe Dictionary
$MonDictionnaire = [System.Collections.Generic.Dictionary[string, string]]::new() 

# Ajouter des éléments
$MonDictionnaire.Add("Serveur1", "En Ligne")
$MonDictionnaire.Add("Serveur2", "Hors Ligne")

Write-Host "Statut du Serveur1 : " $MonDictionnaire.Item("Serveur1")
# Résultat: Statut du Serveur1 : En Ligne
