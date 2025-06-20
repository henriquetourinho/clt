#!/bin/bash

# /*********************************************************************************
# * Projeto:   CLT (Versão 9.3 - Descrições Atualizadas)
# * Script:    clt.sh
# * Autor:     Carlos Henrique Tourinho Santana
# * Data:      19 de junho de 2025
# * GitHub:    https://github.com/henriquetourinho/clt
# *
# * Descrição:
# * Versão com as descrições de funcionalidades atualizadas na página
# * de boas-vindas profissional para ambientes não-WordPress.
# *********************************************************************************/

# --- CONFIGURAÇÃO INICIAL E VARIÁVEIS ---
set -e
C_RED='\033[0;31m'; C_GREEN='\033[0;32m'; C_YELLOW='\033[0;33m'; C_BLUE='\033[0;34m'; C_NC='\033[0m'
DEFAULT_PORT=80; USE_SSL=false; VERBOSE=false; PORT_IS_CUSTOM=false; PROJECT_NAME=""; COMMAND="create"; AUTO_TRUST=false; INSTALL_WP=false

# --- FUNÇÕES ---
function mostrar_ajuda_simples() {
    echo "Uso: sudo $0 [comando|nome-do-projeto] [opções]"
    echo "Para uma lista completa de exemplos, execute o script sem argumentos: ./clt.sh"
    exit 1
}

function mostrar_exemplos_completos() {
    echo -e "${C_GREEN}Bem-vindo ao CLT - Versão 9.3 (Final)${C_NC}"
    echo -e "Seu assistente para criar ambientes de desenvolvimento de forma rápida e segura."
    echo -e "\n${C_BLUE}--- EXEMPLOS COMPLETOS DE USO ---${C_NC}\n"
    echo -e "${C_YELLOW}# 1. Criar um site BÁSICO (HTTP)${C_NC}"
    echo -e "   Cria um ambiente simples com uma página de boas-vindas profissional."
    echo -e "   URL: http://projeto-html.local"
    echo -e "   ${C_GREEN}sudo ./clt.sh projeto-html${C_NC}\n"
    echo -e "${C_YELLOW}# 2. Criar um site BÁSICO com HTTPS${C_NC}"
    echo -e "   Cria um ambiente seguro. O navegador exibirá um aviso de certificado."
    echo -e "   URL: https://site-seguro.local"
    echo -e "   ${C_GREEN}sudo ./clt.sh site-seguro --ssl${C_NC}\n"
    echo -e "${C_YELLOW}# 3. Criar um site WORDPRESS (HTTP)${C_NC}"
    echo -e "   Instala o WordPress com banco de dados. O script pedirá a senha do admin do MySQL."
    echo -e "   URL: http://meu-blog-wp.local"
    echo -e "   ${C_GREEN}sudo ./clt.sh meu-blog-wp --wordpress${C_NC}\n"
    echo -e "${C_YELLOW}# 4. Criar um site WORDPRESS com HTTPS e 'CADEADO VERDE' (RECOMENDADO)${C_NC}"
    echo -e "   A combinação mais poderosa: WordPress + HTTPS + Certificado Confiável."
    echo -e "   ${C_GREEN}sudo ./clt.sh meu-painel-wp --wordpress --ssl --auto-trust${C_NC}"
    echo -e "   ${C_YELLOW}Lembre-se de reiniciar o navegador após usar '--auto-trust'!${C_NC}\n"
    echo -e "${C_YELLOW}# 5. Outras Funcionalidades${C_NC}"
    echo -e "   Listar todos os ambientes criados:"
    echo -e "   ${C_GREEN}sudo ./clt.sh list${C_NC}\n"
    echo -e "   Criar um site em uma porta diferente (ex: 8080):"
    echo -e "   ${C_GREEN}sudo ./clt.sh minha-api --port=8080${C_NC}\n"
    echo -e "Dica: Adicione a flag ${C_BLUE}--verbose${C_NC} a qualquer comando de criação para ver os detalhes da execução."
    exit 0
}

function verificar_dependencias() {
    local dependencies=("nginx" "systemctl" "find" "grep" "tr" "chmod" "chown" "cp" "openssl" "update-ca-certificates")
    if [ "$INSTALL_WP" = true ]; then dependencies+=("curl" "tar" "mysql"); fi
    echo -e "${C_BLUE}🔎  Verificando dependências de software...${C_NC}"
    for cmd in "${dependencies[@]}"; do if ! command -v "$cmd" &> /dev/null; then echo -e "${C_RED}❌ ERRO: Dependência '${cmd}' não encontrada.${C_NC}"; exit 1; fi; done
    echo -e "   Todas as dependências foram encontradas."
}

function verificar_servicos_essenciais() {
    echo -e "${C_BLUE}🔎  Verificando status dos serviços essenciais...${C_NC}"
    local services=("nginx")
    if [ "$INSTALL_WP" = true ]; then
        if systemctl list-units --type=service | grep -q 'mariadb.service'; then services+=("mariadb")
        elif systemctl list-units --type=service | grep -q 'mysql.service'; then services+=("mysql"); fi
    fi
    for srv in "${services[@]}"; do
        if ! systemctl is-active --quiet "${srv}.service"; then
            echo -e "${C_RED}❌ ERRO: O serviço '${srv}' não está ativo. Inicie-o com 'sudo systemctl start ${srv}'${C_NC}"
            exit 1
        fi
    done
    echo -e "   Todos os serviços necessários estão ativos."
}

function criar_pagina_indice() {
    cat > "${PROJECT_ROOT}/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CLT - Seu Ambiente Está Pronto.</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --color-bg: #f9fafb;
            --color-surface: #ffffff;
            --color-border: #e5e7eb;
            --color-text-title: #111827;
            --color-text-body: #374151;
            --color-text-muted: #6b7280;
            --color-primary: #1d4ed8;
            --color-primary-light: #eff6ff;
            --color-success: #16a34a;
            --shadow-sm: 0 1px 2px rgb(0 0 0 / 0.04);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--color-bg);
            color: var(--color-text-body);
            margin: 0;
            padding: 2rem 1rem;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }

        .container {
            max-width: 840px;
            width: 100%;
            opacity: 0;
            transform: translateY(20px);
            animation: fadeIn 0.6s 0.2s forwards cubic-bezier(0.2, 0.8, 0.2, 1);
        }

        @keyframes fadeIn {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            background-color: var(--color-surface);
            border: 1px solid var(--color-border);
            border-radius: 0.75rem;
            box-shadow: var(--shadow-md);
            margin-bottom: 2rem;
            overflow: hidden;
        }

        .card-header {
            padding: 2rem 2.5rem;
            border-bottom: 1px solid var(--color-border);
        }

        .card-body {
            padding: 2.5rem;
        }

        .card-title {
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 1.75rem;
            color: var(--color-text-title);
            margin: 0 0 0.5rem;
        }
        
        .card-subtitle {
            font-size: 1.125rem;
            color: var(--color-text-muted);
            margin: 0;
        }
        
        h2 {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--color-text-title);
            margin: 0 0 1.5rem;
        }

        p {
            line-height: 1.65;
            margin: 0 0 1rem;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .feature {
            background-color: var(--color-bg);
            border: 1px solid var(--color-border);
            border-radius: 0.5rem;
            padding: 1.5rem;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .feature:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
        }

        .feature-icon {
            width: 2.5rem;
            height: 2.5rem;
            color: var(--color-primary);
            margin-bottom: 1rem;
        }

        .feature-title {
            font-weight: 600;
            color: var(--color-text-title);
            margin: 0 0 0.25rem;
        }

        .feature-description {
            font-size: 0.9rem;
            color: var(--color-text-muted);
            margin: 0;
        }
        
        .value-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        .value-table th, .value-table td {
            padding: 0.85rem 1rem;
            text-align: left;
            border-bottom: 1px solid var(--color-border);
        }
        .value-table thead {
            background-color: var(--color-bg);
        }
        .value-table th {
            font-weight: 500;
            color: var(--color-text-muted);
        }
        .value-table td:last-child, .value-table th:last-child {
            text-align: right;
        }

        .cta-section {
            background: linear-gradient(135deg, #1e3a8a, #2563eb);
            color: white;
            text-align: center;
        }
        .cta-section.card-body {
            padding: 2.5rem;
        }
        .cta-section h2 {
            color: white;
        }
        .cta-section p {
            max-width: 600px;
            margin: 0 auto 1.5rem auto;
            opacity: 0.9;
        }

        .pix-key {
            font-family: monospace;
            font-size: 1.1rem;
            padding: 1rem;
            background-color: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 0.5rem;
            display: inline-block;
            user-select: all;
        }
        
        .footer {
            text-align: center;
            padding: 2rem 1rem;
            font-size: 0.9rem;
            color: var(--color-text-muted);
        }
        .footer p {
            margin-bottom: 0.5rem;
        }
        .footer a {
            color: var(--color-primary);
            text-decoration: none;
            font-weight: 500;
        }
        .footer a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>

    <div class="container">
        <main>
            <div class="card">
                <div class="card-header">
                    <h1 class="card-title">Seu Ambiente de Desenvolvimento Está Pronto</h1>
                    <p class="card-subtitle">Com um único comando, o CLT provisionou os seguintes recursos para você:</p>
                </div>
                <div class="card-body">
                    <div class="features-grid">
                        <div class="feature">
                            <svg class="feature-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M12 15v2.25A2.25 2.25 0 0014.25 21h4.5A2.25 2.25 0 0021 18.75V16.5M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 12A8.25 8.25 0 1015 3.75v2.25A2.25 2.25 0 0012.75 9H12A2.25 2.25 0 009.75 11.25v1.5" /></svg>
                            <h3 class="feature-title">Servidor Nginx Otimizado</h3>
                            <p class="feature-description">Um servidor web de alta performance, já configurado para o seu projeto.</p>
                        </div>
                        <div class="feature">
                            <svg class="feature-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z" /></svg>
                            <h3 class="feature-title">HTTPS & Certificado SSL</h3>
                            <p class="feature-description">Navegação segura e confiável, com criptografia ativada por padrão.</p>
                        </div>
                        <div class="feature">
                            <svg class="feature-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" d="M20.25 6.375c0 2.278-3.694 4.125-8.25 4.125S3.75 8.653 3.75 6.375m16.5 0c0-2.278-3.694-4.125-8.25-4.125S3.75 4.097 3.75 6.375m16.5 0v11.25c0 2.278-3.694 4.125-8.25 4.125s-8.25-1.847-8.25-4.125V6.375" /></svg>
                            <h3 class="feature-title">Banco de Dados MySQL</h3>
                            <p class="feature-description">Uma base de dados pronta para uso, esperando pela sua aplicação.</p>
                        </div>
                        <div class="feature">
                            <svg class="feature-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"><path d="M10.273 4.827l-1.422 3.656a.75.75 0 00.528.918l3.656 1.422a.75.75 0 00.918-.528l1.422-3.656a.75.75 0 00-.528-.918l-3.656-1.422a.75.75 0 00-.918.528z" /><path d="M12.001 15.155a3.155 3.155 0 013.155-3.155H18a.75.75 0 01.75.75v3.155a3.155 3.155 0 01-3.155 3.155h-1.5a.75.75 0 01-.75-.75v-1.5a.75.75 0 01.75-.75H15.156a.155.155 0 00.155-.155v-.7a.155.155 0 00-.155-.155H12a.75.75 0 01-.75-.75v-1.5a.75.75 0 01.75-.75h3.155a.155.155 0 00.155.155v.7a.155.155 0 00.155.155H18a.75.75 0 01.75.75v1.5a.75.75 0 01-.75-.75h-3.155a.155.155 0 00-.155.155v.7a.155.155 0 00.155.155H15.75a.75.75 0 010 1.5h-.75a3.155 3.155 0 01-3.155-3.155zM6.845 9.845a.75.75 0 010-1.5h1.5a.75.75 0 010 1.5h-1.5zM4.5 7.5a.75.75 0 001.5 0v-1.5a.75.75 0 00-1.5 0v1.5zM8.345 4.5a.75.75 0 010-1.5h1.5a.75.75 0 010 1.5h-1.5z" /></svg>
                            <h3 class="feature-title">WordPress (Opcional)</h3>
                            <p class="feature-description">A plataforma mais popular do mundo, instalada e pronta para uso.</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <h2>💡 A Missão por Trás do Código</h2>
                    <p>No Brasil, muita gente desiste antes mesmo de começar a programar. Por conta de barreiras técnicas, falta de apoio, ou simplesmente por não conseguir configurar o básico.</p>
                    <p>O CLT foi criado para derrubar uma das maiores barreiras para quem começa a programar no Brasil: a complexidade de configurar um ambiente de desenvolvimento. Ele automatiza o que antes levava horas — e exigia conhecimento técnico avançado.</p>
                    <p>Tudo isso de forma gratuita, acessível e com foco em educação, inclusão e avanço tecnológico. Este projeto é um passo nessa direção, oferecendo uma ferramenta poderosa para que mais pessoas possam aprender, criar e inovar.</p>
                </div>
            </div>
            
            <div class="card">
                <div class="card-body">
                    <h2>💰 O Valor do que Você Recebeu Gratuitamente</h2>
                    <p>Enquanto o CLT entrega este ambiente em segundos, o custo de mercado para uma configuração manual similar é considerável:</p>
                    <table class="value-table">
                        <thead>
                            <tr>
                                <th>Serviço Profissional</th>
                                <th>Tempo Médio</th>
                                <th>Custo Médio de Mercado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Freelancer Júnior</td>
                                <td>1h a 2h</td>
                                <td>R$ 150 – R$ 300</td>
                            </tr>
                            <tr>
                                <td>Desenvolvedor Pleno/Sênior</td>
                                <td>1h a 1h30</td>
                                <td>R$ 300 – R$ 700</td>
                            </tr>
                            <tr>
                                <td>Agência Especializada</td>
                                <td>2h a 4h</td>
                                <td>R$ 800 – R$ 1.500+</td>
                            </tr>
                        </tbody>
                    </table>
                    <p style="margin-top: 1.5rem;">Com o <strong>CLT</strong>, tudo isso acontece em <strong>menos de 30 segundos</strong>.  🇧🇷</p>
                </div>
                <div class="card-body cta-section">
                    <h2>🤝 Faça Parte Dessa Missão</h2>
                    <p>Se esta ferramenta foi útil para você, considere apoiar o projeto. Sua contribuição, de qualquer valor, ajuda a manter o CLT atualizado e a criar novas ferramentas de código aberto para a comunidade brasileira.</p>
                    <div class="pix-key">poupanca@henriquetourinho.com.br</div>
                </div>
            </div>
        </main>
        <footer class="footer">
            <p>Criado com muito ❤️ por:</p>
            <p><strong>Carlos Henrique Tourinho Santana</strong></p>
            <p>
                <a href="https://github.com/henriquetourinho" target="_blank" rel="noopener noreferrer">GitHub</a> &nbsp;•&nbsp;
                <a href="https://br.linkedin.com/in/carloshenriquetourinhosantana" target="_blank" rel="noopener noreferrer">LinkedIn</a> &nbsp;•&nbsp;
                <a href="https://wiki.debian.org/henriquetourinho" target="_blank" rel="noopener noreferrer">Debian Wiki</a>
            </p>
        </footer>
    </div>

</body>
</html>
EOF
    chown www-data:www-data "${PROJECT_ROOT}/index.html"
}

# --- ANÁLISE DE ARGUMENTOS ---
if [ "$#" -eq 0 ]; then mostrar_exemplos_completos; fi
if [ "$1" = "list" ]; then COMMAND="list"; else
    COMMAND="create"; for arg in "$@"; do
      case $arg in
        --wordpress) INSTALL_WP=true; shift ;;
        --ssl) USE_SSL=true; shift ;;
        --auto-trust) AUTO_TRUST=true; shift ;;
        --port=*) DEFAULT_PORT="${arg#*=}"; PORT_IS_CUSTOM=true; shift ;;
        --verbose) VERBOSE=true; shift ;;
        -*) echo -e "${C_RED}❌ ERRO: Opção inválida '$arg'${C_NC}"; mostrar_ajuda_simples ;;
        *) if [ -z "$PROJECT_NAME" ]; then PROJECT_NAME=$(echo "$arg" | tr -cd '[:alnum:]_-'); fi ;;
      esac; done; fi
if [ "$VERBOSE" = true ]; then set -x; fi
if [ "$(id -u)" -ne 0 ]; then echo -e "${C_RED}❌ ERRO: Este script precisa de privilégios de root.${C_NC}"; exit 1; fi

# --- EXECUÇÃO DOS COMANDOS ---
if [ "$COMMAND" = "list" ]; then
    echo -e "${C_BLUE}📋 Listando ambientes configurados...${C_NC}"; find /etc/nginx/sites-available -maxdepth 1 -type f -printf "  - %f\n"; exit 0; fi

# --- LÓGICA DE CRIAÇÃO ---
if [ -z "$PROJECT_NAME" ]; then echo -e "${C_RED}❌ ERRO: Nome do projeto não fornecido.${C_NC}"; mostrar_ajuda_simples; fi
if [ "$AUTO_TRUST" = true ] && [ "$USE_SSL" = false ]; then echo -e "${C_RED}❌ ERRO: A opção --auto-trust requer --ssl.${C_NC}"; exit 1; fi
if [ "$USE_SSL" = true ] && [ "$PORT_IS_CUSTOM" = false ]; then DEFAULT_PORT=443; fi

verificar_dependencias
verificar_servicos_essenciais

PROJECT_ROOT="/var/www/${PROJECT_NAME}"; PROJECT_URL="${PROJECT_NAME}.local"; NGINX_CONF_AVAILABLE="/etc/nginx/sites-available/${PROJECT_NAME}"; NGINX_CONF_ENABLED="/etc/nginx/sites-enabled/${PROJECT_NAME}"; SSL_CERT_DIR="/etc/nginx/ssl/${PROJECT_NAME}"
if [ -d "${PROJECT_ROOT}" ] || [ -f "${NGINX_CONF_AVAILABLE}" ]; then echo -e "${C_YELLOW}⚠️ AVISO: O projeto '${PROJECT_NAME}' já existe.${C_NC}"; exit 1; fi

echo -e "\n${C_BLUE}🚀 Iniciando consolidação do ambiente: ${PROJECT_NAME}${C_NC}"
echo -e "📂 [ETAPA 1] Criando diretório do projeto..."
mkdir -p "${PROJECT_ROOT}"; chown -R www-data:www-data "${PROJECT_ROOT}"; chmod -R 755 "${PROJECT_ROOT}"
echo -e "   Diretório criado."

if [ "$INSTALL_WP" = true ]; then
    echo -e "\n${C_BLUE}--- Iniciando Instalação do WordPress ---${C_NC}"
    echo "⚙️  [WP 1/5] Coletando credenciais do administrador do MySQL..."
    read -p "   Digite o nome do usuário administrativo do MySQL (padrão: root): " DB_ADMIN_USER
    DB_ADMIN_USER=${DB_ADMIN_USER:-root}
    read -s -p "   Digite a senha para o usuário '${DB_ADMIN_USER}': " DB_ADMIN_PASSWORD; echo ""
    MYSQL_CMD="mysql -u'${DB_ADMIN_USER}' -p'${DB_ADMIN_PASSWORD}'"
    echo "   Verificando conexão com o banco de dados..."
    if ! eval "${MYSQL_CMD} -e 'SELECT 1;'" &> /dev/null; then echo -e "${C_RED}❌ ERRO: Credenciais inválidas ou acesso negado.${C_NC}"; exit 1; fi
    echo -e "${C_GREEN}   Conexão bem-sucedida!${C_NC}"

    echo "⚙️  [WP 2/5] Configurando banco de dados para o projeto..."
    DB_NAME=$(echo "${PROJECT_NAME}" | tr '-' '_' | cut -c 1-54)_db; DB_USER=$(echo "${PROJECT_NAME}" | tr '-' '_' | cut -c 1-26)_user
    DB_PASSWORD=$(date +%s%N | sha256sum | base64 | head -c 32); SQL_COMMANDS="CREATE DATABASE IF NOT EXISTS ${DB_NAME}; CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}'; GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost'; FLUSH PRIVILEGES;"
    eval "${MYSQL_CMD} -e \"${SQL_COMMANDS}\""; echo "   Banco de dados '${DB_NAME}' e usuário '${DB_USER}' criados."
    
    echo "📥 [WP 3/5] Baixando arquivos do WordPress..."; curl -sL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz
    if [ $? -ne 0 ]; then echo -e "${C_RED}❌ ERRO: Falha ao baixar o WordPress. Verifique sua conexão.${C_NC}"; exit 1; fi
    echo "   Extraindo arquivos..."; tar -xzf /tmp/wordpress.tar.gz -C /tmp
    if [ $? -ne 0 ]; then echo -e "${C_RED}❌ ERRO: Falha ao extrair o arquivo do WordPress.${C_NC}"; exit 1; fi
    mv /tmp/wordpress/* "${PROJECT_ROOT}/"; rm -rf /tmp/wordpress /tmp/wordpress.tar.gz; echo "   Arquivos do WordPress instalados."

    echo "📝 [WP 4/5] Gerando wp-config.php..."; WP_CONFIG_SAMPLE="${PROJECT_ROOT}/wp-config-sample.php"; WP_CONFIG="${PROJECT_ROOT}/wp-config.php"
    if [ ! -f "$WP_CONFIG_SAMPLE" ]; then echo -e "${C_RED}❌ ERRO: 'wp-config-sample.php' não encontrado.${C_NC}"; exit 1; fi
    cp "${WP_CONFIG_SAMPLE}" "${WP_CONFIG}"; sed -i "s/database_name_here/${DB_NAME}/g" "${WP_CONFIG}"; sed -i "s/username_here/${DB_USER}/g" "${WP_CONFIG}"; sed -i "s/password_here/${DB_PASSWORD}/g" "${WP_CONFIG}"
    
    echo "🔑 [WP 5/5] Gerando chaves de segurança (salts)..."; SALT_KEYS=$(curl -sL https://api.wordpress.org/secret-key/1.1/salt/)
    if [ -z "$SALT_KEYS" ]; then echo -e "${C_YELLOW}⚠️ AVISO: Não foi possível buscar novas chaves de segurança. Atualize o wp-config.php manualmente.${C_NC}"; else
    awk -v salts="${SALT_KEYS}" '/#@-/ {p=1} /#@+/,/#@-/ {next} p {print salts; p=0} 1' "${WP_CONFIG}" > "${WP_CONFIG}.tmp" && mv "${WP_CONFIG}.tmp" "${WP_CONFIG}"; fi
    chown -R www-data:www-data "${PROJECT_ROOT}"; echo "   Configuração finalizada."
else
    echo -e "📄 [ETAPA 2] Gerando página de boas-vindas..."
    criar_pagina_indice; echo -e "   Página de sucesso gerada."
fi

echo -e "\n${C_BLUE}--- Finalizando Configuração do Servidor ---${C_NC}"
STEP_NUM=3; if [ "$INSTALL_WP" = true ]; then STEP_NUM=2; fi;
if [ "$USE_SSL" = true ]; then
    echo -e "🔒 [ETAPA ${STEP_NUM}] Gerando certificado SSL..."; mkdir -p "${SSL_CERT_DIR}"; openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout "${SSL_CERT_DIR}/${PROJECT_NAME}.key" -out "${SSL_CERT_DIR}/${PROJECT_NAME}.crt" -subj "/CN=${PROJECT_URL}"
    echo -e "   Certificado gerado."; STEP_NUM=$((STEP_NUM + 1)); fi

echo -e "⚙️  [ETAPA ${STEP_NUM}] Gerando configuração do Nginx..."; PHP_SOCKET_PATH=$(find /run/php/ -name "php*-fpm.sock" | head -n 1)
if [ -z "${PHP_SOCKET_PATH}" ]; then echo -e "${C_RED}❌ ERRO: Nenhum socket PHP-FPM encontrado.${C_NC}"; exit 1; fi
if [ "$USE_SSL" = false ]; then cat > "${NGINX_CONF_AVAILABLE}" <<EOF
server { listen ${DEFAULT_PORT}; listen [::]:${DEFAULT_PORT}; root ${PROJECT_ROOT}; server_name ${PROJECT_URL}; index index.php index.html; location / { try_files \$uri \$uri/ /index.php?\$query_string; } location ~ \.php$ { include snippets/fastcgi-php.conf; fastcgi_pass unix:${PHP_SOCKET_PATH}; } location ~ /\.ht { deny all; } }
EOF
else cat > "${NGINX_CONF_AVAILABLE}" <<EOF
server { listen 80; listen [::]:80; server_name ${PROJECT_URL}; return 301 https://\$host\$request_uri; }
server { listen ${DEFAULT_PORT} ssl http2; listen [::]:${DEFAULT_PORT} ssl http2; server_name ${PROJECT_URL}; root ${PROJECT_ROOT}; index index.php index.html; ssl_certificate ${SSL_CERT_DIR}/${PROJECT_NAME}.crt; ssl_certificate_key ${SSL_CERT_DIR}/${PROJECT_NAME}.key; location / { try_files \$uri \$uri/ /index.php?\$query_string; } location ~ \.php$ { include snippets/fastcgi-php.conf; fastcgi_pass unix:${PHP_SOCKET_PATH}; } location ~ /\.ht { deny all; } }
EOF
fi; echo -e "   Configuração gerada."; STEP_NUM=$((STEP_NUM + 1));

echo -e "🔗 [ETAPA ${STEP_NUM}] Habilitando site e atualizando hosts..."; ln -s "${NGINX_CONF_AVAILABLE}" "${NGINX_CONF_ENABLED}"
if ! grep -q "127.0.0.1 ${PROJECT_URL}" /etc/hosts; then echo "127.0.0.1 ${PROJECT_URL}" >> /etc/hosts; fi
echo -e "   Site habilitado."; STEP_NUM=$((STEP_NUM + 1));

echo -e "🔄 [ETAPA ${STEP_NUM}] Validando e recarregando o Nginx..."; nginx -t; systemctl reload nginx
echo -e "   Nginx recarregado."; STEP_NUM=$((STEP_NUM + 1));

if [ "$AUTO_TRUST" = true ]; then
    echo -e "🛡️  [ETAPA ${STEP_NUM}] Instalando certificado no sistema..."; cp "${SSL_CERT_DIR}/${PROJECT_NAME}.crt" "/usr/local/share/ca-certificates/${PROJECT_NAME}.crt"
    update-ca-certificates > /dev/null; echo -e "   Certificado instalado."; fi

FINAL_URL_SCHEME="http"; if [ "$USE_SSL" = true ]; then FINAL_URL_SCHEME="https"; fi; FINAL_URL="${FINAL_URL_SCHEME}://${PROJECT_URL}"; if ([ "$USE_SSL" = false ] && [ "$DEFAULT_PORT" -ne 80 ]) || ([ "$USE_SSL" = true ] && [ "$DEFAULT_PORT" -ne 443 ]); then FINAL_URL="${FINAL_URL}:${DEFAULT_PORT}"; fi
echo -e "\n${C_GREEN}===================================================================${C_NC}"
echo -e "${C_GREEN}✅  S U C E S S O ! O ambiente '${PROJECT_NAME}' foi consolidado.${C_NC}"
echo -e "${C_GREEN}===================================================================${C_NC}\n"
echo -e "${C_BLUE}-- Acesso ao Projeto --${C_NC}"; echo -e "   URL Local:   ${C_YELLOW}${FINAL_URL}${C_NC}"; echo -e "   Diretório:   ${C_YELLOW}${PROJECT_ROOT}${C_NC}\n"
if [ "$INSTALL_WP" = true ]; then
    echo -e "${C_YELLOW}--- Credenciais do Banco de Dados WordPress ---${C_NC}"
    echo -e "Banco de Dados: ${C_GREEN}${DB_NAME}${C_NC}"; echo -e "Usuário:        ${C_GREEN}${DB_USER}${C_NC}"; echo -e "Senha:          ${C_GREEN}${DB_PASSWORD}${C_NC}"
    echo -e "\n${C_BLUE}Próximo passo: Abra a URL do seu site no navegador para completar a instalação do WordPress.${C_NC}\n"
fi
if [ "$AUTO_TRUST" = true ]; then echo -e "${C_YELLOW}⚠️  AÇÃO NECESSÁRIA: Reinicie completamente o seu navegador para que a mudança tenha efeito.${C_NC}\n"; fi