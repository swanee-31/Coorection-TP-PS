# Définir la date de naissance
$DateNaissance = [System.DateTime]::new(1906, 6, 9)

# Récupérer la date d'aujourd'hui
$DateAujourdhui = [System.DateTime]::Today

# Calculer la différence entre aujourd'hui et la date de naissance
$Difference = $DateAujourdhui - $DateNaissance

# Afficher les résultats
Write-Host "Date de naissance : $($DateNaissance.ToShortDateString())"
Write-Host "Date d'aujourd'hui : $($DateAujourdhui.ToShortDateString())"
Write-Host "Nombre de jours depuis votre naissance : $([int]$Difference.TotalDays) jours"



# SIG # Begin signature block
# MIIFfwYJKoZIhvcNAQcCoIIFcDCCBWwCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUiH6jJJh7uPz79SrbmWm+D+lX
# sF2gggMUMIIDEDCCAfigAwIBAgIQZ410gkb9Dp5Jy141lgoFEDANBgkqhkiG9w0B
# AQsFADAgMR4wHAYDVQQDDBVNb25FZGl0ZXVyRGVTY3JpcHRzVjIwHhcNMjYxMTAz
# MTQ0MDI5WhcNMjcxMTAzMTUwMDI5WjAgMR4wHAYDVQQDDBVNb25FZGl0ZXVyRGVT
# Y3JpcHRzVjIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDLmeGDTTA4
# 40IMaHjbBpQaqeuagpzS26nUOxFHAM9xnFGlDixFst46en0DJJiRFJu9+j0eDyOo
# a9AMKu6BQXnGozARPN4Sb5wVAzVccppv5PfSCS/oR2eG+lqpau9M9r1F2y2fgJlw
# T9ZVnnILyvCphsdjjt7YVHv1y304V5IpQpehnjGMubs/gu522OkD99/GkTL98UVu
# 1SL3DE98Spo6E5Ez3k8INGqUhkPlxs7AKerqKB9GMSdnk9ivgFLqfA8t66FNDYhM
# y/U053IE2hhjt8Y/3oMa4FZRlGWOAZzkTocO96EbQJUb07GJjQhePCLGzKgk+f7H
# tUwloBn6XtZFAgMBAAGjRjBEMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggr
# BgEFBQcDAzAdBgNVHQ4EFgQUIJ1rGk/fakEGhBMXZpcA+YbZyWUwDQYJKoZIhvcN
# AQELBQADggEBAKrQxeDFOLywX6PnnFWS0RAuITlgNh22Bc+uXH2EWhCvSJYVc6PR
# CBcTWgNG5vS5Lpq54Fs3gh2QjeDWAGCTUlJPIFG1BjAKc7WaBctXth+anGSMGKSp
# NsNd2L3pxxPe3lChsBteJmj5bir2LGbvTcXiOBgAphGZfCoLl68TuiLFOLbF9ZY1
# IM3sn8zGeF2Pwy0BvffOTO535dA6EvlTTV9pgS4YPK/x7SrFBXnzTREFg7Kc1FDN
# lPfzHv6J9A+DiAsV++9YWkFIqy7gVZuhyvUWUIPPdUvYkQe+h7c7/YrLIc+sE8++
# 7bwURopmsNXY7bmskRNrfY5Kh2MpeYlsEB8xggHVMIIB0QIBATA0MCAxHjAcBgNV
# BAMMFU1vbkVkaXRldXJEZVNjcmlwdHNWMgIQZ410gkb9Dp5Jy141lgoFEDAJBgUr
# DgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMx
# DAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkq
# hkiG9w0BCQQxFgQUmB/aFKLiVaU4FeJVJOM8MtibZTcwDQYJKoZIhvcNAQEBBQAE
# ggEAOGYxMASOjbT1JM+cXKcPpmql1nhP1x18oQZziixm5DFB4Tddg0rvR8Qf3kPl
# fD4TglHqAp1RFygyqXBmCIFqNeO1133zRcVopa75uPciyvVlj5xu/LxNWAOJ1i3h
# uqLo6I77qcIGdz2KVtGyR3n3I//rwj6mqa9/suEw7EhZh+c95Po68BHJpzEG69Zm
# ODxnr501c/rtmfm8QssWbFpkPvGRP7d5OHqvy8neIOnYzoUrHDJuVESsh+OdP+se
# QnGDbWyKoGCj335LplJIkXUJT6Amjm38Ch0YTVHpvTUS6U1fCV2DBN5tPGKhmrVw
# ur7kxR6oXCXJis/pZOIPpn5k+Q==
# SIG # End signature block
