# CLT (v9.9 LEGADO) — Consolidador de Local de Trabalho  
**Provisionamento Automático LEMP para Debian e Derivados**

**Autor:** Carlos Henrique Tourinho Santana  
**GitHub:** [henriquetourinho/clt](https://github.com/henriquetourinho/clt)  
**Última atualização:** 22 de junho de 2025

---

## 🚀 O que é o CLT?

O **CLT — Consolidador de Local de Trabalho** é uma ferramenta de automação para criar ambientes de desenvolvimento LEMP (Linux + Nginx + MySQL/MariaDB + PHP), com foco em acessibilidade, inclusão e velocidade.

Foi criado com uma missão clara:

> **No Brasil, muita gente desiste de programar antes mesmo de começar.**  
> Por barreiras técnicas, falta de apoio ou por não conseguir configurar nem o básico.  
> O CLT foi criado para resolver esse problema.

A proposta do CLT é derrubar uma das maiores barreiras da programação: **configurar um ambiente local de forma profissional, segura e automatizada.**

---

## 🧱 Versões Disponíveis

### `clt.sh` (padrão)  
Versão principal, ativa, modular e compatível com todas as funções.

### `clt_legado.sh` (v9.9 - FINAL)  
Última versão em Shell Script com recursos extras: `delete`, `status`, `backup`, `log`, e aviso de legado.

> ⚠️ A partir da versão 10, o CLT evolui para Python.  
> O `clt_legado.sh` permanecerá no repositório como versão estável, documentada e funcional — ideal para quem quer simplicidade e rapidez via Shell.

---

## 🛠️ Recursos Técnicos

- Criação automática de ambientes locais LEMP
- Instalação completa do WordPress com banco e configurações
- SSL local com certificado autoassinado e auto-confiança opcional (`--auto-trust`)
- Atualização automática do `/etc/hosts`
- Página de boas-vindas HTML personalizada
- Comando `list` para listar ambientes existentes
- Comando `delete` para remoção completa de ambientes
- Comando `status` para verificação de funcionamento
- Comando `backup` para exportar `.tar.gz` + banco `.sql`
- Log de todas as ações em `/var/log/clt.log`

---

## 🧩 O que está incluído em cada ambiente?

- **Nginx:** Virtual host dedicado com root isolado
- **Banco de Dados:** Usuário/senha exclusivos por projeto
- **PHP-FPM:** Suporte a várias versões (detecção automática)
- **WordPress:** Com configuração automática (`wp-config.php`, salts, db)
- **Página HTML:** Para ambientes não-WordPress
- **HTTPS:** SSL automático com opção de confiança local
- **Backup:** Exporta estrutura + DB + config
- **Log:** Todas as ações registradas

---

## 🎯 Exemplos de Uso

```bash
# Criar projeto HTML
sudo ./clt.sh meu-site

# Criar WordPress com HTTPS e confiança
sudo ./clt.sh meu-blog --wordpress --ssl --auto-trust

# Apagar um projeto
sudo ./clt.sh delete meu-site

# Fazer backup completo
sudo ./clt.sh backup meu-site

# Verificar status de um site
sudo ./clt.sh status meu-blog

# Listar projetos existentes
sudo ./clt.sh list
```

### Para a versão legado (clt_legado.sh)

```bash
# Criar projeto com página HTML
sudo ./clt_legado.sh create meu-site

# Criar com WordPress e SSL
sudo ./clt_legado.sh create blog-wp --wordpress --ssl

# Criar WordPress com SSL confiável
sudo ./clt_legado.sh create painel-wp --wordpress --ssl --auto-trust

# Deletar projeto
sudo ./clt_legado.sh delete meu-site

# Fazer backup completo
sudo ./clt_legado.sh backup blog-wp

# Checar status
sudo ./clt_legado.sh status blog-wp

# Listar todos os projetos
sudo ./clt_legado.sh list
```

---

## 📋 Pré-Requisitos

- **Distribuição:** Debian e derivados
- **Permissão:** root (sudo)
- **Pacotes obrigatórios:**  
  `nginx`, `php`, `php-fpm`, `openssl`, `mysql/mariadb`, `curl`, `tar`, `grep`, `find`, `tr`, `update-ca-certificates`

---

## 💾 Backup

A função `backup` salva:
- Arquivos HTML/PHP/WordPress do projeto
- Configuração do Nginx
- Certificados SSL
- Banco de dados (via `mysqldump`)
- Log do processo

Arquivo gerado:  
```bash
/var/backups/clt/nome-do-projeto-AAAA-MM-DD-HHMM.tar.gz
```

---

## 🔐 Segurança

- Verificação de nomes inválidos (`rm`, `etc`, `mysql` etc)
- Geração automática de senhas seguras para bancos de dados
- Execução restrita a root
- Evita sobrescrita de projetos existentes
- Logs de tudo em `/var/log/clt.log`

---

## 💸 Valor agregado

| Serviço Profissional | Tempo Médio | Custo de Mercado   |
|----------------------|-------------|--------------------|
| Freelancer Júnior    | 1h a 2h     | R$ 150 – R$ 300    |
| Dev Pleno/Sênior     | 1h a 1h30   | R$ 300 – R$ 700    |
| Agência Especializada| 2h a 4h     | R$ 800 – R$ 1.500+ |

**Com o CLT, tudo fica pronto em até 30 segundos.**

---

## 🎬 Demonstração

<p align="center">
  <img src="https://raw.githubusercontent.com/henriquetourinho/clt/main/media/funcionamento.gif" alt="Funcionamento do CLT" width="700">
</p>

---

## 🧠 E o futuro?

A partir da próxima versão, o CLT será reescrito em **Python**, com:
- Plugins
- Interface gráfica
- Integração com Docker e Git
- Painel web local
- Sistema de backup avançado
- Estrutura modular e expansível

---

## 🤝 Apoie o Projeto

Se o CLT foi útil, considere apoiar para manter a iniciativa gratuita e em expansão:

**Chave Pix:**  
```
poupanca@henriquetourinho.com.br
```

---

## 📜 Licença

Distribuído sob **GPL-3.0 license**. Veja o arquivo `LICENSE`.

---

## 🙋‍♂️ Desenvolvido por

**Carlos Henrique Tourinho Santana**  
📍 Salvador - Bahia, Brasil  

🔗 Wiki Debian: [wiki.debian.org/henriquetourinho](https://wiki.debian.org/henriquetourinho)  
🔗 LinkedIn: [br.linkedin.com/in/carloshenriquetourinhosantana](https://br.linkedin.com/in/carloshenriquetourinhosantana)  
🔗 GitHub: [github.com/henriquetourinho](https://github.com/henriquetourinho)
