# 🚀 COMECE AQUI - Gerar Executável para Distribuição

## Para Gerar o Executável (Desenvolvedor)

### 1️⃣ Preparar Ambiente (Primeira Vez)

Execute:
```cmd
setup_exe.bat
```

Isso instala todas as dependências e baixa modelos OCR. Pode levar 5-15 minutos.

### 2️⃣ Gerar Executável

Execute:
```cmd
build_exe.bat
```

Isso cria o arquivo `dist\ExtratorDARF.exe`. Pode levar 5-20 minutos.

### 3️⃣ Testar

Execute:
```cmd
testar_exe.bat
```

Ou manualmente:
```cmd
dist\ExtratorDARF.exe
```

## ✅ Pronto para Distribuir!

**O que distribuir:**
- Apenas o arquivo: `dist\ExtratorDARF.exe`
- Tamanho: ~150-300 MB

**O usuário final precisa:**
- Windows 10 ou superior
- Dar duplo clique no arquivo
- **Nada mais!** (não precisa instalar Python, dependências, etc.)

## 📚 Documentação Completa

- **Como gerar**: `INSTRUCOES_GERAR_EXE.md`
- **Como usar (usuário)**: `GUIA_RAPIDO_USUARIO.md`
- **Troubleshooting**: `README_DISTRIBUICAO.md`
- **Detalhes técnicos**: `README_EXE_PYQT6.md`

## ⚠️ Importante

- O executável é **auto-contido** (não precisa de instalações)
- Modelos OCR estão **incluídos** no executável
- Banco de dados é criado automaticamente na primeira execução
- Dados ficam em `%APPDATA%\ExtratorDARF\`

## 🔍 Verificação Rápida

Antes de distribuir, verifique:
- [ ] Executável gerado: `dist\ExtratorDARF.exe`
- [ ] Executável abre corretamente
- [ ] Upload de PDF funciona
- [ ] Processamento funciona
- [ ] Geração de Excel funciona
- [ ] Gerenciamento de regras funciona

## 💡 Dicas

- Teste em um computador limpo antes de distribuir
- O executável pode ser bloqueado pelo Windows Defender (usuário precisa permitir)
- Primeira execução pode demorar alguns segundos
- Processamento de PDFs escaneados é mais lento (normal)

