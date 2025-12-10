# Guia Rápido - ExtratorDARF

## Instalação

**Não precisa instalar nada!** Apenas copie o arquivo `ExtratorDARF.exe` para o seu computador e dê duplo clique para executar.

## Primeira Execução

1. Dê duplo clique no arquivo `ExtratorDARF.exe`
2. Aguarde alguns segundos (primeira vez pode demorar um pouco mais)
3. A janela do programa abrirá automaticamente

## Como Usar

### Processar PDFs de DARF

1. **Selecionar arquivos**:
   - Aba "Processar PDFs"
   - Arraste e solte os arquivos PDF na área indicada
   - OU clique em "Selecionar Arquivos" para escolher
   - Você pode selecionar vários arquivos de uma vez

2. **Processar**:
   - Clique em "Processar PDFs"
   - Escolha onde salvar o arquivo Excel
   - Aguarde o processamento (pode levar alguns minutos)

3. **Resultado**:
   - Um arquivo Excel será gerado com as informações extraídas
   - O arquivo terá 3 abas: servidor, patronal-gilrat e erros

### Gerenciar Regras

1. **Códigos → Abas**:
   - Vá para a aba "Gerenciar Regras" → "Códigos → Abas"
   - Adicione códigos de 4 dígitos e escolha a aba correspondente
   - Exemplo: código "1082" vai para aba "servidor"

2. **CNPJ → UO Contribuinte**:
   - Na mesma aba, vá para "CNPJ → UO Contribuinte"
   - Adicione CNPJs e seus códigos de UO Correspondentes
   - Exemplo: CNPJ "18.715.565/0001-10" tem UO "1071"

## Dicas

- **PDFs escaneados**: Podem demorar mais para processar (usa OCR)
- **Múltiplos arquivos**: Processe vários PDFs de uma vez para economizar tempo
- **Regras**: Configure as regras uma vez e elas serão usadas em todos os processamentos

## Solução de Problemas

### O programa não abre
- Verifique se seu Windows não está bloqueando o arquivo
- Clique com botão direito → Propriedades → Verifique se há botão "Desbloquear"

### Erro ao processar
- Verifique se os arquivos são PDFs válidos
- Tente processar um arquivo por vez primeiro
- Verifique se há espaço no disco

### Processamento lento
- É normal para PDFs escaneados (OCR leva tempo)
- PDFs com texto nativo são mais rápidos

## Onde ficam os dados?

- **Regras configuradas**: `C:\Users\[SeuUsuário]\AppData\Roaming\ExtratorDARF\config.db`
- **Arquivos Excel gerados**: Onde você escolher ao salvar (geralmente Downloads)

## Precisa de Ajuda?

Entre em contato com o suporte técnico.

