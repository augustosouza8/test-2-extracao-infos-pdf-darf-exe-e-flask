# Lições aprendidas 

"Com PyInstaller é possível gerar arquivos .exe que posteriormente podem ser repassados para máquinas de usuários leigos; a primeira opção é usá-lo para criar um .exe que força a abertura do navegador do usuário, desta forma ele "simula" vc rodar o código de python numa IDE e abrir o app Flask localmente no navegador do usuário; a segunda opção seria utilizar o PyInstaller com o PyWebview, este basicamente simula um navegador web em uma janela própria, "escondendo a barra de endereços, botões de voltar ou favoritos, parece um aplicativo nativo". Já a combinação do PyInstaller com PyQt6 permite você tanto simular um navegador web com cara de aplicativo (mas nesse caso vc utiliza a biblioteca Qt WebEngine para renderizar o Flask ao invês do PyWebview), quanto criar um aplicativo nativo de windows, semelhante a biblioteca Tkinter, mas com mais possibilidades"


# Resumo: Estratégias para Converter Web App (Flask) em Executável (.exe)

O objetivo principal é utilizar o **PyInstaller** para empacotar a aplicação Python e suas dependências. Isso gera arquivos `.exe` (standalone) que permitem a distribuição para usuários leigos sem necessidade de instalação de Python, Docker ou acesso à nuvem.

Abaixo, as três abordagens discutidas para a interface do usuário:

### 1. PyInstaller + Navegador Padrão (A abordagem simples)
Neste modelo, o `.exe` atua como um servidor local silencioso. Ao ser executado, ele inicia o backend Flask e força a abertura automática do navegador padrão do usuário (Chrome, Edge, etc.) na URL local.
* **Experiência:** Simula o comportamento de desenvolvimento (rodar o script e abrir o browser), mas empacotado.
* **Vantagem:** Simplicidade máxima e tamanho de arquivo reduzido.
* **Desvantagem:** O usuário percebe que está em um site e a gestão do fechamento do app é menos intuitiva.

### 2. PyInstaller + PyWebview (A abordagem recomendada)
Esta opção utiliza a biblioteca **PyWebview** para criar uma janela nativa do sistema operacional que "encapsula" o site.
* **Experiência:** Simula um aplicativo nativo, escondendo elementos de navegador como barra de endereços, botões de voltar ou favoritos.
* **Vantagem:** Oferece uma experiência de software desktop profissional com baixo custo de performance e tamanho, pois utiliza o motor de renderização já existente no Windows (WebView2).
* **Destaque:** É o melhor equilíbrio entre esforço de desenvolvimento e resultado visual.

### 3. PyInstaller + PyQt6 (A abordagem robusta)
O PyQt6 é um framework completo para interfaces gráficas. Ele pode ser usado de duas formas:
* **Modo Wrapper (QtWebEngine):** Similar ao PyWebview, usa o componente de navegador do Qt para renderizar o Flask. Porém, traz um motor de navegador próprio embutido, o que aumenta significativamente o tamanho do arquivo final, mas garante consistência total de renderização.
* **Modo Nativo (Reescrita):** Permite criar interfaces 100% nativas (janelas, botões e tabelas do sistema), similar ao Tkinter, mas com visual e recursos muito superiores. Exige reescrever o front-end, abandonando o HTML/CSS.

---
**Notas Técnicas Importantes para o Build:**
* **Persistência (SQLite):** É necessário configurar o caminho do banco de dados para uma pasta fixa do usuário (ex: `%APPDATA%`), evitando que os dados sejam apagados ao fechar o `.exe` (que roda em pasta temporária).
* **OCR Offline:** Para bibliotecas como RapidOCR, os modelos `.onnx` devem ser baixados previamente e incluídos dentro do executável para garantir funcionamento offline.


# Extrator de Informações DARF

Aplicação Flask para extrair informações de PDFs de DARF e gerar arquivos Excel consolidados.

## Estrutura do Projeto

```
.
├── app/                    # Aplicação Flask
│   ├── static/            # Arquivos estáticos (CSS, JS, imagens)
│   ├── templates/         # Templates HTML
│   ├── routes/            # Rotas da aplicação
│   ├── services/          # Serviços (geração de Excel)
│   ├── utils/             # Utilitários (formatters, validators, errors)
│   ├── models.py          # Modelos SQLAlchemy
│   └── config.py          # Configurações
├── migrations/             # Migrations do banco de dados (Flask-Migrate)
├── wsgi.py                # Ponto de entrada WSGI
├── config_db.py           # Gerenciamento do banco de dados
├── parse_darf.py          # Processamento de PDFs
└── requirements.txt       # Dependências Python
```

## Configuração Local

1. Instale as dependências:
   ```bash
   uv sync
   # ou
   pip install -r requirements.txt
   ```

2. Copie o `.env.example` para `.env` e defina:
   - `FLASK_SECRET_KEY`: qualquer valor secreto aleatório (não compartilhe).
   - `MS_CLIENT_ID`, `MS_CLIENT_SECRET`, `MS_TENANT_ID`: dados do aplicativo configurado no Microsoft Entra ID.
   - `DATABASE_URL`: (opcional) URL do PostgreSQL. Se não definido, usa SQLite local (`config.db`).

3. No portal do Entra ID configure o Redirect URI para `http://localhost:5000/auth/redirect`. O app Flask usa exatamente esse valor internamente (`REDIRECT_URI`), então ele precisa coincidir.

4. Inicialize o banco de dados:
   ```bash
   flask db upgrade
   flask init-db
   ```

## Execução Local

1. Exporte as variáveis do `.env` (caso sua ferramenta não faça isso automaticamente). Com `python-dotenv`, basta manter o arquivo na raiz.

2. Rode o servidor de desenvolvimento:
   ```bash
   uv run flask --app wsgi run --host 0.0.0.0 --port 5000
   # ou
   python wsgi.py
   ```

3. Acesse `http://localhost:5000/`. A autenticação Microsoft redirecionará para `http://localhost:5000/auth/redirect`, evitando erros AADSTS900971.

## Deploy na Azure

### Pré-requisitos

- Conta Azure com Azure App Service configurado
- Azure Database for PostgreSQL (ou outro banco PostgreSQL)
- Aplicativo registrado no Microsoft Entra ID

### Variáveis de Ambiente na Azure

Configure as seguintes variáveis de ambiente no Azure App Service:

1. **FLASK_SECRET_KEY**: Chave secreta para sessões Flask (gerar valor aleatório seguro)
2. **DATABASE_URL**: URL de conexão do PostgreSQL no formato:
   ```
   postgresql://usuario:senha@servidor:porta/nome_banco
   ```
   Nota: Se a Azure fornecer `postgres://`, será automaticamente convertido para `postgresql://`.

3. **MS_CLIENT_ID**: ID do aplicativo no Microsoft Entra ID
4. **MS_CLIENT_SECRET**: Secret do aplicativo no Microsoft Entra ID
5. **MS_TENANT_ID**: ID do tenant do Microsoft Entra ID

### Configuração do Microsoft Entra ID

No portal do Microsoft Entra ID, configure o Redirect URI para:
```
https://seu-app.azurewebsites.net/auth/redirect
```

### Deploy via Docker

O projeto inclui um `Dockerfile` otimizado para Azure:

```bash
# Build da imagem
docker build -t extracao-darf .

# Teste local
docker run -p 5000:5000 -e FLASK_SECRET_KEY=test extracao-darf

# Push para Azure Container Registry (exemplo)
az acr build --registry seu-registry --image extracao-darf:latest .
```

### Deploy via Git

1. Configure o Azure App Service para fazer deploy do repositório Git
2. O Azure executará automaticamente o build baseado no `Dockerfile`
3. Após o deploy, execute as migrations:
   ```bash
   az webapp ssh --name seu-app --resource-group seu-resource-group
   flask db upgrade
   flask init-db
   ```

### Migrations do Banco de Dados

O projeto usa Flask-Migrate para gerenciar mudanças no schema do banco:

```bash
# Criar nova migration
flask db migrate -m "Descrição da mudança"

# Aplicar migrations
flask db upgrade

# Reverter última migration
flask db downgrade
```

**Importante**: Após o primeiro deploy na Azure, execute:
```bash
flask db upgrade  # Cria as tabelas
flask init-db    # Popula dados padrão
```

### Comandos Úteis

- `flask init-db`: Inicializa o banco e popula com dados padrão
- `flask db upgrade`: Aplica todas as migrations pendentes
- `flask db migrate -m "mensagem"`: Cria nova migration baseada em mudanças nos modelos

## Observações

- Os PDFs enviados são processados por `parse_darf.py` e geram um Excel consolidado baixado via navegador.
- Garanta que o `.env` não seja versionado (já está contemplado no `.gitignore`).
- O banco de dados local (SQLite) é usado apenas para desenvolvimento. Em produção, use PostgreSQL.

## Suporte a PDFs Escaneados (OCR)

O sistema suporta tanto PDFs com texto nativo quanto PDFs escaneados (imagens):

- **PDFs com texto nativo**: O texto é extraído diretamente usando `pdfplumber`, que é rápido e preciso.
- **PDFs escaneados**: Quando o texto extraído é insuficiente (< 100 caracteres), o sistema usa automaticamente OCR (Reconhecimento Óptico de Caracteres) com `RapidOCR-onnxruntime` para extrair o texto das imagens.

O processamento com OCR é mais lento que a extração de texto nativo, mas permite processar documentos escaneados. O `RapidOCR-onnxruntime` é mais rápido que o PaddleOCR (4-5x) e não requer binários externos, funcionando apenas com `pip install`. Os modelos são baixados automaticamente na primeira execução.

## Tecnologias Utilizadas

- **Flask**: Framework web
- **Flask-SQLAlchemy**: ORM para banco de dados
- **Flask-Migrate**: Gerenciamento de migrations
- **PostgreSQL/SQLite**: Banco de dados
- **pdfplumber**: Extração de texto de PDFs
- **RapidOCR-onnxruntime**: OCR para PDFs escaneados
- **pandas/openpyxl**: Geração de arquivos Excel
- **MSAL**: Autenticação Microsoft
