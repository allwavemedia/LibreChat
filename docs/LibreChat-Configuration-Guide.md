# LibreChat configuration guide

This guide explains the most important options in `librechat.yaml`, why and when to use them, and a few practical tips for operating your instance. It is tailored to your current configuration and cross‑references the official docs for deeper details.

Note: After changing `librechat.yaml`, restart the stack for changes to take effect. On your Mac you can double‑click `Start LibreChat.command` on the Desktop, or use `scripts/start_librechat.sh`.

---

## File: `librechat.yaml`

### Version and cache
- `version: 1.2.1` — Config schema version. Keep aligned with your app version/releases.
- `cache: true` — Enables server‑side caching (speeds up some operations). Disable only when debugging cache‑related issues.

### Interface (UI/UX)
Your current `interface` block:
- `customWelcome` — Message shown on the home screen.
- `fileSearch: true` — Shows File Search as a chat "input type" option. This does not disable Agents’ File Search capability; that’s controlled under Agents Endpoint.
- `privacyPolicy` and `termsOfService` — URLs and modal behavior for transparency/compliance. Use `modalAcceptance: true` if you need explicit consent in‑app.
- Common toggles: `endpointsMenu`, `modelSelect`, `parameters`, `sidePanel`, `presets`, `prompts`, `bookmarks`, `multiConvo`, `agents` — Turn UI features on/off. Keep these on unless you’re simplifying the UI for a focused use‑case.
- `peoplePicker` — Enables selecting users, groups, and roles for sharing/features that support it.
- `marketplace.use: false` — Hides the community marketplace. Turn on if you want curated, community‑shared content directly in the app.
- `fileCitations: true` — Shows citations when file‑grounded answers are produced. Great for traceability.
- `temporaryChatRetention` (commented) — Hours to retain temporary chats. Useful for privacy‑sensitive deployments.

When to change:
- Disable UI elements for kiosk or single‑purpose deployments.
- Use custom policy/TOS if you’re hosting for a team or customers.

Reference: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/interface

### Registration
- `registration.socialLogins` — Enabled providers: `github`, `google`, `discord`, `openid`, `facebook`, `apple`, `saml`.
- `allowedDomains` (commented) — Restrict sign‑ups to specific email domains.

When to change:
- Enterprise SSO: enable `saml` or `openid` and configure IdP.
- Community instance: keep multiple social logins; set `allowedDomains` if you need gating.

### Balance and transactions (optional)
Commented examples are present.
- `balance.enabled` — Enables token/credit metering per user.
- `transactions.enabled` — Stores transaction history. If balance is enabled, this is forced on to track usage.

When to change:
- Turn on for internal chargeback, cost limits, or rate governance.

### Speech (optional)
Commented examples for TTS (`speech.tts`) and STT (`speech.stt`). Provide provider URL/API key/model per vendor.

When to change:
- Enable if you want voice input or audio output features.

### Rate limits (optional)
Commented examples for uploads/imports per IP and per user. Set to prevent abuse or manage resources.

### Actions (API actions/HTTP tools)
Your current config:
- `actions.allowedDomains`: `swapi.dev`, `librechat.ai`, `google.com` — White‑list hosts your actions/tools can call.

When to change:
- Add domains for your internal APIs. Keep the list tight for security.

Reference: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/actions

### MCP Servers (Model Context Protocol)
Your current servers:

1) `MCP_DOCKER` (stdio gateway)
- `type: stdio`, `command: docker`, `args: [mcp, gateway, run]`, `timeout: 60000`.
- Purpose: Bridges to MCP servers running inside Docker containers via the gateway.
- Tip: If you don’t routinely use it, consider adding `startup: false` to avoid launching it automatically.

2) `microsoft_learn` (Microsoft Learn MCP)
- `type: streamable-http`
- `url: https://learn.microsoft.com/api/mcp`
- `timeout: 30000`
- `serverInstructions: true` — Allows the server to send tool‑specific instructions that improve results.
- `chatMenu: true` — Shows up in the chat Tool menu.

What it does:
- Gives trusted, up‑to‑date answers sourced from Microsoft Learn documentation (public docs). No authentication required.

When to use:
- Any time you or your users ask Microsoft/Azure/.NET/M365 questions and you prefer grounded, official answers.

Notes:
- Transport type must be `streamable-http` with this endpoint.
- Content scope is docs; it won’t access your tenant data.

Official info: https://learn.microsoft.com/en-us/training/support/mcp
MCP config reference: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/mcp_servers

### Endpoints (LLM providers)
You have 4 custom endpoints configured as examples. Enable each by providing `apiKey` via environment variables.

- Groq
  - `baseURL: https://api.groq.com/openai/v1/`
  - Models: `llama3-*`, `mixtral-*`, `gemma-*`
  - Great for fast, inexpensive inference. Provide `GROQ_API_KEY`.

- Mistral
  - `baseURL: https://api.mistral.ai/v1`
  - `models.fetch: true` to auto‑discover models; `dropParams` omits parameters Mistral doesn’t accept.
  - Provide `MISTRAL_API_KEY`.

- OpenRouter
  - `baseURL: https://openrouter.ai/api/v1`
  - Acts as an aggregator. `dropParams: ['stop']` recommended.
  - Provide `OPENROUTER_KEY`.

- Portkey (routing/proxy)
  - Uses custom headers (`x-portkey-*`) and virtual keys.
  - Useful for vendor abstraction, auditing, and policy.

Common options:
- `titleConvo`, `titleModel` — Automatic titling.
- `modelDisplayLabel` — Friendly name in the UI.
- `dropParams` — Strip unsupported OpenAI‑style parameters per provider.

When to change:
- Prefer 1–2 primary providers for simplicity. Add secondary endpoints for special tasks (e.g., vision, long‑context, or cost‑optimized models).

Reference: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/endpoints

### Model specs (optional)
Commented examples show how to group curated presets under a `group` (endpoint name or custom section) with instructions/temperature. Great for offering opinionated “modes” in the model selector.

### File configuration
Commented examples include:
- `fileConfig.endpoints.*` — Per‑endpoint file limits/mime types.
- Global limits: `serverFileSizeLimit`, `avatarSizeLimit`.
- `imageGeneration` sizing and `clientImageResize` for pre‑upload scaling.

When to change:
- Tighten limits for security/performance.
- Enable `clientImageResize` to reduce upload failures on large images.

Reference: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/file_config

### Web Search (optional)
Commented examples include:
- Rerankers: Jina (`jinaApiKey`), Cohere.
- Search providers: Serper (`serperApiKey`) or self‑hosted SearXNG (`searxngInstanceUrl`, `searxngApiKey`).
- Scrapers: Firecrawl (`firecrawlApiKey`, optional `firecrawlApiUrl`).

When to change:
- Choose Serper for simplicity (hosted); SearXNG for self‑hosting and privacy.
- Add a reranker (Jina/Cohere) for higher‑quality snippets.

Reference: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/web_search

### Memory (optional, per‑user memories)
Commented example includes:
- `disabled` — Turn memory entirely off.
- `validKeys` — Whitelist structured keys to improve consistency (e.g., `preferences`, `skills`).
- `tokenLimit` — Soft cap (future token counting integration).
- `personalize` — Show/hide the Personalization tab.
- `agent` — Use an existing agent by `id` or define an inline agent with `provider`, `model`, `instructions`, and `model_parameters`.

When to change:
- Enable for long‑lived assistants; disable for strict privacy.
- Use a dedicated, low‑temperature model for memory extraction.

Reference: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/memory

---

## Microsoft Learn MCP: quick start
- It’s already configured as `microsoft_learn` and visible in the chat Tool menu (`chatMenu: true`).
- Use it when asking questions about Azure, .NET, Microsoft 365, Power Platform, and other Microsoft products.
- No API key required. Results come from Microsoft Learn docs with server‑provided guidance enabled (`serverInstructions: true`).

Troubleshooting:
- If you don’t see it, verify the `mcpServers.microsoft_learn` block and restart the app.
- Network restrictions or corporate proxies can block access; allow `learn.microsoft.com`.

---

## Operations tips
- Restart after config updates: Use the Desktop launcher or `scripts/start_librechat.sh`.
- YAML validation: The starter script will warn if `librechat.yaml` has syntax issues (Ruby YAML check, optional).
- Environment variables: Prefer `${VAR_NAME}` in config and define them in `.env`.
- Security: Keep `actions.allowedDomains` narrow. Don’t expose admin endpoints publicly. Consider rate limits.
- Cost control: Enable Balance/Transactions if you need per‑user usage tracking.

---

## Recommended next steps (for your setup)
- MCP Docker gateway: If not in use, add `startup: false` under `mcpServers.MCP_DOCKER` to avoid autostart.
- Web Search: Pick one provider path:
  - Hosted: set `webSearch.serperApiKey` and optionally `jinaApiKey` for reranking.
  - Self‑hosted: configure SearXNG instance and key.
- Memory: Enable with a small, deterministic model and a minimal `validKeys` list.
- File config: Set `serverFileSizeLimit` and consider enabling `clientImageResize` to reduce upload errors.

---

## References
- LibreChat YAML overview: https://www.librechat.ai/docs/configuration/librechat_yaml
- Interface: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/interface
- MCP Servers: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/mcp_servers
- Web Search: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/web_search
- Memory: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/memory
- File Config: https://www.librechat.ai/docs/configuration/librechat_yaml/object_structure/file_config
- Microsoft Learn MCP: https://learn.microsoft.com/en-us/training/support/mcp

---

If you want, I can add a small “Stop LibreChat.command” next to your start launcher, or wire in any of the optional sections (Web Search, Memory, fileConfig) with your chosen provider settings.