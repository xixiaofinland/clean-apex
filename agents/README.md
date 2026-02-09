# Agent Platform Configurations

This directory contains platform-specific configurations for the clean-apex skill across different agent platforms.

## Available Configurations

### 1. [claude.yaml](./claude.yaml) - Claude Code
**Platform**: Claude Code CLI
**Hook Support**: ✓ Full automatic hook execution
**Auto-loading**: ✓ References loaded automatically

**Features**:
- Automatic validation on `Write` and `Edit` operations
- Advisory mode by default (non-blocking)
- Auto-loads all reference documentation
- Full suppression directive support

**Installation**:
```bash
# Place skill in Claude Code skills directory
cp -r clean-apex ~/.claude/skills/
```

### 2. [codex.yaml](./codex.yaml) - Codex CLI
**Platform**: Codex CLI
**Hook Support**: ⚠️ Auto-detect with manual fallback
**Auto-loading**: ✗ Load on demand

**Features**:
- Auto-detects hook availability
- Falls back to manual validation if hooks unavailable
- On-demand reference loading
- Advisory validation mode

**Installation**:
```bash
# Install under Codex skills directory
cp -r clean-apex ~/.codex/skills/

# Or project-specific
cp -r clean-apex .codex/skills/
```

**Manual Validation**:
```bash
echo '{"tool_input":{"file_path":"force-app/main/default/classes/MyClass.cls"}}' | \
  python3 hooks/scripts/clean-apex-validate.py
```

### 3. [github-copilot.yaml](./github-copilot.yaml) - GitHub Copilot
**Platform**: GitHub Copilot Agent Skills
**Hook Support**: ⚠️ Auto-detect with manual fallback
**Auto-loading**: ✗ Manual resource loading

**Features**:
- GitHub Copilot Agent Skills schema compliance
- Detailed capability declarations
- Resource path mapping for docs/templates
- Manual validation instructions

**Installation**:
Follow GitHub Copilot Agent Skills installation process for your workspace.

**Manual Validation**:
```bash
echo '{"tool_input":{"file_path":"YOUR_FILE.cls"}}' | \
  python3 hooks/scripts/clean-apex-validate.py
```

### 4. [generic.yaml](./generic.yaml) - Generic Fallback
**Platform**: Any unknown or custom platform
**Hook Support**: ✗ Manual only
**Auto-loading**: ✗ Manual loading

**Features**:
- Minimal configuration for maximum compatibility
- Detailed manual instructions
- Works on any platform supporting SKILL.md format
- No platform-specific dependencies

**Usage**:
Use this configuration when:
- Your platform doesn't have a specific config
- You're developing a custom agent platform
- You want maximum control over skill behavior

## Configuration Priority

When multiple configuration files are present, platforms typically use this priority:

1. **Platform-specific config** (e.g., `claude.yaml` for Claude Code)
2. **OpenAI config** (`openai.yaml`) if platform is OpenAI-compatible
3. **Generic fallback** (`generic.yaml`)
4. **SKILL.md defaults** (root skill definition)

## Configuration Structure

All configuration files follow this general structure:

```yaml
version: "1.0.0"              # Skill version
platform: "platform-name"      # Target platform

interface:                     # User-facing metadata
  display_name: "Clean Apex"
  short_description: "..."
  default_prompt: "..."

hooks:                         # Hook configuration
  enabled: true/false/auto-detect
  post_tool_use: [...]        # Tool-specific hooks

references:                    # Reference documentation
  auto_load: true/false
  directory: "references/"

templates:                     # Template configuration
  directory: "templates/"
  index: "templates/TEMPLATE_INDEX.md"

validation:                    # Validator settings
  enabled: true
  mode: advisory
  suppression_supported: true

capabilities: [...]            # Skill capabilities

settings:                      # Behavior settings
  strict_mode: false
  auto_fix: false
  report_format: "human_readable"
```

## Adding a New Platform Configuration

To add support for a new platform:

1. **Create configuration file**: `agents/your-platform.yaml`
2. **Follow the structure**: Use existing configs as templates
3. **Document capabilities**: Clearly specify what works and what doesn't
4. **Test validation**: Verify manual validation works if hooks unavailable
5. **Update this README**: Add section documenting the new platform
6. **Update CHANGELOG.md**: Add entry under `[Unreleased]`

### Example New Platform Config

```yaml
version: "1.0.0"
platform: your-platform

interface:
  display_name: "Clean Apex"
  short_description: "Readable, layered Apex clean-code guidance"

hooks:
  enabled: auto-detect
  fallback: manual

validation:
  mode: advisory
  manual_instructions: |
    Run: echo '{"tool_input":{"file_path":"FILE.cls"}}' | python3 hooks/scripts/clean-apex-validate.py

capabilities:
  - code_review
  - code_generation
  - validation
  - architecture_guidance
```

## Hook Configuration Details

### Automatic Hooks (Claude Code)
- Hooks run automatically after `Write` or `Edit` operations
- No user intervention required
- Advisory output shown immediately

### Auto-Detect Hooks (Codex, GitHub Copilot)
- Platform attempts to run hooks automatically
- Falls back to manual validation if hooks unavailable
- User receives instructions for manual validation

### Manual Validation (Generic, fallback)
- User explicitly runs validator command
- Provides full control over when validation occurs
- Required on platforms without hook support

## Validation Modes

All platforms support **advisory mode**:
- Validation feedback is informational
- File operations are never blocked
- Users can suppress rules with directives: `// clean-apex: allow=RULE_CODE`

## Version Consistency

All platform configurations must maintain version consistency:
- Configuration version matches SKILL.md version
- Update all configs when releasing new versions
- Verify with: `scripts/verify-implementation.sh`

## Troubleshooting

### Configuration Not Loading

**Problem**: Agent doesn't recognize the skill configuration.

**Solutions**:
- Verify file is named correctly (e.g., `claude.yaml` for Claude Code)
- Check YAML syntax: `python3 -c "import yaml; yaml.safe_load(open('agents/your-file.yaml'))"`
- Ensure skill directory structure is intact
- Review platform-specific installation docs

### Hooks Not Executing

**Problem**: Validator doesn't run automatically.

**Solutions**:
- Check platform hook support in this README
- Verify Python 3.7+ is available: `python3 --version`
- Try manual validation command
- Review hook configuration in your platform's config file

### Manual Validation Command Fails

**Problem**: Manual validator command returns errors.

**Solutions**:
- Verify Python is installed: `python3 --version`
- Check file path is correct (absolute or relative to skill directory)
- Ensure JSON format is correct: `{"tool_input":{"file_path":"..."}}`
- Check file is an Apex file (`.cls` or `.trigger`)

## Support

For platform-specific issues:
- Consult platform documentation
- Review `README.md` for general troubleshooting
- Submit issues at: https://github.com/anthropics/claude-code/issues

For configuration contributions:
- See `README.md` Contributing section
- Follow version consistency requirements
- Test thoroughly on target platform
