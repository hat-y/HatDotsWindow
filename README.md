# HatDots Windows

Configuraciones de desarrollo para Windows con Neovim, WezTerm, PowerShell y debugging integrado.

## Instalacion

```powershell
# Clonar el repositorio
git clone https://github.com/hat-y/HatDotsWindows.git $HOME\HatDotsWindows

# Ejecutar script de instalacion
cd $HOME\HatDotsWindows
.\install.ps1
```

## Requisitos

### Herramientas Esenciales

```powershell
winget install -e --id Git.Git
winget install -e --id Neovim.Neovim
winget install -e --id WezTerm.WezTerm
winget install -e --id Starship.Starship
winget install -e --id BurntSushi.ripgrep.MSVC
winget install -e --id sharkdp.fd
```

### Para Desarrollo

```powershell
winget install -e --id JesseDuffield.lazygit
winget install -e --id Zig.Zig
winget install -e --id LLVM.LLVM
winget install -e --id eza-community.eza
```

## Configuracion Post-Instalacion

### Neovim

1. **Primer arranque**: Abre Neovim y espera instalación automática de plugins
2. **Instalar herramientas**: `:Lazy sync`
3. **Instalar LSP**: `:Mason` y selecciona servidores para tus lenguajes
4. **Para debugging Python**: `python -m pip install debugpy`

### API Keys (Opcional)

```powershell
# Claude Code
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "tu-key", "User")
```

## Caracteristicas

### Neovim

- **LazyVim** como base con extras para TypeScript, Python, Rust
- **Debugging integrado** con nvim-dap (soporte para Python, JavaScript/TypeScript)
- **Claude Code** integrado con `<leader>c`
- **Telescope optimizado** con fd y ripgrep
- **Oil** como navegador de archivos

### WezTerm

- Multiplexor con workspaces virtuales
- Launch menu con PowerShell y opciones de admin
- Integración con PowerShell

## Atajos

### Neovim

**Búsqueda y navegación:**

- `<leader>ff` - Buscar archivos
- `<leader>fg` - Búsqueda en contenido
- `<leader>gd` - Ir a definición
- `<leader>gr` - Ir a referencias
- `-` - Abrir Oil (navegador de archivos)

**Debugging:**

- `<F5>` - Continuar debugging
- `<F9>` - Toggle breakpoint
- `<F10>` - Step over
- `<F11>` - Step into
- `<leader>du` - Toggle UI debugging

**Git y productividad:**

- `<leader>gg` - LazyGit
- `<leader>cf` - Formatear código
- `<leader>w` - Guardar archivo

**Claude Code:**

- `<leader>cc` - Toggle Claude
- `<leader>cs` - Enviar selección

### WezTerm

- `Ctrl+Space h/l` - Cambiar workspace
- `Ctrl+Space flechas` - Navegar panes
- `Ctrl+Space -/+` - Dividir

## Estructura

```
HatDotsWindows/
├── nvim/                    # Configuración Neovim
│   ├── lua/config/         # Configuraciones base
│   └── lua/plugins/        # Plugins
├── wezterm/                # Configuración WezTerm
├── Microsoft.PowerShell_profile.ps1  # Perfil PowerShell
├── starship.toml          # Starship prompt
├── install.ps1            # Script de instalación
└── README.md               # Este archivo
```

## Problemas Comunes

- **Symlinks**: Habilita Modo Desarrollador o ejecuta install.ps1 como Administrador
- **Telescope lento**: Asegúrate de tener `fd` y `ripgrep` instalados
- **Build errors**: Requiere Zig y LLVM para algunos plugins

MIT License

