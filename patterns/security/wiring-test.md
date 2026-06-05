# Pattern: Wiring Test for Security-Critical Registries

## Problem
A security-critical store or registry (grant store, nonce registry, rate limiter) is implemented correctly in isolation but never called at the expected callsite. Unit tests of the component pass; the system is silently insecure.

## Example
`WidgetGrantStore.Register()` was implemented and unit-tested. But `authorWidgetAsync` never called it — so `enforceWidgetGrant` always found no grant and was a no-op for async-authored widgets. The gap was caught only in security review.

## Solution
For any security-critical store/registry, write a wiring test that asserts the callsite is reached — not just that the component itself works:

```go
func TestGrantStoreWiredAtSpawn(t *testing.T) {
    store := newWidgetGrantStore()
    server := &BridleServer{WidgetGrants: store}

    // Simulate a SPAWN_WIDGET call
    _ = server.authorWidgetAsync(ctx, spawnRequest, "canvas1", "node1", "op1")

    // Assert Register was called
    if !store.IsGranted("canvas1", "node1", sourceHash, "watch") {
        t.Fatal("WidgetGrantStore.Register not called during async widget spawn")
    }
}
```

## Rule
**For every security-critical store/registry:** the test file must include at least one wiring test asserting the `Register`/`Set`/`Issue` method is called from the expected callsite under normal operation.

## Checklist
When implementing a new security store, check:
- [ ] Component unit tests exist
- [ ] Wiring test exists for each callsite that *must* call the store
- [ ] Test uses the real callsite (not a mock of the store being bypassed)
- [ ] Return values of `Register`/`Issue` are used (not discarded with `_`)

## Where Used
- Bridle `internal/server/mutate_test.go` (TestMutate suite, tests 7-10)
- Lesson learned from S-GRANT-1 Round 2 and F-7 (nonce discarded)
