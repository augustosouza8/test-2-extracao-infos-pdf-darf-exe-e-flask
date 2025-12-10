# Guia de Distribuição do ExtratorDARF.exe

## Para Desenvolvedores - Gerar o Executável

### Pré-requisitos

1. Python 3.11 ou superior instalado
2. Windows 10 ou superior
3. Conexão com internet (para baixar modelos OCR)

### Passo a Passo

1. **Execute o setup**:
   ```cmd
   setup_exe.bat
   ```
   Isso irá:
   - Instalar todas as dependências (PyQt6, PyInstaller, etc.)
   - Baixar os modelos OCR necessários

2. **Gere o executável**:
   ```cmd
   build_exe.bat
   ```
   Isso irá criar o arquivo `dist\ExtratorDARF.exe`

3. **Teste o executável**:
   ```cmd
   dist\ExtratorDARF.exe
   ```

### Arquivos Necessários para Distribuição

Para distribuir para outros usuários, você precisa apenas de:

- **`ExtratorDARF.exe`** (arquivo único, está em `dist\`)
- Não precisa instalar Python ou outras dependências!
- Não precisa de internet (modelos OCR estão incluídos)

## Para Usuários Finais - Como Usar

### Requisitos do Sistema

- Windows 10 ou superior (64-bit)
- Aproximadamente 200 MB de espaço em disco
- **NÃO precisa instalar Python ou qualquer dependência**

### Primeira Execução

1. Copie o arquivo `ExtratorDARF.exe` para qualquer pasta no seu computador
2. Dê um duplo clique no arquivo para executar
3. Na primeira execução, o programa pode demorar alguns segundos para abrir (está criando o banco de dados)

### Como Usar

1. **Processar PDFs**:
   - Na aba "Processar PDFs", arraste e solte arquivos PDF ou clique em "Selecionar Arquivos"
   - Clique em "Processar PDFs"
   - Escolha onde salvar o arquivo Excel gerado
   - Aguarde o processamento (pode levar alguns minutos dependendo do número de arquivos)

2. **Gerenciar Regras**:
   - Na aba "Gerenciar Regras", você pode:
     - Adicionar códigos → abas (servidor/patronal-gilrat)
     - Adicionar CNPJ → UO Contribuinte
     - Remover regras existentes

### Onde os Dados são Salvos

- **Banco de dados**: `%APPDATA%\ExtratorDARF\config.db`
  - Contém as regras de mapeamento que você configura
- **Arquivos Excel**: Onde você escolher ao processar (geralmente Downloads)

### Solução de Problemas

**O programa não abre:**
- Verifique se o Windows não está bloqueando (clique com botão direito → Propriedades → Desbloquear)
- Verifique se você tem permissões de administrador (normalmente não é necessário)
- Tente executar como administrador se o problema persistir

**Erro ao processar PDFs:**
- Verifique se os arquivos são PDFs válidos
- Tente processar um arquivo por vez primeiro
- Verifique se há espaço suficiente no disco

**O programa está lento:**
- Processar PDFs escaneados (OCR) pode levar vários minutos por arquivo
- Isso é normal e esperado

**Perdi minhas regras:**
- As regras estão no banco de dados em `%APPDATA%\ExtratorDARF\config.db`
- Faça backup deste arquivo se necessário
- Se o arquivo for corrompido, o programa criará um novo na próxima execução

### Segurança

O executável é auto-contido e não requer instalação de dependências externas. 
- Não modifica o registro do Windows
- Não requer privilégios de administrador
- Todos os dados ficam locais no computador do usuário

### Suporte

Para problemas técnicos ou dúvidas, entre em contato com o desenvolvedor.

