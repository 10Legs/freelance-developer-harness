# Requirements — Acme Corp

> **Example file.** Replace with your real client requirements.

## Functional Requirements

### Storefront
- Product listing pages with filtering and sorting
- Product detail pages with image gallery, variants, and reviews
- Search with autocomplete (Shopify Storefront API)
- Cart with persistent storage (localStorage + Shopify cart API)
- Guest checkout and authenticated checkout

### CMS (Content Management)
- Marketing team can edit homepage hero, banners, and featured collections
- No-code page builder for landing pages
- Blog/editorial section

### Integrations
- Shopify Storefront API — products, inventory, cart, orders
- Stripe — payment processing
- Google Analytics 4 — event tracking
- Contentful — CMS

## Non-Functional Requirements

- Lighthouse performance score ≥ 90 on mobile
- WCAG 2.1 AA accessibility compliance
- Core Web Vitals: LCP < 2.5s, CLS < 0.1, FID < 100ms
- PCI-DSS compliance for payment flows (delegated to Stripe)
- GDPR compliance: cookie consent, data deletion on request

## Technical Stack (proposed, subject to Architecture sign-off)

- Frontend: Next.js 14 (App Router), TypeScript, Tailwind CSS
- CMS: Contentful
- Deployment: Vercel
- Testing: Playwright (E2E), Vitest (unit)
