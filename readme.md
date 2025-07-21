# Projeto Banco de Dados – Clínica de Psicologia

Este repositório contém **todo o material prático** para a disciplina de Banco de Dados: um banco PostgreSQL com esquema completo, população de dados e um pequeno sistema CLI em Python capaz de realizar operações **CRUD** em oito tabelas.

---

## Visão Geral

| Camada        | Tecnologia                      | Descrição                                      |
| ------------- | ------------------------------- | ---------------------------------------------- |
| **Banco**     | PostgreSQL 16 (Docker)          | Contêiner isolado que expõe a porta 5434.      |
| **Dados**     | `sqlClinica.sql`                    | Criação de tabelas + inserts de exemplo.       |
| **Aplicação** | Python 3.11 + `psycopg2-binary` | CLI simples (menu) para CRUD.                  |
| **Inspeção**  | DBeaver / VS Code               | Ferramentas gráficas sugeridas para navegação. |

## Pré‑requisitos

* **Docker Desktop** (ou outro runtime).
* **Python ≥ 3.9** (usa f‑strings, typing moderno).
* Ferramenta de inspeção de banco (opcional): **DBeaver** ou extensão *PostgreSQL* do VS Code.

---

## Passo a Passo

### 1. Clonar o repositório

```bash
git clone https://github.com/<seu-user>/Projeto-BD.git
cd Projeto-BD
```

### 2. Subir o PostgreSQL em Docker

```bash
docker run -d --name ambienteProjetoBD \
  -e POSTGRES_PASSWORD=1230 \
  -p 5434:5432 postgres:16
```

> **Nota:** Altere `1230` se desejar outra senha. A porta externa 5434 pode ser trocada sem impacto (atualize `.env`).

### 3. Criar banco & importar dados

```bash
docker exec -it ambienteProjetoBD psql -U postgres -c "CREATE DATABASE consultorio;"
docker cp script.sql ambienteProjetoBD:/tmp/
docker exec -it ambienteProjetoBD psql -U postgres -d consultorio -f /tmp/script.sql
```

*Ou* importe o `script.sql` pelo DBeaver.

### 4. Configurar variáveis de ambiente

Copie o modelo e ajuste, depois renomeie:

```bash
cp .env.example .env
```

Exemplo mínimo:

```
DB_NAME=consultorio
DB_USER=postgres
DB_PASSWORD=1230
DB_HOST=localhost
DB_PORT=5434
```

### 5. Instalar dependências Python

```bash
python -m venv venv
source venv/bin/activate        # Linux/macOS
venv\Scripts\activate          # Windows
pip install -r requirements.txt
```

### 6. Executar o sistema CLI

```bash
python Scripts/main.py
```

Navegue pelos menus para listar, inserir, atualizar ou remover registros.

---

## Navegação via DBeaver (opcional)

1. **Nova conexão** → PostgreSQL.
2. `Host=localhost`, `Port=5434`, `Database=consultorio`, `User=postgres`, `Password=1230`.
3. Clique **Test** → **Finish**. Agora explore tabelas, visualize dados e rode queries SQL.

---

## Dependências principais

```
psycopg2-binary
python-dotenv
tabulate
```



