# Instruções para Gerar o Executável .exe

## Passo a Passo Completo

### 1. Preparar o Ambiente

Execute o script de setup:
```cmd
setup_exe.bat
```

Este script irá:
- Instalar PyQt6 e todas as dependências necessárias
- Instalar PyInstaller
- Baixar os modelos OCR necessários
- Verificar se tudo está instalado corretamente

**Tempo estimado**: 5-15 minutos (depende da conexão com internet)

### 2. Verificar Pré-requisitos (Opcional)

Antes de gerar o executável, você pode verificar se tudo está pronto:
```cmd
verificar_antes_build.bat
```

### 3. Gerar o Executável

Execute o script de build:
```cmd
build_exe.bat
```

Este script irá:
- Limpar builds anteriores
- Gerar o executável usando PyInstaller
- Incluir todos os módulos e dependências necessárias
- Incluir os modelos OCR no executável

**Tempo estimado**: 5-20 minutos (depende do hardware)

### 4. Testar o Executável

Após gerar, teste o executável:
```cmd
testar_exe.bat
```

Ou execute manualmente:
```cmd
dist\ExtratorDARF.exe
```

## Onde Está o Executável?

O arquivo gerado estará em:
```
dist\ExtratorDARF.exe
```

## Distribuir para Outros Usuários

Para distribuir para usuários leigos:

1. **Copie apenas o arquivo `dist\ExtratorDARF.exe`**
2. Não precisa copiar nenhuma outra dependência
3. O usuário só precisa:
   - Ter Windows 10 ou superior
   - Dar duplo clique no arquivo
   - **Não precisa instalar Python ou nada mais!**

### Tamanho do Executável

O executável gerado terá aproximadamente:
- **150-300 MB** (inclui todas as dependências e modelos OCR)

### Arquivos para Distribuir

**Apenas um arquivo**:
- `ExtratorDARF.exe`

**Documentação opcional** (para ajudar usuários):
- `GUIA_RAPIDO_USUARIO.md` (copie e renomeie para INSTRUCOES.txt)
- `README_DISTRIBUICAO.md`

## Solução de Problemas Comuns

### Erro: "PyInstaller não encontrado"
**Solução**: Execute `setup_exe.bat` primeiro

### Erro: "PyQt6 não instalado"
**Solução**: Execute `setup_exe.bat` primeiro

### Erro: "Modelos OCR não encontrados"
**Solução**: Execute `setup_exe.bat` para baixar os modelos

### Erro durante o build: "Módulo não encontrado"
**Solução**: 
1. Verifique se todas as dependências estão instaladas: `pip install -e .`
2. Se persistir, adicione o módulo faltante em `build_exe.bat` na seção `--hidden-import`

### Executável muito grande (>500 MB)
**Normal**: O executável inclui:
- Python runtime
- PyQt6 e todas as bibliotecas
- Modelos OCR (~30-50 MB)
- Todas as dependências (pandas, numpy, opencv, etc.)

**Para reduzir** (não recomendado):
- Use `--exclude-module` no PyInstaller para remover módulos não usados
- Isso pode quebrar funcionalidades

### Executável não abre no Windows de outro usuário
**Possíveis causas**:
1. Windows Defender bloqueando (solução: usuário precisa permitir)
2. Antivírus bloqueando (solução: adicionar exceção)
3. Arquivo corrompido (solução: gerar novamente)

### Executável abre mas mostra erro
**Verificar**:
1. Execute `dist\ExtratorDARF.exe` no prompt de comando para ver erros
2. Verifique se o banco de dados pode ser criado em `%APPDATA%\ExtratorDARF`
3. Verifique permissões do usuário

## Build Avançado

### Usar arquivo .spec personalizado

Se você quiser mais controle sobre o build, edite `ExtratorDARF.spec` e execute:

```cmd
pyinstaller ExtratorDARF.spec
```

### Adicionar ícone ao executável

1. Crie ou obtenha um arquivo `.ico`
2. Coloque em `icon.ico` na raiz do projeto
3. Edite `ExtratorDARF.spec` e altere:
   ```python
   icon=None,  # para:
   icon='icon.ico',
   ```

### Reduzir tamanho do executável

No `ExtratorDARF.spec`, você pode adicionar mais exclusões:
```python
excludes=[
    'matplotlib',
    'scipy',
    'tkinter',
    'flask',
    # ... outras exclusões
],
```

## Checklist Final Antes de Distribuir

- [ ] Executável gerado com sucesso
- [ ] Testado em um computador limpo (sem Python instalado)
- [ ] Todos os recursos funcionam:
  - [ ] Upload de PDFs
  - [ ] Processamento de PDFs
  - [ ] Geração de Excel
  - [ ] Gerenciamento de regras
- [ ] Documentação incluída (GUIA_RAPIDO_USUARIO.md)
- [ ] Tamanho do executável aceitável (<500 MB)

## Próximos Passos

1. Teste o executável em um ambiente limpo
2. Documente qualquer problema encontrado
3. Distribua apenas o arquivo `.exe` para usuários finais

