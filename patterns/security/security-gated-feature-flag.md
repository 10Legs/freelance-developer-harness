# Pattern: Security-Gated Feature Flag

## Problem
A feature requires explicit Security Reviewer sign-off before traffic can be enabled. Blocking the entire release on security review slows delivery.

## Solution
Implement the feature behind an env var that defaults to `false`. Return `codes.Unimplemented` when unset. This decouples deployment from enablement.

```go
// At server startup
type Server struct {
    MutateEnabled bool
    // ...
}

func New(cfg Config) *Server {
    enabled := os.Getenv("BRIDLE_ENABLE_MUTATE") == "true"
    log.Printf("feature/mutate: enabled=%v", enabled)
    return &Server{MutateEnabled: enabled}
}

// In the handler
func (s *Server) MutateResource(ctx context.Context, req *pb.MutateResourceRequest) (*pb.MutateResourceResponse, error) {
    if !s.MutateEnabled {
        return nil, status.Error(codes.Unimplemented, "mutation not enabled — set BRIDLE_ENABLE_MUTATE=true after security sign-off")
    }
    // ... rest of handler
}
```

## Properties
- **Safe to deploy:** Feature is inert without the flag
- **Operator opt-in:** Explicit action required to enable — no accidental activation
- **Auditable:** Log at startup makes flag state visible in logs
- **Reversible:** Remove the env var to disable without a deploy

## Process
1. Implement feature behind flag (default `false`)
2. Deploy to production — mutation is `Unimplemented`
3. Security Reviewer completes review → APPROVED
4. Set `BRIDLE_ENABLE_MUTATE=true` in deployment config
5. Monitor

## Where Used
- Bridle `internal/server/server.go` — `BRIDLE_ENABLE_MUTATE`

## When to Apply
Any capability that:
- Mutates external state (files, databases, APIs)
- Requires operator consent beyond normal auth
- Has a security gate that may not complete before the release deadline
