# Minecraft Paid Access + Credits Store (Design)

## Goal
Webpage where players enter their Minecraft username, pay monthly, and instantly:
1. Get whitelisted on the server (offline mode, free launchers OK).
2. Receive in-game credits used to buy items via in-game API/commands.

## Recommended Stack (self-hosted, open source)
Use **TeaStore** (https://github.com/TeaStore/teastore - self-hosted webstore for Minecraft) OR build a lightweight custom app. Custom keeps it minimal and matches the homelab:

### Components
1. **Web app** (`helm/webstore/`): Flask/Node - serves shop page, handles payment webhooks, calls Minecraft API.
2. **Payment**: Stripe Checkout (cards) or PayPal. Monthly subscription = recurring webhook `invoice.paid`.
3. **Minecraft plugin** (`plugins/credit-api/`): Paper plugin exposing REST API + commands:
   - `GET /api/credits/<player>` - balance
   - `POST /api/credits/<player>/add` - add credits (auth token)
   - `POST /api/items/<player>/give` - give item (auth token)
   - In-game: `/buy <item>`, `/credits` - buy items from shop config (economy.yml)
4. **Whitelist API**: web app calls plugin API `POST /api/whitelist/add` (writes whitelist.json + kicks refresh) on successful payment.

### Flow
```
Player -> webstore page (dev.local/store or store.local)
  -> enters username + pays monthly (Stripe)
  -> webhook invoice.paid -> verify -> 
     POST plugin /api/whitelist/add {name} 
     POST plugin /api/credits/<name>/add {amount}
Player joins (free launcher) -> whitelisted -> /credits -> /buy diamond_sword
```

## Deployment Steps (next)
1. Write Paper plugin (Java, HTTP server on 8090 + in-game commands).
2. Expose plugin API via Service (ClusterIP) - NOT public; only webstore calls it (same cluster).
3. Deploy webstore helm chart with Stripe keys (vault).
4. Route store.local via Traefik IngressRoute.
5. Public IP: port-forward 80/443 (traefik) + 25565 (minecraft) on router. TLS via Let's Encrypt (Traefik certresolver).

## Security Notes
- Plugin API: bearer token auth, cluster-internal only.
- Whitelist = offline UUID (`MD5("OfflinePlayer:"+name)` v3) - store computes server-side.
- Payments: never store card data; Stripe handles PCI.
- Admin app (grafana/argocd/dev): restrict via IPAllowList middleware.
