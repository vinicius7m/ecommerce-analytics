# 🛒 Analytics Commerce – Dashboard de Vendas

![Badge de Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)
![Badge de Licença](https://img.shields.io/badge/license-MIT-blue)

## 📌 **Sobre o Projeto**

O **Analytics Commerce** é um projeto de **análise de vendas** desenvolvido para **portfólio profissional**, com foco em **modelagem dimensional**, **SQL** e **visualização de dados com Power BI**.

Ele simula um ambiente real de e-commerce, onde são aplicadas práticas de **limpeza e pré-processamento de dados**, **modelagem em estrela** e **criação de KPIs estratégicos** para suporte à **tomada de decisão**.

Este projeto é voltado para demonstrar habilidades em:
✅ **Engenharia e tratamento de dados (SQL/PostgreSQL)**
✅ **Modelagem dimensional para BI**
✅ **Storytelling com dados e boas práticas visuais**
✅ **Geração de insights para negócios (Vendas e E-commerce)**

---

## 🏗 **Arquitetura e Fluxo de Dados**

```
Banco Relacional  -->  Pré-processamento e Views SQL  -->  Modelo Dimensional (Star Schema)  -->  Power BI
```

* **Banco Relacional:** tabelas transacionais (`clientes`, `produtos`, `vendedores`, `vendas`, `itens_venda`, `comissoes`).
* **Pré-processamento:** limpeza e padronização com **views SQL** (`dim_clientes`, `dim_vendedores`, `dim_produtos`, `dim_tempo`, `fato_vendas`).
* **Modelo Dimensional:** estrutura em estrela para facilitar análises.
* **Visualização:** dashboard no **Power BI** com KPIs e insights.

---

## 📊 **Principais KPIs e Métricas**

* **Faturamento Total**
* **Ticket Médio por Cliente**
* **Margem e Impostos**
* **Giro de Produtos e Produtos mais Vendidos**
* **Tempo Médio de Entrega**
* **Crescimento Mensal de Vendas**
* **Taxa de Devoluções**

### **Principais Perguntas Respondidas pelo Dashboard**

✔ Quais produtos geram maior faturamento?
✔ Qual vendedor possui melhor desempenho em receita?
✔ Como está a evolução de vendas mês a mês?
✔ Quais canais de venda são mais rentáveis?

---

## 💻 **Tecnologias Utilizadas**

| Categoria              | Ferramentas                                                    |
| ---------------------- | -------------------------------------------------------------- |
| **Banco de Dados**     | PostgreSQL                                                     |
| **Linguagem SQL**      | Queries e Views para pré-processamento e modelagem dimensional |
| **Visualização**       | Power BI                                                       |
| **Modelagem**          | Esquema em estrela (Star Schema)                               |
| **Controle de Versão** | Git & GitHub                                                   |

---

## 🚀 **Como Executar o Projeto**

### **1. Clonar o Repositório**

```bash
git clone https://github.com/vinicius7m/ecommerce-analytics.git
cd ecommerce-analytics
```

### **2. Criar Banco e Executar Scripts**

* Crie um banco PostgreSQL.
* Rode os scripts de criação e inserção de dados localizados em `/sql`.
* Rode o script das **views dimensionais** (`views_dimensao_fato.sql`).

### **3. Conectar ao Power BI**

* Abra o arquivo `dashboard_analytics_commerce.pbix` e conecte ao banco PostgreSQL.

---

## 🖼 **Preview do Dashboard**

---

## 🧠 **Conceitos Aplicados**

* **Pré-processamento de Dados:** limpeza de ruídos, padronização de textos e validação de domínios, seguindo práticas do livro *Introdução à Mineração de Dados*.
* **Modelagem Dimensional:** criação de dimensões e fato para análises rápidas e consistentes.
* **Data Storytelling:** organização visual do dashboard pensando em diferentes perfis de usuários (gestores e analistas).

---

## 📈 **Próximos Passos e Melhorias**

* Inclusão de novas dimensões (ex.: promoções e devoluções detalhadas).
* Aplicação de detecção de outliers em valores de vendas.

---

## 👨‍💻 **Autor**

**Vinícius Moreira**
Analista de Dados
[LinkedIn](https://www.linkedin.com/in/vinicius-moreira-77) | [GitHub](https://github.com/vinicius7m)

---

## 📄 **Licença**

Este projeto está sob a licença MIT – veja o arquivo [LICENSE](LICENSE) para mais detalhes.