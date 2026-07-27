# Neovim Tmux Config - Guia para IA

Esse documento fornece uma guia para modelos de ia trabalharem no Neovim Tmux Config

## Overview

Este projeto consiste em um conjunto de dotfiles/configurações pessoais do neovim e tmux junto de um script para automatizar a instalação e configuração.

## Estrutura

- `setup.sh`: contém todo o script de instalação
- `nvim/`: contém toda a configuração do neovim
- `tmux/`: contém toda a configuração do tmux

## Stack & Compatibilidade

- **Linguagem:** Bash script
- **Sistemas suportados:** Arch Linux

## Comportamento

- O script DEVE começar com set -euo pipefail
- Usar SEMPRE `run_cmd` para executar comandos, nunca chamar comandos diretamente (exceto `echo`)

- Verificar se o recurso, pacote ou diretório existe antes de instalar ou configurar
- Imprimir mensagem clara de início e fim de etapa
- Se uma pasta de configuração já existir (ex: `~/.config/nvim`), criar um backup `*.bak` antes de criar o link simbólico
- Permitir execução em _Dry Run_ e _Debug_

## Variáveis globais

Variáveis globals que devem ficar no topo do script:

- DEBUG (valor inicial `false`)
- DRY_RUN (valor inicial `false`)

## Flags

O script aceita estas flags via argumentos:

| Flag              | Descrição                          |
| ----------------- | ---------------------------------- |
| `--dry-run`, `-n` | Apenas exibe comandos sem executar |
| `--debug`, `-d`   | Ativa modo debug com `set -x`      |
| `--help`, `-h`    | Exibe ajuda                        |

## Implementação padrão

### Dry run

```bash
run_cmd() {
    if [[ "$DRY_RUN" = true ]]; then
        echo "[DRY RUN] $*"
    else
        "$@"
    fi
}
```

### Debug

```bash
if [[ "$DEBUG" == true ]]; then
  echo ">>> Executando em modo de debug"
  export PS4='+ [LINHA ${LINENO}] '
  set -x
fi
```

## Instalação e Links Simbólicos

- Todos os dotfiles devem ser armazenados em `$HOME/.dotfiles`
- Caso executado diretamente da web, o script deve clonar o repositório em `$HOME/.dotfiles`:
  `git clone https://github.com/AnndreJunior/neovim-tmux-config "$HOME/.dotfiles"`
- Symlinks esperados:
  - `$HOME/.dotfiles/nvim` -> `$HOME/.config/nvim`
  - `$HOME/.dotfiles/tmux` -> `$HOME/.tmux.conf`

## Ambiente de Testes (Docker)

Para garantir que o script funcione em um ambiente limpo e isolado sem afetar a máquina host, o projeto conta com um ambiente de testes via **Docker Compose**

O container sobe no diretório `/app` com o código do projeto montado via volume e pronto para executar `./setup.sh`

O container instala os pacotes:

- bash
- curl
- git
- sudo

### Estrutura de Testes

```text
.
├── docker-compose.yml
└── Dockerfile
```

### Como Executar os Testes

Para abrir um terminal interativo dentro do container da distro desejada e testar a execução do `setup.sh`:

```bash
docker compose run --rm arch
```
