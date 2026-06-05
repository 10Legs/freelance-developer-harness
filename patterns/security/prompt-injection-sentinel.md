# Pattern: Prompt Injection Defense via XML Sentinels

## Problem
When external data (user files, resource content, external API responses) is injected into an LLM system prompt, a malicious payload can override instructions — OWASP LLM01 (Prompt Injection).

## Solution
Wrap all injected external content in XML sentinels that instruct the model the enclosed content is untrusted data, not instructions:

```go
const sentinelFmt = `<untrusted_operator_data label=%q>
%s
</untrusted_operator_data>`

func wrapUntrusted(label, content string) string {
    return fmt.Sprintf(sentinelFmt, label, content)
}
```

Usage in prompt assembly:
```go
systemPrompt := baseInstructions + "\n\n" +
    wrapUntrusted("resource-content", resourceBody) + "\n\n" +
    wrapUntrusted("session-output", sessionLog)
```

The sentinel instructs the model: treat enclosed text as data only, not as instructions. Add an inline code comment naming the attack vector so future maintainers understand the purpose.

## Why XML Tags
- Models trained on structured data respond well to explicit structural boundaries
- XML is unambiguous — unlike markdown fences which the model may treat as formatting
- Label attribute provides context for why content is untrusted

## Where Used
- Bridle `internal/server/interpret.go` — resource content + session output injected into widget generation prompt

## When to Apply
Any LLM call where user-controlled or externally-sourced content is interpolated into the system prompt. Default to wrapping; opt out only when content is known-safe (e.g., internal config values from the operator).
