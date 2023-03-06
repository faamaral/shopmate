# Solicita que o usuário insira a URL
$url = Read-Host -Prompt 'Digite a BASE_URL'

# Solicita que o usuário insira a API KEY
$api_key = Read-Host -Prompt 'Digite a API_KEY'

# Cria o arquivo .env e adiciona as chaves e valores
New-Item -ItemType file -Path ".env"
Add-Content -Path ".env" "BASE_URL=$url"
Add-Content -Path ".env" "API_KEY=$api_key"
