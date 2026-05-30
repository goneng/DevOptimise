# Claude Code baseline config

A starter set of personal Claude Code configuration files, distributed as a single git patch. \
Treats `~` as the repo root so the paths inside the patch (`.claude/settings.json`, `.claude/CLAUDE.md`)
land in the user's home directory when applied from there.

## Contents

`claude-config.patch` creates two files:

- **`.claude/CLAUDE.md`** — Global behavior instructions injected into every Claude Code session.
  Sets tone (concise, no emojis), behavior rules (ask before picking between interpretations,
  match existing code style, write a failing test before fixing a bug, etc.).
- **`.claude/settings.json`** — Harness configuration. Registers the official plugin marketplace,
  sets the UI theme, defines a read-only permission allowlist (`git status`/`diff`/`log`/`show`, `ls`, `rg`, `grep`, `find`, `cat`, etc.)
  so common commands run without prompting, denies destructive commands (`rm -rf`, `git push -f`),
  allows `git push --force-with-lease`, and configures a minimal `cwd on <branch>` statusLine.

Neither file contains secrets.

## Preview

To preview without applying:

```bash
cd ~
git apply --check /path/to/claude-config.patch
```

## Apply

To install into your home directory:

```bash
cd ~
git apply /path/to/claude-config.patch
```

If `~/.claude/` already exists, the patch will refuse to overwrite. Move or merge the existing files first.

## Customize

After applying, edit the files directly. Common knobs:

- **More auto-allowed commands**: append rules like `Bash(make:*)` to `permissions.allow` in `.claude/settings.json`.
  Permission rule syntax: `Tool(prefix:*)` for prefix matching, `Tool(exact)` for exact match.
- **Force-push policy**: `--force-with-lease` is allowed; `-f` shorthand is denied. Plain `--force` is unlisted (prompts on use).
  Branch-conditional rejection (e.g., block force-push on `release-*`) needs a `PreToolUse` hook or server-side branch protection —
  not expressible in static permissions.
- **statusLine**: receives session context as JSON on stdin; the included one only uses `$PWD` and `git branch`.
  See Claude Code docs for richer formats.

## Older Macs (illegal hardware instruction)

Recent Claude Code builds may crash with `zsh: illegal hardware instruction  claude` on older Intel Macs
that lack CPU instructions targeted by newer Node or native binaries. Workaround: pin to an older release.

```bash
nvm install 24
nvm use 24
npm install -g @anthropic-ai/claude-code@2.1.112
claude --version
```

Replace `2.1.112` with the latest version that works on your machine.
To find a working version, browse the [release history on npm](https://www.npmjs.com/package/@anthropic-ai/claude-code?activeTab=versions)
and step back until the crash stops.

### Disable auto-update and migration nag

The npm-installed version will show a "Claude Code has switched from npm to native installer" notice
on every startup (no way to suppress it) and will auto-update to a crashing build unless blocked.
Add both flags to `~/.claude/settings.json` under an `"env"` key:

```json
{
  "env": {
    "CLAUDE_CODE_DISABLE_AUTOUPDATER": "1",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1"
  }
}
```

`CLAUDE_CODE_DISABLE_AUTOUPDATER` alone is not enough -- the second flag is what actually stops
the auto-update on pinned npm installs. If `~/.claude/settings.json` already has other keys,
just add the `"env"` block alongside them. After restarting, verify the version has not changed:

```bash
claude --version
```

## Scope

This patch only seeds **user-global** config under `~/.claude/`. \
For per-repo overrides, add a `.claude/settings.json` inside that repo (committed) or
`.claude/settings.local.json` (gitignored). \
Project-level files override user-global; permission allow-arrays are unioned across scopes.
