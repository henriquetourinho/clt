# CLT (v9.3) — Consolidador de Local de Trabalho (Provisionamento Automático LEMP para Debian e Derivados)

**Autor:** Carlos Henrique Tourinho Santana  
**GitHub:** [henriquetourinho/clt](https://github.com/henriquetourinho/clt)  
**Última atualização:** 19 de junho de 2025

---

## 🚀 O que é o CLT?

O **CLT — Consolidador de Local de Trabalho** é um script Shell para **provisionamento instantâneo** de ambientes de desenvolvimento LEMP (Nginx, MariaDB/MySQL, PHP) em sistemas Debian e derivados, com foco em produtividade, padronização e automação profissional. Com um único comando, você configura ambientes para projetos estáticos, PHP puro ou WordPress, com HTTPS local e integração automática de certificados.

> **Missão:** Democratizar o acesso a ambientes de desenvolvimento profissionais para a comunidade brasileira, reduzindo barreiras técnicas e acelerando o início de novos projetos.

---

## 🛠️ Recursos Técnicos

- **Provisionamento automatizado:** Criação de ambientes locais completos em segundos (HTTP ou HTTPS, com/sem WordPress).
- **Configuração de Nginx:** Geração dinâmica de virtual hosts, suporte a múltiplas versões de PHP (detecção automática do socket PHP-FPM).
- **Banco de dados pronto:** MariaDB/MySQL com usuários e permissões isoladas por projeto.
- **WordPress on demand:** Instalação e configuração automática, incluindo geração de `wp-config.php` e salts.
- **SSL/HTTPS local:** Geração de certificado autoassinado, com opção `--auto-trust` para integração ao sistema operacional (cadeado verde).
- **Página de boas-vindas:** Template HTML profissional para projetos sem WordPress.
- **Gerenciamento prático:** Listagem de ambientes, escolha de porta customizada (`--port`), modo verboso para debug, mensagens de erro detalhadas.
- **Atualização automática do `/etc/hosts`** para resolução local dos domínios de teste.
- **Execução protegida:** Script só roda como root, evita sobrescrita de ambientes existentes.

---

## 🎯 Exemplos de Uso (CLI)

Execute sempre como **root** (`sudo`):

```bash
# Criar site estático simples (HTTP)
sudo ./clt.sh meu-projeto

# Criar site com HTTPS (SSL)
sudo ./clt.sh site-seguro --ssl

# Criar ambiente WordPress (HTTP)
sudo ./clt.sh meu-blog-wp --wordpress

# WordPress com HTTPS e certificado confiável (cadeado verde)
sudo ./clt.sh meu-painel-wp --wordpress --ssl --auto-trust

# Listar todos os ambientes criados
sudo ./clt.sh list

# Definir porta customizada (exemplo: 8080)
sudo ./clt.sh api-local --port=8080

# Modo detalhado (debug)
sudo ./clt.sh meu-projeto --verbose
```

---

## 📋 Pré-Requisitos

- **SO:** Debian ou qualquer distribuição derivada (ex: Kali, LMDE, MX Linux, etc)
- **Permissão:** root (sudo)
- **Pacotes obrigatórios:**  
  `nginx`, `systemctl`, `find`, `grep`, `tr`, `chmod`, `chown`, `cp`, `openssl`, `update-ca-certificates`
- **WordPress:**  
  `curl`, `tar`, `mysql` (MariaDB ou MySQL Server)
- O script identifica dependências ausentes e orienta a instalação.

---

## 🧩 O que está incluído em cada ambiente?

- **Nginx:** Virtual host dedicado, pronto para produção local.
- **Banco de Dados:** MariaDB/MySQL com usuário e senha exclusivos por projeto.
- **PHP-FPM:** Compatível com múltiplas versões (auto-detecta o socket).
- **HTTPS/SSL:** Certificado autoassinado gerado automaticamente (opcional auto-trust no sistema).
- **WordPress:** Instalação e configuração completa com um comando.
- **Página inicial HTML:** Para ambientes não-WordPress.
- **DNS local:** Adição automática ao `/etc/hosts`.
- **Ambientes independentes:** Isolamento por nome de projeto.

---

## 🔐 Segurança e Boas Práticas

- Execução restrita a root/admin
- Não sobrescreve ambientes existentes
- Geração automática de senhas seguras para bancos de dados
- Fácil remoção manual: basta apagar o diretório do projeto e as configs do Nginx

---

## 💸 Valor agregado

| Serviço Profissional      | Tempo Médio | Custo de Mercado   |
|--------------------------|-------------|--------------------|
| Freelancer Júnior         | 1h a 2h     | R$ 150 – R$ 300    |
| Dev Pleno/Sênior          | 1h a 1h30   | R$ 300 – R$ 700    |
| Agência Especializada     | 2h a 4h     | R$ 800 – R$ 1.500+ |

Com o **CLT**, o ambiente fica pronto em **menos de 30 segundos**. 🇧🇷

---

## 🎬 Demonstração do Funcionamento

<p align="center">
  <img src="https://raw.githubusercontent.com/henriquetourinho/clt/main/media/funcionamento.gif" alt="Funcionamento do CLT" width="700">
</p>

---

## 🤝 Apoie o Projeto

Se o CLT foi útil, considere apoiar para manter a iniciativa viva e em evolução para toda a comunidade:

**Chave Pix:**  
```
poupanca@henriquetourinho.com.br
```

---

### Licença

Este projeto é distribuído sob a **GPL-3.0 license**. Veja o arquivo `LICENSE` para mais detalhes.

## 🙋‍♂️ Desenvolvido por

**Carlos Henrique Tourinho Santana** 📍 Salvador - Bahia  
<br>
🔗 Wiki Debian: [wiki.debian.org/henriquetourinho](https://wiki.debian.org/henriquetourinho)  
<br>
🔗 LinkedIn: [br.linkedin.com/in/carloshenriquetourinhosantana](https://br.linkedin.com/in/carloshenriquetourinhosantana)  
<br>
🔗 GitHub: [github.com/henriquetourinho](https://github.com/henriquetourinho)
