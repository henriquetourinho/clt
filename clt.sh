#!/bin/bash

# /*********************************************************************************
# * Projeto:   CLT
# * Script:    clt.sh
# * Autor:     Carlos Henrique Tourinho Santana
# * Data:      13 de junho de 2025
# * GitHub:    https://github.com/henriquetourinho/clt
# *
# * Descrição:
# * Versão simplificada do CLT, focada exclusivamente em resolver a "preguiça"
# * de configurar novos ambientes web. O script automatiza a criação de
# * diretórios, a configuração do Nginx + PHP e a criação do link no /etc/hosts
# * para acesso via .local.
# *********************************************************************************/

# --- CONFIGURAÇÃO INICIAL DO SCRIPT ---

# A diretiva 'set -e' (ou 'set -o errexit') garante que o script pare
# imediatamente se qualquer comando falhar (retornar um código de saída diferente de 0).
# Isso é crucial para evitar configurações parciais ou estados de erro perigosos.
set -e

# --- SEÇÃO 1: PREPARAÇÃO E VARIÁVEIS ---

# Definições de códigos de escape ANSI para cores.
# Isso melhora a legibilidade da saída no terminal, diferenciando erros,
# avisos e mensagens de sucesso.
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_NC='\033[0m' # 'No Color' para resetar a formatação de texto.

# --- VERIFICAÇÕES DE SEGURANÇA E USO ---

# 1. Verifica se o script está sendo executado como superusuário (root).
# O ID do usuário 'root' é sempre 0. Comandos como 'mkdir' em /var/www,
# edição de arquivos em /etc e recarga de serviços exigem privilégios de root.
if [ "$(id -u)" -ne 0 ]; then
  # Se o ID do usuário não for 0, exibe uma mensagem de erro e encerra.
  echo -e "${C_RED}❌ ERRO: Este script precisa ser executado com privilégios de root.${C_NC}"
  echo -e "   Por favor, tente novamente usando: sudo ./clt.sh nome-do-projeto"
  exit 1 # Encerra o script com um código de erro 1 (falha).
fi

# 2. Verifica se o primeiro argumento (nome do projeto) foi fornecido.
# A variável '$1' representa o primeiro argumento passado para o script na linha de comando.
# A opção '-z' testa se a string está vazia.
if [ -z "$1" ]; then
  # Se nenhum argumento for fornecido, informa o usuário sobre o uso correto e encerra.
  echo -e "${C_RED}❌ ERRO: Você precisa fornecer o nome do projeto.${C_NC}"
  echo -e "   Uso: sudo ./clt.sh nome-do-projeto"
  exit 1
fi

# --- DEFINIÇÃO DE VARIÁVEIS DINÂMICAS ---

# 2. Define as variáveis principais que serão usadas ao longo do script.
# Sanitiza o nome do projeto para remover caracteres potencialmente perigosos.
# 'tr -cd' remove todos os caracteres EXCETO os que estão no conjunto especificado.
# '[:alnum:]' inclui todas as letras e números. '_' e '-' são permitidos.
PROJECT_NAME=$(echo "$1" | tr -cd '[:alnum:]_-')

# Define o caminho completo para o diretório raiz do projeto.
PROJECT_ROOT="/var/www/${PROJECT_NAME}"

# Define a URL local que será usada para acessar o projeto.
PROJECT_URL="${PROJECT_NAME}.local"

# Define o caminho para o arquivo de configuração do Nginx na pasta de sites disponíveis.
NGINX_CONF_AVAILABLE="/etc/nginx/sites-available/${PROJECT_NAME}"

# Define o caminho para o link simbólico na pasta de sites habilitados.
NGINX_CONF_ENABLED="/etc/nginx/sites-enabled/${PROJECT_NAME}"

# 3. Verifica se o projeto já existe para evitar sobrescrever configurações.
# A opção '-d' verifica se um diretório existe.
# A opção '-f' verifica se um arquivo existe.
# O operador '||' significa 'OU'. Se qualquer uma das condições for verdadeira, o bloco é executado.
if [ -d "${PROJECT_ROOT}" ] || [ -f "${NGINX_CONF_AVAILABLE}" ]; then
  echo -e "${C_YELLOW}⚠️ AVISO: O projeto '${PROJECT_NAME}' já existe.${C_NC}"
  echo "   Nenhuma ação foi executada."
  exit 1 # Encerra sem erro, mas informando que nada foi feito.
fi

# --- SEÇÃO 2: EXECUÇÃO ---

# Informa ao usuário que o processo de criação foi iniciado.
echo -e "${C_BLUE}🚀 Contratando o CLT para criar o ambiente: ${PROJECT_URL}${C_NC}"

# ETAPA 1: CRIAÇÃO DO DIRETÓRIO DE TRABALHO
echo -e "📂 [ETAPA 1/4] Criando diretório em ${C_YELLOW}${PROJECT_ROOT}${C_NC}..."

# 'mkdir -p' cria o diretório. A opção '-p' garante que diretórios pais
# sejam criados se não existirem, evitando erros.
mkdir -p "${PROJECT_ROOT}"

# 'chown -R' muda o proprietário do diretório. A opção '-R' (recursiva)
# garante que todos os subdiretórios e arquivos também tenham o proprietário alterado.
# 'www-data' é o usuário padrão que o Nginx e o PHP-FPM usam.
chown -R www-data:www-data "${PROJECT_ROOT}"

# 'chmod -R 755' altera as permissões. '755' significa que o proprietário
# (www-data) pode ler, escrever e executar, enquanto o grupo e outros
# usuários podem apenas ler e executar. É uma permissão padrão e segura para web.
chmod -R 755 "${PROJECT_ROOT}"
echo -e "   Diretório criado."

# ETAPA 2: CRIAÇÃO DA CONFIGURAÇÃO DO NGINX
echo -e "⚙️  [ETAPA 2/4] Gerando configuração do Nginx..."

# Encontra dinamicamente o caminho para o socket do PHP-FPM.
# O socket é o arquivo que o Nginx usa para se comunicar com o PHP.
# O 'find' procura por um arquivo com nome 'php*-fpm.sock' em /run/php/.
# 'head -n 1' pega apenas o primeiro resultado, caso haja múltiplos.
PHP_SOCKET_PATH=$(find /run/php/ -name "php*-fpm.sock" | head -n 1)

# Verifica se o socket foi encontrado. Se não, o PHP-FPM pode não estar instalado.
if [ -z "${PHP_SOCKET_PATH}" ]; then
    echo -e "${C_RED}❌ ERRO: Nenhum socket PHP-FPM encontrado em /run/php/. Verifique se o PHP-FPM está instalado.${C_NC}"
    exit 1
fi

# Usa um 'Heredoc' (cat <<EOF) para criar o conteúdo do arquivo de configuração do Nginx.
# Tudo entre '<<EOF' e a linha 'EOF' final é inserido no arquivo especificado.
cat > "${NGINX_CONF_AVAILABLE}" <<EOF
server {
    # Escuta na porta 80 para tráfego IPv4 e IPv6.
    listen 80;
    listen [::]:80;

    # Define a pasta raiz para este site.
    root ${PROJECT_ROOT};
    # Define os nomes de domínio que este bloco de servidor irá responder.
    server_name ${PROJECT_URL};

    # Define a ordem de arquivos a serem procurados como página inicial.
    index index.php index.html;

    # Configuração de roteamento principal.
    # Tenta encontrar o arquivo solicitado. Se não encontrar, tenta ver se é um diretório.
    # Se falhar, redireciona a requisição para /index.php, permitindo "URLs amigáveis".
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    # Bloco que processa arquivos PHP.
    # A expressão regular '~ \.php$' captura qualquer requisição que termine com .php.
    location ~ \.php$ {
        # Inclui um arquivo de configuração padrão para FastCGI.
        include snippets/fastcgi-php.conf;
        # Passa a requisição para o socket do PHP-FPM que foi encontrado dinamicamente.
        fastcgi_pass unix:${PHP_SOCKET_PATH};
    }

    # Bloco de segurança para negar o acesso a arquivos .htaccess, que são
    # usados pelo servidor Apache e não devem ser expostos pelo Nginx.
    location ~ /\.ht {
        deny all;
    }
}
EOF
echo -e "   Configuração gerada."

# ETAPA 3: HABILITAÇÃO DO SITE E ATUALIZAÇÃO DO HOSTS
echo -e "🔗 [ETAPA 3/4] Habilitando site e atualizando /etc/hosts..."

# 'ln -s' cria um link simbólico. O Nginx lê os arquivos em 'sites-enabled'.
# Criar um link do arquivo de 'sites-available' é a prática padrão para habilitar um site.
ln -s "${NGINX_CONF_AVAILABLE}" "${NGINX_CONF_ENABLED}"

# Adiciona a entrada do host local no arquivo /etc/hosts, que o sistema operacional
# usa para resolver nomes de domínio localmente.
# 'grep -q' executa uma busca silenciosa ('-q'). O '!' inverte o resultado.
# O comando lê-se: "Se a linha '127.0.0.1 projeto.local' NÃO for encontrada...".
if ! grep -q "127.0.0.1 ${PROJECT_URL}" /etc/hosts; then
    # '>>' anexa a linha ao final do arquivo.
    echo "127.0.0.1 ${PROJECT_URL}" >> /etc/hosts
fi
echo -e "   Site habilitado e hosts atualizado."

# ETAPA 4: TESTE E RECARGA DO NGINX
echo -e "🔄 [ETAPA 4/4] Validando e recarregando o Nginx..."

# 'nginx -t' testa a sintaxe de todos os arquivos de configuração do Nginx.
# Se houver um erro, o 'set -e' no início do script irá pará-lo aqui.
nginx -t

# 'systemctl reload nginx' recarrega a configuração do Nginx sem derrubar
# as conexões existentes. É mais seguro que um 'restart'.
systemctl reload nginx
echo -e "   Nginx recarregado com sucesso."

# --- SEÇÃO 3: MENSAGEM FINAL ---

# Exibe uma mensagem final amigável com as informações de acesso.
echo ""
echo -e "${C_GREEN}===================================================================${C_NC}"
echo -e "${C_GREEN}✅  S U C E S S O ! O ambiente '${PROJECT_NAME}' foi consolidado.${C_NC}"
echo -e "${C_GREEN}===================================================================${C_NC}"
echo ""
echo -e "${C_BLUE}-- Acesso ao Projeto --${C_NC}"
echo -e "   URL Local:   ${C_YELLOW}http://${PROJECT_URL}${C_NC}"
echo -e "   Diretório:   ${PROJECT_ROOT}"
echo ""
echo -e "CLT cumpriu o seu papel. Pode começar a trabalhar!"
echo -e "${C_GREEN}===================================================================${C_NC}"
echo ""
