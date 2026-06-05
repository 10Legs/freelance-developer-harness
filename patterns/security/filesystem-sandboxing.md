# Pattern: Filesystem Sandboxing (Path Traversal Defense)

## Problem
User-supplied or LLM-supplied file paths can escape an intended root via `../` sequences or symlinks that point outside the sandbox.

## Solution
Two-layer validation — both layers required:

```go
func ValidateUnderRoot(root, candidate string) error {
    // Layer 1: collapse .. sequences
    cleanRoot := filepath.Clean(root)
    cleanCandidate := filepath.Clean(filepath.Join(root, candidate))

    // Layer 2: resolve symlinks (catches symlink escape even after prefix check)
    resolvedRoot, err := filepath.EvalSymlinks(cleanRoot)
    if err != nil {
        return fmt.Errorf("root resolve: %w", err)
    }
    resolvedCandidate, err := filepath.EvalSymlinks(cleanCandidate)
    if err != nil {
        // candidate may not exist yet (for writes) — validate prefix on cleaned path
        if !strings.HasPrefix(cleanCandidate, cleanRoot+string(os.PathSeparator)) {
            return fmt.Errorf("path escapes root")
        }
        return nil
    }

    if !strings.HasPrefix(resolvedCandidate+string(os.PathSeparator), resolvedRoot+string(os.PathSeparator)) {
        return fmt.Errorf("path escapes root after symlink resolution")
    }
    return nil
}
```

Apply at **both** the server layer (request validation) and the adapter/filesystem layer (execution). Defense-in-depth means a bug in one layer doesn't open a traversal window.

## Common Mistakes
- `filepath.Clean` alone: insufficient — symlinks bypass it
- Prefix check alone: `filepath.HasPrefix` is deprecated and wrong on case-insensitive filesystems
- Checking only at the server: adapter may be called from other contexts

## Where Used
- Bridle `internal/resources/filesystem.go` (`ValidateUnderRoot`)
- Bridle `internal/adapter/claudecode/adapter.go` (defense-in-depth re-check)

## When to Apply
Any system where user or LLM input influences a filesystem path. Default to applying `ValidateUnderRoot` at every layer that touches the filesystem.
