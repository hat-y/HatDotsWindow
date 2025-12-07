# HatDots Windows

Configuraciones de desarrollo para Windows optimizadas con Neovim, WezTerm, PowerShell y herramientas de IA.

## 🚀 Instalación Rápida

```powershell
# Clonar el repositorio
git clone https://github.com/hat-y/HatDotsWindows.git $HOME\HatDotsWindows

# Ejecutar script de instalación
cd $HOME\HatDotsWindows
.\install.ps1
```

## 📋 Requisitos

### Herramientas Esenciales
```powershell
winget install -e --id Git.Git
winget install -e --id Neovim.Neovim
winget install -e --id WezTerm.WezTerm
winget install -e --id Starship.Starship
```

### Herramientas de Desarrollo
```powershell
winget install -e --id BurntSushi.ripgrep.MSVC
winget install -e --id sharkdp.fd
winget install -e --id JesseDuffield.lazygit
winget install -e --id Zig.Zig
winget install -e --id LLVM.LLVM
```

### Opcionales Recomendados
```powershell
winget install -e --id eza-community.eza
winget install -e --id ajeetdsouza.zoxide
winget install -e --id GitHub.cli
```

## 🎨 Características

### Neovim (LazyVim + IA)
- **Plugins de IA**: Claude Code, configuración para Gemini/OpenAI
- **Lenguajes**: TypeScript, Python, Rust soporte completo
- **Productividad**: Telescope, Oil (navegador de archivos), LazyGit
- **UI**: Tema Kanagawa transparente, Treesitter, formateo automático

### WezTerm
- Multiplexor de terminal moderno
- Workspaces virtuales
- Integración con layouts personalizados
- Tema coordinado con Neovim

### PowerShell + Starship
- Perfil PowerShell optimizado
- Prompt Starship con información útil
- Aliases y funciones de productividad
- Integración con herramientas modernas

## 🔧 Configuración Post-Instalación

### Neovim
1. **Primer arranque**: Abre Neovim y espera que Lazy instale los plugins
2. **LSP/Mason**: Ejecuta `:Mason` para instalar servidores LSP
3. **Formateadores**: `:MasonInstall prettierd stylua ruff`
4. **Treesitter**: `:TSUpdate` para actualizar parsers

### API Keys (Plugins de IA)
Configura las variables de entorno en PowerShell:

```powershell
# Gemini (opcional)
[System.Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "tu-key-gemini", "User")

# Claude (opcional)
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "tu-key-claude", "User")

# OpenAI (opcional)
[System.Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "tu-key-openai", "User")
```

Para más detalles, ver `API_KEYS.md`.

### Fonts
Installa una Nerd Font para soporte de iconos:
```powershell
winget install -e --id NerdFonts.FiraCode
```

## 📁 Estructura

```
HatDotsWindows/
├── nvim/                    # Configuración Neovim + plugins IA
├── wezterm/                 # Configuración WezTerm
├── Microsoft.PowerShell_profile.ps1  # Perfil PowerShell
├── starship.toml           # Configuración Starship
├── API_KEYS.md            # Guía de configuración de APIs
├── WEZTERM_GUIDE.md       # Guía avanzada de WezTerm
├── install.ps1            # Script de instalación
└── README.md              # Este archivo
```

## ⌨️ Atajos Principales

### Neovim
- `<leader>ff` - Buscar archivos
- `<leader>fg` - Búsqueda global
- `<leader>gg` - LazyGit
- `<leader>cf` - Formatear código
- `-` - Oil (navegador de archivos)
- `<leader>cc` - Claude Code toggle
- `<leader>cs` - Claude Code enviar selección

### WezTerm
- `Ctrl+Space h/l` - Cambiar workspace
- `Ctrl+Space flechas` - Navegar panes
- `Ctrl+Space -/+` - Dividir vertical/horizontal

### PowerShell
- `ll` - Listado largo (eza)
- `la` - Listado completo
- `..` - Directorio anterior
- `reload-profile` - Recargar perfil PowerShell

## 🐛 Problemas Comunes

### Symlinks
- **Windows 10/11**: Habilita "Modo Desarrollador" para crear symlinks sin admin
- **Alternativa**: Ejecutar el script como Administrador

### Plugins de Neovim
- **Build errors**: Asegúrate de tener Zig y LLVM instalados
- **Mason**: Reinicia Neovim si Mason no encuentra herramientas

### API Keys
- **Claude Code**: Necesita `ANTHROPIC_API_KEY`
- **Gemini**: Necesita `GEMINI_API_KEY`
- Las keys se configuran en variables de entorno de usuario

## 🤝 Contribuciones

Las mejoras son bienvenidas:
- Reporta issues en GitHub
- Envía pull requests
- Sugiere nuevas configuraciones

## 📄 Licencia

MIT License - Siéntete libre de usar, modificar y distribuir.

## 🌟 Créditos

Basado en LazyVim y configuraciones optimizadas para desarrollo en Windows.