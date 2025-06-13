
# clt 🚀🇧🇷

**clt** é um utilitário de linha de comando escrito em Bash, criado para **provisionar rapidamente ambientes de desenvolvimento web** em servidores que utilizam a stack **LEMP** (Linux, Nginx e PHP).

Ideal para desenvolvedores que querem evitar tarefas repetitivas, o `clt` automatiza completamente a criação de diretórios de projeto, configuração de Virtual Hosts no Nginx e mapeamento local via `/etc/hosts` — tudo isso em poucos segundos.

---

## 📦 Funcionalidades Principais

O `clt` realiza, de forma sequencial e segura:

- 📂 **Criação do Diretório**
  > Gera a estrutura padrão do projeto em:  
  > `/var/www/<nome-do-projeto>`

- 🔐 **Ajuste de Permissões**
  > Define `www-data` como proprietário do diretório, garantindo acesso correto pelo Nginx.

- ✍️ **Geração da Configuração Nginx**
  > Cria um Virtual Host personalizado em:  
  > `/etc/nginx/sites-available/<nome-do-projeto>`  
  > Com suporte automático a **PHP-FPM**.

- 🔗 **Habilitação do Site**
  > Cria um link simbólico em `/etc/nginx/sites-enabled/` para ativar o site.

- 🌐 **Resolução de Host Local**
  > Adiciona a entrada `<nome-do-projeto>.local` ao arquivo `/etc/hosts`, apontando para `127.0.0.1`.

- ✅ **Validação e Recarga do Nginx**
  > Testa a nova configuração (`nginx -t`) e recarrega o serviço (`systemctl reload nginx`) de forma segura e sem downtime.

---

## 📋 Pré-requisitos

Para utilizar o `clt`, seu ambiente precisa ter:

- ✅ Sistema operacional **Linux** (testado em Debian/Ubuntu)
- ✅ Acesso de superusuário (via `sudo`)
- ✅ Stack **LEMP** previamente instalada:
  - [x] **Nginx**
  - [x] **PHP-FPM** (qualquer versão ativa)

---

## 🛠️ Instalação

Baixe o script com `curl`:

```bash
curl -o clt.sh https://raw.githubusercontent.com/henriquetourinho/clt/main/clt.sh
```

Dê permissão de execução:

```bash
chmod +x clt.sh
```

> ℹ️ *A URL acima é apenas um exemplo. Substitua pela URL real do seu repositório.*

---

## ▶️ Como Usar

Execute o script com `sudo`, passando o nome do projeto como argumento:

```bash
sudo ./clt.sh <nome-do-projeto>
```

O nome será usado para:
- Nomear a pasta (`/var/www/<nome>`)
- Criar o Virtual Host
- Criar o domínio local (`<nome>.local`)

---

## 💡 Exemplos

Criar um projeto acessível em `http://meu-site.local`:

```bash
sudo ./clt.sh meu-site
```

Criar uma API local em `http://nova-api.local`:

```bash
sudo ./clt.sh nova-api
```

---

## 🧪 Testado e Validado

Desenvolvido por [Carlos Henrique Tourinho Santana](https://github.com/henriquetourinho), testado em ambientes reais de desenvolvimento para **ganho de tempo**, **padronização** e **simplicidade** no dia a dia.

---

## 📜 Licença

Este projeto está licenciado sob a **MIT License**. Veja o arquivo `LICENSE` no repositório para mais detalhes.