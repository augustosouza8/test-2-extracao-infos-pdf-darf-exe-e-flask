# Onde o arquivo resultado_darfs.xlsx é salvo?

## Comportamento Atual

### Quando roda como executável (.exe):
O arquivo é salvo em **duas localizações**:

1. **Pasta Downloads do usuário** (prioridade):
   - `C:\Users\[SEU_USUARIO]\Downloads\resultado_darfs_YYYYMMDD_HHMMSS.xlsx`
   - Exemplo: `C:\Users\João\Downloads\resultado_darfs_20250112_143022.xlsx`

2. **Pasta APPDATA** (fallback se Downloads não existir):
   - `C:\Users\[SEU_USUARIO]\AppData\Roaming\ExtratorDARF\resultado_darfs_YYYYMMDD_HHMMSS.xlsx`

### Quando roda em desenvolvimento (Flask normal):
O arquivo é salvo em uma **pasta temporária** e enviado para download via navegador.

## Por que isso foi implementado?

No PyWebView, o download automático pode não funcionar como no navegador normal. Para garantir que o usuário sempre tenha acesso ao arquivo, ele é salvo diretamente em uma pasta acessível.

## Timestamp no nome

O arquivo inclui um timestamp (data e hora) no nome para evitar sobrescrever arquivos anteriores:
- `resultado_darfs_20250112_143022.xlsx`

## Mensagem para o usuário

Quando o arquivo é gerado no executável, uma mensagem aparece na interface informando onde o arquivo foi salvo:
- "Arquivo salvo em: C:\Users\[USUARIO]\Downloads\resultado_darfs_YYYYMMDD_HHMMSS.xlsx"

## Como encontrar o arquivo

1. **Abra o Explorador de Arquivos**
2. **Vá para a pasta Downloads** (ou `%APPDATA%\ExtratorDARF`)
3. **Procure por arquivos** que começam com `resultado_darfs_`
4. **Ordene por data** para encontrar o mais recente

## Melhorias Futuras

Possíveis melhorias:
- Adicionar botão na interface para abrir a pasta onde o arquivo foi salvo
- Permitir escolher onde salvar o arquivo
- Mostrar notificação do Windows quando o arquivo for salvo

