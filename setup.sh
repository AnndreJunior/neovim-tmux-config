#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Neovim Tmux Config - Script de instalação
# ============================================================
# Este script instala e configura o Neovim e Tmux com backups
# das configurações existentes.
# ============================================================

# Variáveis globais
DEBUG=false
DRY_RUN=false

DOTFILES_DIR="$HOME/.dotfiles"
REPO_URL="https://github.com/AnndreJunior/neovim-tmux-config"

# ============================================================
# Funções auxiliares
# ============================================================

run_cmd() {
    if [[ "$DRY_RUN" = true ]]; then
        echo "[DRY RUN] $*"
    else
        "$@"
    fi
}

print_step() {
    echo ""
    echo "=========================================="
    echo "  $1"
    echo "=========================================="
}

print_info() {
    echo "  [INFO] $1"
}

print_warn() {
    echo "  [WARN] $1"
}

# ============================================================
# Help
# ============================================================

show_help() {
    cat << EOF
Uso: $(basename "$0") [OPÇÕES]

Script de instalação e configuração do Neovim Tmux Config.

Opções:
  -h, --help       Exibe esta mensagem de ajuda
  -d, --debug      Ativa modo debug com set -x
  -n, --dry-run    Apenas exibe os comandos sem executá-los

Descrição:
  Instala as dependências necessárias (neovim, tmux, git),
  cria backups das configurações existentes e configura
  os symlinks para os dotfiles.

Exemplos:
  $(basename "$0")           Executa a instalação completa
  $(basename "$0") -n        Apenas mostra o que seria feito
  $(basename "$0") -d        Executa em modo debug
EOF
    exit 0
}

# ============================================================
# Parsing de argumentos
# ============================================================

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help | -h)
            show_help
            ;;
        --debug | -d)
            DEBUG=true
            shift
            ;;
        --dry-run | -n)
            DRY_RUN=true
            shift
            ;;
        *)
            echo "Erro: Opção desconhecida: $1"
            echo "Use --help para ver as opções disponíveis."
            exit 1
            ;;
    esac
done

# ============================================================
# Debug mode
# ============================================================

if [[ "$DEBUG" == true ]]; then
    echo ">>> Executando em modo de debug"
    export PS4='+ [LINHA ${LINENO}] '
    set -x
fi

# ============================================================
# Verificar e obter os dotfiles
# ============================================================

print_step "Preparando diretório dos dotfiles"

SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" ]] && [[ -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd 2>/dev/null || true)"
fi

if [[ -z "$SCRIPT_DIR" ]]; then
    # Execução via pipe da web (bash <(curl ...))
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_info "Clonando repositório em $DOTFILES_DIR..."
        run_cmd git clone "$REPO_URL" "$DOTFILES_DIR"
    else
        print_info "Diretório $DOTFILES_DIR já existe. Utilizando-o."
    fi
elif [[ "$SCRIPT_DIR" == "$DOTFILES_DIR" ]]; then
    # Já estamos no diretório correto
    print_info "Executando a partir de $DOTFILES_DIR"
elif [[ -f "$SCRIPT_DIR/setup.sh" && -d "$SCRIPT_DIR/nvim" && -d "$SCRIPT_DIR/tmux" ]]; then
    # Repositório clonado em outro local
    print_info "Repositório detectado em $SCRIPT_DIR"
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_info "Copiando repositório para $DOTFILES_DIR..."
        mkdir -p "$DOTFILES_DIR"
        run_cmd cp -rT "$SCRIPT_DIR" "$DOTFILES_DIR"
    else
        print_warn "$DOTFILES_DIR já existe. Ignorando cópia."
    fi
    if [[ "$DRY_RUN" == false ]]; then
        cd "$DOTFILES_DIR"
    fi
else
    # Local desconhecido
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_info "Clonando repositório em $DOTFILES_DIR..."
        run_cmd git clone "$REPO_URL" "$DOTFILES_DIR"
    else
        print_info "Diretório $DOTFILES_DIR já existe. Utilizando-o."
    fi
    if [[ "$DRY_RUN" == false ]]; then
        cd "$DOTFILES_DIR"
    fi
fi

# ============================================================
# Instalação de dependências
# ============================================================

print_step "Instalando dependências"

DEPENDENCIES=(
    neovim
    tmux
    git
)

for pkg in "${DEPENDENCIES[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        print_info "$pkg já está instalado."
    else
        print_info "Instalando $pkg..."
        run_cmd sudo pacman -S --noconfirm "$pkg"
    fi
done

# ============================================================
# Configuração do Neovim
# ============================================================

print_step "Configurando Neovim"

NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Garantir que o diretório pai existe
if [[ ! -d "$HOME/.config" ]]; then
    print_info "Criando diretório ~/.config..."
    run_cmd mkdir -p "$HOME/.config"
fi

if [[ -L "$NVIM_CONFIG_DIR" ]]; then
    # Já é um symlink
    TARGET="$(readlink "$NVIM_CONFIG_DIR")"
    if [[ "$TARGET" == "$DOTFILES_DIR/nvim" ]]; then
        print_info "Symlink do Neovim já aponta para o local correto."
    else
        print_info "Symlink do Neovim apontando para outro local. Removendo..."
        run_cmd rm "$NVIM_CONFIG_DIR"
        print_info "Criando symlink: $DOTFILES_DIR/nvim -> $NVIM_CONFIG_DIR"
        run_cmd ln -sf "$DOTFILES_DIR/nvim" "$NVIM_CONFIG_DIR"
    fi
elif [[ -d "$NVIM_CONFIG_DIR" ]]; then
    print_info "Fazendo backup da configuração existente do Neovim..."
    run_cmd mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.bak"
    print_info "Criando symlink: $DOTFILES_DIR/nvim -> $NVIM_CONFIG_DIR"
    run_cmd ln -sf "$DOTFILES_DIR/nvim" "$NVIM_CONFIG_DIR"
elif [[ -f "$NVIM_CONFIG_DIR" ]]; then
    print_warn "$NVIM_CONFIG_DIR existe e é um arquivo. Fazendo backup..."
    run_cmd mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.bak"
    print_info "Criando symlink: $DOTFILES_DIR/nvim -> $NVIM_CONFIG_DIR"
    run_cmd ln -sf "$DOTFILES_DIR/nvim" "$NVIM_CONFIG_DIR"
else
    print_info "Criando symlink: $DOTFILES_DIR/nvim -> $NVIM_CONFIG_DIR"
    run_cmd ln -sf "$DOTFILES_DIR/nvim" "$NVIM_CONFIG_DIR"
fi

# ============================================================
# Configuração do Tmux
# ============================================================

print_step "Configurando Tmux"

TMUX_CONF="$HOME/.tmux.conf"

if [[ -L "$TMUX_CONF" ]]; then
    # Já é um symlink
    TARGET="$(readlink "$TMUX_CONF")"
    if [[ "$TARGET" == "$DOTFILES_DIR/tmux/tmux.conf" ]]; then
        print_info "Symlink do Tmux já aponta para o local correto."
    else
        print_info "Symlink do Tmux apontando para outro local. Removendo..."
        run_cmd rm "$TMUX_CONF"
        print_info "Criando symlink: $DOTFILES_DIR/tmux/tmux.conf -> $TMUX_CONF"
        run_cmd ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$TMUX_CONF"
    fi
elif [[ -f "$TMUX_CONF" ]]; then
    print_info "Fazendo backup da configuração existente do Tmux..."
    run_cmd mv "$TMUX_CONF" "${TMUX_CONF}.bak"
    print_info "Criando symlink: $DOTFILES_DIR/tmux/tmux.conf -> $TMUX_CONF"
    run_cmd ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$TMUX_CONF"
else
    print_info "Criando symlink: $DOTFILES_DIR/tmux/tmux.conf -> $TMUX_CONF"
    run_cmd ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$TMUX_CONF"
fi

# ============================================================
# Instalação do TPM (Tmux Plugin Manager)
# ============================================================

print_step "Instalando TPM (Tmux Plugin Manager)"

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    print_info "TPM já está instalado em $TPM_DIR."
else
    print_info "Clonando TPM em $TPM_DIR..."
    run_cmd git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# ============================================================
# Finalização
# ============================================================

print_step "Instalação concluída!"

echo ""
echo "  ✅ Neovim configurado: $DOTFILES_DIR/nvim -> $NVIM_CONFIG_DIR"
echo "  ✅ Tmux configurado:   $DOTFILES_DIR/tmux/tmux.conf -> $TMUX_CONF"
echo "  ✅ TPM instalado em:   $TPM_DIR"
echo ""
echo "  ▶️  Para instalar os plugins do Tmux:"
echo "     Inicie o tmux e pressione <prefix> + I (maiúsculo)"
echo "     (prefix padrão: C-x)"
echo ""
