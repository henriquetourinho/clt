# 🔐 Política de Segurança – CLT

Este documento descreve as práticas de segurança adotadas pelo projeto [CLT](https://github.com/henriquetourinho/clt), bem como orientações para reporte responsável de vulnerabilidades.

---

## 🛡️ Visão Geral

O `clt.sh` é um script de automação para ambientes **LEMP** (Linux, Nginx e PHP) com execução privilegiada (`sudo/root`). Por essa razão, o uso seguro do script é de extrema importância para preservar a integridade do sistema operacional.

---

## ✅ Boas Práticas Recomendadas

Antes de executar o `clt`, recomendamos que o usuário:

- ✅ **Audite o código-fonte** localmente (é 100% open-source e legível).
- ✅ **Evite alterações não documentadas**, especialmente nas seções que afetam o Nginx ou o sistema de arquivos.
- ✅ **Execute o script somente em ambientes de desenvolvimento/testes**, especialmente em sua primeira utilização.
- ✅ **Mantenha backups** dos arquivos afetados:
  - `/etc/nginx/sites-available/`
  - `/etc/nginx/sites-enabled/`
  - `/etc/hosts`
- ✅ **Garanta que o ambiente esteja atualizado** com as versões mais recentes de segurança do sistema operacional e da stack LEMP.

---

## ⚠️ Possíveis Riscos Identificados

O uso inadequado ou a modificação indevida do `clt` pode gerar os seguintes riscos:

- ❗ Sobrescrita de arquivos de configuração existentes.
- ❗ Inserção de entradas incorretas no `/etc/hosts`.
- ❗ Permissões de diretório mal configuradas (impactando a segurança do servidor web).
- ❗ Uso em produção sem auditoria prévia.

---

## 📬 Reporte de Vulnerabilidades

Caso você identifique qualquer vulnerabilidade, falha ou comportamento suspeito no `clt`, siga os passos abaixo:

1. **Não abra uma _issue_ pública.**
2. Entre em contato diretamente via e-mail:
   - 📧 **henriquetourinho@riseup.net**
3. Forneça os seguintes dados:
   - Ambiente afetado (ex: Ubuntu 22.04, Debian 12, etc.)
   - Etapas para reprodução do problema
   - Logs ou saídas relevantes (se possível)

Todos os relatos serão tratados com confidencialidade e prioridade.

---

## 📦 Política de Correções

- 🛠️ Correções de segurança serão lançadas com prioridade máxima.
- 🔁 Atualizações regulares incluirão melhorias de segurança contínuas.
- 📄 Um `CHANGELOG.md` será mantido com registros de alterações significativas, incluindo patches de segurança.

---

## 🧠 Contribuições e Agradecimentos

A segurança do CLT é responsabilidade de toda a comunidade. Caso deseje contribuir com melhorias no código, testes de segurança ou recomendações, sinta-se à vontade para abrir uma [Pull Request](https://github.com/henriquetourinho/clt/pulls).

---

> 💬 Para dúvidas gerais, utilize a aba [Discussions](https://github.com/henriquetourinho/clt/discussions) do projeto.
>  
> 🚨 Para alertas confidenciais, use **henriquetourinho@riseup.net**

---

**Carlos Henrique Tourinho Santana**  
Mantenedor do Projeto CLT  
[GitHub: @henriquetourinho](https://github.com/henriquetourinho)
