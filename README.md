# Dotfiles

Configuración personal de shell (bash/zsh) y tmux gestionada con un bare Git repository.

## Archivos Incluidos

- `.bashrc` - Configuración de Bash shell
- `.zshrc` - Configuración de Zsh shell (Oh My Zsh)
- `.tmux.conf` - Configuración de tmux

## Cómo se Generó Este Repositorio

### 1. Creación del Bare Repository

```bash
# Crear bare repository en ~/projects/dotfiles
git init --bare ~/projects/dotfiles

# Configurar alias para gestionar dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/projects/dotfiles/ --work-tree=$HOME'

# Ocultar archivos sin seguimiento para evitar ruido
dotfiles config --local status.showUntrackedFiles no
```

### 2. Añadir Alias a Shells

Se añadió el alias `dotfiles` al final de `.bashrc` y `.zshrc`:

```bash
# Dotfiles bare repository alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/projects/dotfiles/ --work-tree=$HOME'
```

### 3. Añadir Archivos de Configuración

```bash
# Añadir archivos al repositorio
dotfiles add ~/.bashrc
dotfiles add ~/.zshrc
dotfiles add ~/.tmux.conf
dotfiles add ~/README.md

# Crear commit inicial
dotfiles commit -m "Initial dotfiles: bashrc, zshrc, tmux.conf"
```

### 4. Conectar a GitHub (Opcional)

```bash
# Crear repo en GitHub primero, luego:
dotfiles remote add origin https://github.com/TU-USUARIO/dotfiles.git
dotfiles branch -M main
dotfiles push -u origin main
```

## Cómo Restaurar en una Nueva Máquina

### Paso 1: Clonar el Bare Repository

```bash
# Clonar el repositorio bare
git clone --bare https://github.com/TU-USUARIO/dotfiles.git ~/projects/dotfiles

# Crear el alias temporalmente
alias dotfiles='/usr/bin/git --git-dir=$HOME/projects/dotfiles/ --work-tree=$HOME'

# Configurar para ocultar archivos sin seguimiento
dotfiles config --local status.showUntrackedFiles no
```

### Paso 2: Hacer Backup de Archivos Existentes (Opcional)

```bash
# Crear directorio de backup
mkdir -p ~/.dotfiles-backup

# Hacer checkout y resolver conflictos
dotfiles checkout 2>&1 | egrep "\s+\." | awk '{print $1}' | xargs -I{} mv {} ~/.dotfiles-backup/{}
```

### Paso 3: Aplicar Configuración

```bash
# Hacer checkout de los dotfiles
dotfiles checkout

# Recargar la configuración del shell
source ~/.bashrc  # o source ~/.zshrc
```

¡Listo! El alias `dotfiles` ahora está disponible permanentemente.

## Uso Diario

```bash
# Ver estado
dotfiles status

# Añadir cambios a archivos existentes
dotfiles add ~/.bashrc

# Añadir nuevos archivos
dotfiles add ~/.gitconfig

# Hacer commit
dotfiles commit -m "Update bashrc aliases"

# Push a GitHub
dotfiles push

# Pull cambios
dotfiles pull

# Ver historial
dotfiles log --oneline

# Ver diferencias
dotfiles diff
```

## Ventajas de Este Método

- **Sin symlinks**: Los archivos están en sus ubicaciones nativas
- **Sin carpetas especiales**: Todo funciona desde `$HOME`
- **Control total**: Usa comandos Git estándar con el alias `dotfiles`
- **Limpio**: No muestra archivos sin seguimiento del sistema

## Añadir Más Archivos

Para versionar archivos adicionales:

```bash
# Ejemplos de archivos comunes
dotfiles add ~/.gitconfig       # Configuración de Git
dotfiles add ~/.vimrc           # Configuración de Vim
dotfiles add ~/.config/nvim     # Neovim config (directorio completo)
dotfiles add ~/.ssh/config      # SSH config (¡sin claves privadas!)
dotfiles commit -m "Add new config files"
dotfiles push
```

## Notas de Seguridad

⚠️ **NUNCA versionar:**
- Claves privadas SSH (`~/.ssh/id_*` sin extensión `.pub`)
- Tokens de API o credenciales en variables de entorno
- Archivos `.env` con secretos
- Historial de shell (`.bash_history`, `.zsh_history`)

## Referencias

- [Bare Git Repository Method](https://www.atlassian.com/git/tutorials/dotfiles)
- Creado: 2025-12-31
