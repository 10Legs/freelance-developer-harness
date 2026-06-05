# Pattern: LLM-Generated Code AST Validation

## Problem
LLM-generated code (React widgets, scripts) must be validated before execution in a sandboxed context. Prompt engineering alone is insufficient — the model may include dangerous identifiers regardless of instructions.

## Solution
Two-layer server-side validation before the source reaches the client:

**Layer 1 — HTML pattern backstop (fast regex):**
Block patterns that are dangerous regardless of JS parse context: `<script src`, CSP meta overrides, data URIs embedding scripts.

**Layer 2 — esbuild JS parse + identifier walk:**
Use `github.com/evanw/esbuild/pkg/api` (pure-Go, no CGo) to parse the JS/TSX source. Walk the AST and reject any file containing denied identifiers.

```go
result := api.Transform(source, api.TransformOptions{
    Loader: api.LoaderTSX,
})
// walk result.AST for DeniedIdentifiers
```

**Deny-list (store as exported var for auditability):**
```go
var DeniedIdentifiers = []string{
    "fetch", "XMLHttpRequest", "WebSocket",
    "eval", "Function",          // dynamic execution
    "document.cookie", "localStorage", "sessionStorage",
    "window.parent", "window.top", "window.opener",
    "import(",                   // dynamic import
}
```

## Properties
- **Speed:** ~1-3ms per widget (parse only, no execution)
- **Attack surface:** Zero — no JS runtime, no CGo
- **Auditability:** Deny-list in a single exported file; Security Reviewer can audit without reading Go

## Where Used
- Bridle `internal/server/widget_ast.go` + `widget_ast_rules.go`

## When to Apply
Any system that takes LLM-generated code and executes it in a browser sandbox or server-side runtime.

## Limitations
- Catches identifier-level patterns; does not catch obfuscated payloads (Base64 eval, string concatenation). Combine with strict iframe CSP as second line of defense.
- Must be updated when new dangerous APIs emerge.
