# ExtratorDARF - Versão Desktop PyQt6

## Sobre

Esta é a versão desktop nativa do ExtratorDARF, desenvolvida com PyQt6. A aplicação não requer servidor web ou navegador - é uma aplicação Windows totalmente nativa.

## Diferenças da Versão Web

- **Interface Desktop Nativa**: Não precisa de navegador
- **Sem Dependências Web**: Não precisa de Flask rodando em background
- **Melhor Performance**: Interface mais responsiva
- **Experiência Nativa**: Integração completa com Windows (drag-and-drop, menus, etc.)

## Como Gerar o Executável

Veja `INSTRUCOES_GERAR_EXE.md` para instruções detalhadas.

### Resumo Rápido

```cmd
REM 1. Setup (primeira vez)
setup_exe.bat

REM 2. Gerar executável
build_exe.bat

REM 3. Testar
testar_exe.bat
```

## Estrutura do Projeto

```
.
├── main.py                      # Ponto de entrada PyQt6
├── app/
│   ├── gui/                     # Interface gráfica
│   │   ├── main_window.py       # Janela principal
│   │   ├── upload_widget.py     # Widget de upload
│   │   ├── rules_widget.py      # Widget de regras
│   │   └── widgets.py           # Componentes auxiliares
│   ├── database/
│   │   ├── db_session.py        # SQLAlchemy direto (sem Flask)
│   │   └── direct.py            # Funções de acesso direto
│   ├── models_direct.py         # Modelos SQLAlchemy direto
│   └── services/                # Lógica de negócio (mantida)
├── dist/
│   └── ExtratorDARF.exe         # Executável gerado
└── build_exe.bat                # Script de build
```

## Executar em Desenvolvimento

```cmd
python main.py
```

## Requisitos

- Python 3.11+
- PyQt6 6.6.0+
- Todas as dependências do projeto (ver `pyproject.toml`)

## Notas Técnicas

### Banco de Dados

- Usa SQLAlchemy diretamente (sem Flask-SQLAlchemy)
- Compatível com o banco da versão Flask (mesmo schema)
- Localização: `%APPDATA%\ExtratorDARF\config.db` (executável)
- Localização: `./config.db` (desenvolvimento)

### Modelos OCR

- Incluídos no executável (não precisa baixar na primeira execução)
- Localização no executável: `sys._MEIPASS/ocr_models/`
- Mesmos modelos da versão web

### Compatibilidade

- Mantém compatibilidade com:
  - Formato de Excel gerado
  - Estrutura do banco de dados
  - Lógica de processamento de PDFs
  - Regras de mapeamento

## Troubleshooting

### Problema: "No module named 'app.database.direct'"
**Solução**: Execute `pip install -e .` para instalar o projeto

### Problema: Interface não abre
**Solução**: 
1. Verifique se PyQt6 está instalado: `pip list | findstr PyQt6`
2. Tente executar com console para ver erros (edite `main.py` temporariamente)

### Problema: Erro ao inicializar banco de dados
**Solução**: Verifique permissões de escrita em `%APPDATA%\ExtratorDARF`

