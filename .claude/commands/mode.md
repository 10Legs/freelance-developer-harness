---
description: Set or inspect the harness operating mode (plan, auto, safe, status)
---

You are managing the **harness operating mode** for: $ARGUMENTS

$ARGUMENTS may be:
- `plan` — session-scoped plan-only mode (no writes, no mutations)
- `auto` — broad auto-approve permissions written to `.claude/settings.json` (next session)
- `safe` — restore conservative default permissions in `.claude/settings.json` (next session)
- `bypass` — alias for `auto`; reminds the user about `--dangerously-skip-permissions`
- `status` — show current mode (session flag + settings.json snapshot)
- `clear` — remove the session-scoped mode flag

The SESSION_ID is injected into the system prompt as `SESSION_ID = <value>`. Read it from there; if not present, use "default".

**SESSION_ID must match `^[A-Za-z0-9_-]+$`**. If it does not, stop and report "Invalid SESSION_ID — refusing to construct shell paths."

## Steps

### If $ARGUMENTS is "status" (or empty):

1. Run via Bash:
   - `cat .claude/sessions/<SESSION_ID>.mode 2>/dev/null || echo "(no session mode)"`
   - `jq '.permissions' .claude/settings.json 2>/dev/null || echo "(no permissions block)"`
2. Report in this exact format:
   ```
   Session mode:    <value or "none">
   Settings allow:
     - <each entry on its own line>
   Settings deny:
     - <each entry on its own line>
   Startup bypass:  Active only if Claude Code was launched with --dangerously-skip-permissions (cannot be toggled mid-session).
   ```
3. Stop.

### If $ARGUMENTS is "plan":

1. Run `mkdir -p .claude/sessions` via Bash.
2. Write the string `plan` to `.claude/sessions/<SESSION_ID>.mode` using the Write tool.
3. Tell the user:
   - "Session is now in **plan mode**. I will use the `EnterPlanMode` tool for any task that would otherwise produce writes, and will present a plan for approval before any mutation."
   - "To exit: `/mode clear` or `/mode safe`."
4. Immediately invoke `EnterPlanMode` for the current turn so the user sees plan output for any in-flight work.
5. Stop.

### If $ARGUMENTS is "clear":

1. Run `rm -f ".claude/sessions/<SESSION_ID>.mode" && echo "cleared <SESSION_ID>.mode"` via Bash.
2. Confirm: "Session mode cleared. Permissions revert to `.claude/settings.json` defaults."
3. Stop.

### If $ARGUMENTS is "auto" or "bypass":

1. **Warn first** — present this to the user verbatim:
   ```
   ⚠ AUTO MODE — IMPORTANT SECURITY WARNING

   This writes a broad allow list to .claude/settings.json.

   DENY PATTERNS ARE BEST-EFFORT. They cannot stop semantically-equivalent
   commands (e.g. `cd / && rm *`), base64-encoded payloads, or prompt-injection
   attacks. AUTO MODE = effectively bypassed permissions.

   ONLY use in disposable, sandboxed environments where data loss is acceptable.

   Effect is GLOBAL: all future Claude Code sessions in this harness are affected
   until you run /mode safe.

   For zero-prompt operation this session, exit and relaunch:
     claude --dangerously-skip-permissions

   To confirm, type exactly (case-sensitive): ENABLE AUTO MODE
   ```
2. If the user's input (trimmed) is not exactly `ENABLE AUTO MODE`, stop and report: "Auto mode cancelled — no changes made."
3. On confirmed `ENABLE AUTO MODE`:
   a. Read `.claude/settings.json`.
   b. Back up: run `cp .claude/settings.json ".claude/settings.json.bak-$(date +%Y%m%dT%H%M%S)-$(openssl rand -hex 4)" && echo "backup ok"` via Bash. If output is not "backup ok", stop: "Backup failed — auto mode NOT applied."
   c. Write the new permissions block to `.claude/settings.json.tmp` via Bash (using `jq` to splice the block), then validate: `jq empty .claude/settings.json.tmp`. If validation fails, run `rm -f .claude/settings.json.tmp` and stop: "JSON validation failed on temp file — settings.json unchanged."
   d. Atomically replace: `mv .claude/settings.json.tmp .claude/settings.json`. Verify exit 0; if not, restore from backup: `cp <backup-path> .claude/settings.json` and stop with error.
   e. Use the `Edit` tool to verify the `permissions` block now reads as intended (spot-check one `allow` and one `deny` entry).
   f. The new `permissions` block content to write:
      ```json
      "permissions": {
        "allow": [
          "Bash(*)",
          "Read(**)",
          "Write(**)",
          "Edit(**)"
        ],
        "deny": [
          "Bash(rm -rf *)",
          "Bash(rm -fr *)",
          "Bash(rm -r *)",
          "Bash(sudo *)",
          "Bash(dd *)",
          "Bash(mkfs*)",
          "Bash(diskutil *)",
          "Bash(chmod -R 777*)",
          "Bash(chmod 777*)",
          "Bash(shutdown*)",
          "Bash(reboot*)",
          "Bash(halt*)",
          "Bash(launchctl *)",
          "Bash(curl * | sh*)",
          "Bash(curl * | bash*)",
          "Bash(wget * | sh*)",
          "Bash(wget * | bash*)",
          "Bash(git push --force*)",
          "Bash(git push -f *)",
          "Bash(git push --force-with-lease*)",
          "Bash(git config --global *)",
          "Bash(security *)",
          "Bash(osascript *)",
          "Bash(nc *)",
          "Bash(ncat *)",
          "Bash(:(){*)",
          "Read(**/.env)",
          "Read(**/.env.*)",
          "Read(**/id_rsa)",
          "Read(**/id_ed25519)",
          "Read(**/id_ecdsa)",
          "Read(**/id_dsa)",
          "Read(**/*.pem)",
          "Read(**/*.key)",
          "Read(**/.aws/credentials)",
          "Read(**/.aws/config)",
          "Read(**/.netrc)",
          "Read(**/.config/gh/hosts.yml)",
          "Read(**/.ssh/**)",
          "Write(**/.env)",
          "Write(**/.env.*)",
          "Write(**/.ssh/**)",
          "Write(**/authorized_keys)",
          "Write(**/.git/hooks/**)",
          "Write(**/id_rsa)",
          "Write(**/id_ed25519)",
          "Write(**/id_ecdsa)",
          "Write(**/id_dsa)",
          "Write(**/*.pem)",
          "Write(**/*.key)"
        ]
      }
      ```
   g. Write `auto` to `.claude/sessions/<SESSION_ID>.mode`.
4. Confirm:
   - "Auto mode written to `.claude/settings.json`. Backup: `<backup-path>`."
   - "Restart Claude Code for the new permissions to load."
   - "For zero-prompt operation this session: exit and relaunch with `--dangerously-skip-permissions`."
   - "⚠ Deny list is best-effort only — see warning above."
5. Stop.

### If $ARGUMENTS is "safe":

1. Run `mkdir -p .claude/sessions` via Bash.
2. Read `.claude/settings.json`.
3. Back up: run `cp .claude/settings.json ".claude/settings.json.bak-$(date +%Y%m%dT%H%M%S)-$(openssl rand -hex 4)" && echo "backup ok"` via Bash. If output is not "backup ok", stop: "Backup failed — safe mode NOT applied."
4. Use the `Edit` tool to replace the `permissions` block with:
   ```json
   "permissions": {
     "allow": [
       "Bash(git *)",
       "Bash(npm *)",
       "Bash(npx *)",
       "Bash(mkdir *)",
       "Read(**)",
       "Write(clients/**)",
       "Write(patterns/**)",
       "Write(.claude/sessions/*)",
       "Edit(clients/**)",
       "Edit(patterns/**)"
     ],
     "deny": [
       "Bash(rm -rf *)",
       "Bash(rm -fr *)",
       "Bash(rm -r *)",
       "Bash(sudo *)",
       "Bash(git push --force*)",
       "Bash(git push -f *)",
       "Bash(git push --force-with-lease*)",
       "Bash(git config --global *)",
       "Read(**/.env)",
       "Read(**/.env.*)",
       "Read(**/id_rsa)",
       "Read(**/id_ed25519)",
       "Read(**/id_ecdsa)",
       "Read(**/id_dsa)",
       "Read(**/*.pem)",
       "Read(**/*.key)",
       "Read(**/.aws/credentials)",
       "Read(**/.ssh/**)",
       "Write(**/.env)",
       "Write(**/.env.*)",
       "Write(**/.ssh/**)",
       "Write(**/id_rsa)",
       "Write(**/id_ed25519)",
       "Write(**/id_ecdsa)",
       "Write(**/id_dsa)",
       "Write(**/*.pem)",
       "Write(**/*.key)",
       "Write(**/authorized_keys)",
       "Write(**/.git/hooks/**)"
     ]
   }
   ```
5. Validate JSON: run `jq empty .claude/settings.json` via Bash. If non-zero, restore from backup (`cp <backup-path> .claude/settings.json`) and report: "JSON validation failed — restored from backup. Safe mode NOT applied."
6. Write `safe` to `.claude/sessions/<SESSION_ID>.mode`.
7. Confirm: "Safe mode restored in `.claude/settings.json`. Backup: `<backup-path>`. Restart Claude Code for new permissions to load."
8. Stop.

### Otherwise (unknown argument):

- Tell the user: "Unknown mode `$ARGUMENTS`. Valid: `plan`, `auto`, `bypass`, `safe`, `status`, `clear`."
- Stop.

## Notes

- `plan` mode is session-only; it does not modify `settings.json`. Other Claude sessions are unaffected.
- `auto` / `safe` modify `settings.json` which is global to the harness — coordinate with the team before flipping.
- The startup flag `--dangerously-skip-permissions` is the only way to suppress prompts mid-session; this command cannot toggle it.
- All session mode flags live at `.claude/sessions/<SESSION_ID>.mode` and are git-ignored.
- `settings.json.bak-*` files are git-ignored — do not commit them. Prune periodically with `rm .claude/settings.json.bak-*`.
- Deny patterns are best-effort string matching. They cannot prevent all destructive operations. `auto` mode is effectively equivalent to `--dangerously-skip-permissions` in practice.
- Claude Code evaluates `deny` before `allow` for overlapping globs — deny takes precedence. `Read(**)` in safe mode does not override credential denies.
- Session mode flags (`.claude/sessions/<SESSION_ID>.mode`) are advisory only — no permission-level enforcement. A model can still write files even in `plan` mode; for hard guarantees use `safe` mode.
- `plan` mode is a soft control: the model is instructed to use `EnterPlanMode` but this is not enforced at the permission layer. For write-proof operation, use `safe` mode + launch restrictions.
- `Write(.claude/sessions/*)` in safe mode is intentionally broad (needed for `/use-client`, `/pm`, `/mode` itself). Session flags are non-authoritative — spoofing them changes display only, not actual permissions.
