# HatDots Windows

<!-- TODO: Add screenshot Neovim setup -->

**Una configuración moderna de Neovim para Windows** que combina LazyVim con ajustes personales para máxima productividad en desarrollo Windows.

## ¿Qué hace especial a esta configuración?

- **Optimizada para Windows**: Clipboard, shell y paths configurados nativamente
- **Diseño limpio**: Tema Kanagawa con transparencias y colores consistentes
- **Zero-config debugging**: Soporte Python, Node.js, Rust listo para usar
- **Claude Code integrado**: IA directamente en tu editor
- **Obsidian**: Notas y conocimiento interconectado
- **Rendimiento**: Lazy loading y configuraciones eficientes

## Instalación

```powershell
# 1. Clonar el repositorio
git clone https://github.com/hat-y/HatDotsWindows.git $HOME\HatDotsWindows

# 2. Ejecutar instalación automática
cd $HOME\HatDotsWindows
.\install.ps1

# 3. Reiniciar PowerShell/WezTerm y ¡listo!
```

> **Nota**: El script maneja todo: crea symlinks, instala dependencias y configura el entorno. Solo requiere permisos de administrador para los symlinks.

## Requisitos Previos

### Herramientas

```powershell
# Git y herramientas base
winget install -e --id Git.Git              # Control de versiones
winget install -e --id Neovim.Neovim        # El editor
winget install -e --id WezTerm.WezTerm      # Terminal moderna
winget install -e --id Starship.Starship    # Prompt personalizado

# Búsqueda y navegación
winget install -e --id BurntSushi.ripgrep.MSVC    # Búsqueda en archivos
winget install -e --id sharkdp.fd                 # Búsqueda de archivos
```

### Para Desarrollo Full-Stack

```powershell
# Herramientas de desarrollo
winget install -e --id JesseDuffield.lazygit    # Git UI/CLI
winget install -e --id BrechtSanders.WinLibs.POSIX.UCRT  # Runtime POSIX para herramientas de línea de comandos
winget install -e --id Zig.Zig                  # Compilador (algunos plugins lo necesitan)
winget install -e --id LLVM.LLVM                # Toolchain C++
winget install -e --id eza-community.eza        # ls mejorado
winget install -e --id Microsoft.tree-sitter-cli  # Tree-sitter CLI para análisis de sintaxis
```

### Para Python Development

```powershell
# Python y debugging
python -m pip install --upgrade pip
python -m pip install debugpy                    # Para nvim-dap
```

## Configuración Post-Instalación

### Neovim

```vim
" 1. Abrir Neovim
nvim

" 2. Esperar instalación automática de plugins
" 3. Verificar instalación
:Laz

y check      # Revisa estado de plugins
:Mason           # Instala/actualiza LSPs
:checkhealth     # Verifica que todo esté bien
```

### PowerShell Profile

El script `install.ps1` crea un symlink al `Microsoft.PowerShell_profile.ps1` en tu directorio `Documents\PowerShell`.

El profile configura:
- **PSReadLine**: Historial, autocompletado, navegación por flechas
- **Starship**: Prompt personalizado
- **Zoxide**: `cd` inteligente con auto-sugerencias
- **Aliases**: `vim=nvim`, `g=git`, `nv=nvim`
- **Listados mejorados**: `ll`, `la` con eza si está disponible

Para recargar el profile:
```powershell
.\$PROFILE
```

### API Keys (Opcional)

```powershell
# Claude Code para asistencia IA
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "tu-clave-api", "User")
```

> **¿Dónde obtener las keys?**: Claude AI → https://console.anthropic.com/

## Características

### PowerShell Profile

El script `install.ps1` configura el perfil automáticamente:
- **PSReadLine**: Historial, autocompletado y navegación
- **Starship**: Prompt personalizado
- **Zoxide**: `cd` inteligente con auto-sugerencias
- **Aliases**: `vim=nvim`, `g=git`, `nv=nvim`
- **Listados mejorados**: `ll`, `la` con eza si está disponible

Para recargar el perfil:
```powershell
.\$PROFILE
```

### Neovim Config

**Base LazyVim + Extras:**

- **TypeScript**: Completión, refactoring, debugging
- **Python**: LSP, formatting, testing, debugging
- **Rust**: Racer, rust-analyzer, debugging

**Plugins Personalizados:**

- **Claude Code**: `leader>a` para abrir IA en el editor
- **Oil.nvim**: Navegación de archivos tipo VSCode
- **Telescope**: Búsqueda con fzf, live grep args
- **Kanagawa**: Tema Dragon con transparencias
- **Obsidian**: Zettelkasten y notas interconectadas
- **Debugging**: Python, Node.js, Rust con nvim-dap

### UI/UX

- **Temas consistentes**: Kanagawa + WezTerm coordinados
- **Transparencias**: Se ve el fondo de tu terminal
- **Icons**: nvim-web-devicons en everywhere
- **Statusline**: LazyVim + indicadores personalizados

### Optimizaciones Windows

- **Clipboard**: win32yank + PowerShell fallback
- **Shell**: PowerShell 7 configurado correctamente
- **Paths**: Manejo de rutas Windows nativo
- **Performance**: Lazy loading y shada optimizado

## Atajos Importantes

### Navegación y Archivos

```
-                # Abrir Oil (navegador de archivos)
<C-w>h/j/k/l      # Navegar ventanas (estándar Vim)
<leader>ff       # Buscar archivos (Telescope)
<leader>fg       # Buscar en contenido
<leader>fb       # Buffer switcher
```

### Desarrollo

```
<leader>lf       # Formatear código
<leader>la       # Code actions (fix imports, etc)
<leader>lr       # Renombrar variable
<leader>ld       # Ver diagnósticos/error
```

### Debugging (F-keys como VSCode)

```
<F5>             # Continuar debugging
<F9>             # Toggle breakpoint
<F10>            # Step over
<F11>            # Step into
<leader>du       # Toggle debugging UI
```

### Claude Code IA

```
<leader>ac       # Abrir Claude en panel
<leader>ar       # Reanudar conversación
<leader>aa       # Continuar última petición
<leader>as       # Enviar selección a Claude
```

### Obsidian (Notas)

```
<leader>on       # Nueva nota
<leader>os       # Buscar notas
<leader>ot       # Insertar template
<leader>od       # Nota diaria
<CR>             # Smart action (seguir link, toggle checkbox)
```

## Estructura de Archivos

```
HatDotsWindows/
├── nvim/                    # Configuración Neovim
│   ├── lua/config/            # Configuraciones base
│   │   ├── options.lua        # Opciones Neovim
│   │   ├── keymaps.lua        # Atajos personalizados
│   │   ├── utils.lua          # Utilidades varias
│   │   ├── dap.lua            # Debugging configuration
│   │   └── obsidian_maps.lua  # Obsidian keymaps
│   └── lua/plugins/           # Plugins Lazy
│       ├── lsp.lua            # LSP servers
│       ├── format.lua         # Formatters
│       ├── oil.lua            # File explorer
│       ├── telescope.lua      # Búsqueda
│       ├── obsidian.lua       # Notas
│       ├── claude.lua         # AI assistant
│       └── colorscheme.lua    # Tema Kanagawa
├── wezterm/                 # Configuración WezTerm
├── Microsoft.PowerShell_profile.ps1  # PowerShell profile
├── starship.toml           # Starship prompt config
├── install.ps1             # Installation script
└── README.md               # Este archivo
```

## Troubleshooting

### Symlinks no funcionan

```powershell
# Habilitar Developer Mode o ejecutar como Admin
# O ejecutar:
.\install.ps1 -Force
```

### Telescope está lento

```powershell
# Instalar estas herramientas
winget install fd ripgrep  # Ya incluido en requisitos
```

### Build errors en plugins

```powershell
# Algunos plugins necesitan Zig/LLVM
winget install Zig.Zig LLVM.LLVM
```

### Claude Code no funciona

```powershell
# Verificar API key
echo $env:ANTHROPIC_API_KEY

# O configurar manualmente
[Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "tu-key", "User")
```

### LSP no se activa

```vim
:Mason
# Instala los LSPs que necesites:
- vtsls (TypeScript)
- pyright (Python)
- rust-analyzer (Rust)
```

