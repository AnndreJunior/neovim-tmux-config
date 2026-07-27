# Neovim Tmux Config

Este projeto contém minhas configurações pessoais do **Neovim** e **Tmux**, junto com um script automatizado para instalação e configuração em sistemas **Arch Linux**.

## ✨ O que está incluído

- **`setup.sh`** — Script de instalação automatizada que configura todo o ambiente
- **`nvim/`** — Configuração completa do Neovim
- **`tmux/`** — Configuração do Tmux

## 📋 Requisitos

- Arch Linux (ou distribuições baseadas como CachyOs)
- `bash`
- `git`
- `curl`

## 🚀 Instalação

### Via clone do repositório

```bash
git clone https://github.com/AnndreJunior/neovim-tmux-config ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

### Via instalação direta pela web

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/AnndreJunior/neovim-tmux-config/main/setup.sh)
```

### O que o script faz

O script `setup.sh` irá:

1. Instalar os pacotes necessários
2. Criar backups das configurações existentes (com sufixo `.bak`)
3. Criar os seguintes symlinks:

| Origem                       | Destino          |
| ---------------------------- | ---------------- |
| `~/.dotfiles/nvim`           | `~/.config/nvim` |
| `~/.dotfiles/tmux/tmux.conf` | `~/.tmux.conf`   |

## ⚙️ Opções

O script aceita as seguintes flags:

| Flag              | Descrição                                |
| ----------------- | ---------------------------------------- |
| `--dry-run`, `-n` | Apenas exibe os comandos sem executá-los |
| `--debug`, `-d`   | Ativa o modo debug com `set -x`          |
| `--help`, `-h`    | Exibe a ajuda                            |

**Exemplos:**

```bash
# Visualizar o que seria feito sem executar
./setup.sh --dry-run

# Executar em modo debug
./setup.sh --debug
```

## 🐳 Testando com Docker

Para testar o script em um ambiente isolado sem afetar sua máquina, utilize o Docker Compose:

```bash
docker compose run --rm arch
```

Isso irá iniciar um container com Arch Linux no diretório `/app` com o código do projeto montado via volume, pronto para executar `./setup.sh`.
