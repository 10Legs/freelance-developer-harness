# Port Registry

Centralized port allocations for all local development projects.
**Before starting a new project, claim your ports here to avoid collisions.**

## Allocated Ports

| Project | Repo | Backend | Frontend | Notes |
|---------|------|---------|----------|-------|
| example-storefront | `$SOURCE_ROOT_BASE/storefront` | **3011** | **5111** | Example entry — replace with your projects |

## Reserved / Avoid

| Port | Reason |
|------|--------|
| 3000 | Generic default — too likely to collide with random tools |
| 3001 | Common framework default — **do not reuse** |
| 5173 | Vite default — **do not reuse** |

## Claiming a New Port

1. Pick an unclaimed backend in the `30xx` range and frontend in `51xx` range.
2. Add a row to this table in a PR before starting work.
3. Set `PORT=<backend>` in the project's `.env`.
4. Set `server.port: <frontend>` in `vite.config.ts` (or equivalent).
5. Update the Vite proxy `target` to point at the new backend port.
