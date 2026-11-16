# The Citadel Remote MCP Server (`com.thecitadelapp/citadel`)

Hosted **Streamable HTTP** Model Context Protocol (MCP) server for deterministic dating profile rubrics, lead photo evaluation criteria, and profile readiness diagnostics.

- **Remote MCP Endpoint (Public):** `https://thecitadelapp.com/api/mcp`
- **Authenticated MCP Endpoint:** `https://thecitadelapp.com/api/mcp/server` (requires `Authorization: Bearer <token>`)
- **Transport:** `streamable-http` (JSON-RPC 2.0 over HTTPS — no local install required)
- **Registry ID:** `com.thecitadelapp/citadel` (`v1.0.0`)
- **Publisher:** The Citadel Operations ([support@thecitadelapp.com](mailto:support@thecitadelapp.com))
- **Website:** [https://thecitadelapp.com](https://thecitadelapp.com)

---

## Quickstart: Connect in Your MCP Client

All three public diagnostic tools on `https://thecitadelapp.com/api/mcp` work over HTTPS with **no credentials required**.

### 1. Cursor

Copy [`.cursor/mcp.json`](./.cursor/mcp.json) into your project's `.cursor/mcp.json` (or `~/.cursor/mcp.json` globally):

```json
{
  "mcpServers": {
    "citadel": {
      "type": "http",
      "url": "https://thecitadelapp.com/api/mcp"
    }
  }
}
```

### 2. Claude Code

Add the remote Streamable HTTP server directly from your terminal:

```bash
claude mcp add --transport http citadel https://thecitadelapp.com/api/mcp
```

### 3. Claude Desktop

- **Option A (Connectors UI):** Open **Settings → Connectors → Add custom connector** and enter `https://thecitadelapp.com/api/mcp`.
- **Option B (`claude_desktop_config.json`):** Use [`claude_desktop_config.json`](./claude_desktop_config.json) with `mcp-remote`:

```json
{
  "mcpServers": {
    "citadel": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://thecitadelapp.com/api/mcp"
      ]
    }
  }
}
```

### 4. Windsurf

Add The Citadel to `~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "citadel": {
      "serverUrl": "https://thecitadelapp.com/api/mcp"
    }
  }
}
```

### 5. Antigravity

In Antigravity's `mcp_config.json`, register the remote Streamable HTTP endpoint:

```json
{
  "mcpServers": {
    "citadel": {
      "serverUrl": "https://thecitadelapp.com/api/mcp"
    }
  }
}
```

---

## Available Public MCP Tools

| Tool | Purpose | Key Inputs |
| :--- | :--- | :--- |
| `citadel_platform_status` | Return service health, supported protocols (`mcp`, `acp`, `ucp`, `x402`), public web routes, and discovery endpoints. | `{}` (no arguments) |
| `citadel_get_lead_photo_rubric` | Retrieve the deterministic dating profile and lead photo evaluation rubric (slot 1 clarity, lighting exposure, framing posture, activity variety, prompt hooks). | `platform` (`hinge` \| `bumble` \| `tinder` \| `general`, optional) |
| `citadel_evaluate_profile_readiness` | Score dating profile structural readiness and surface first-impression conversion bottlenecks from photo count, lead photo clarity, and prompt count. | `photoCount` (required number, `1-6`), `soloClearLeadPhoto` (required boolean), `promptCount` (optional number, `0-3`) |

---

## Discovery & Verification Endpoints

| Endpoint | Purpose |
| :--- | :--- |
| `https://thecitadelapp.com/api/mcp` | Public Streamable HTTP JSON-RPC 2.0 MCP endpoint (`POST` for `initialize`, `tools/list`, `tools/call`; `GET` returns server summary & tool names). |
| `https://thecitadelapp.com/api/mcp/server` | Bearer-authenticated MCP endpoint (`POST`, returns HTTP `401` without a valid bearer token). |
| `https://thecitadelapp.com/.well-known/mcp.json` | Machine-readable MCP server discovery card (`protocolVersion: "2025-03-26"`, version `1.0.0`). |
| `https://thecitadelapp.com/.well-known/mcp-registry-auth` | Ed25519 domain ownership proof (`v=MCPv1; k=ed25519; ...`) for the Official MCP Registry. |
| `https://thecitadelapp.com/.well-known/agent-card.json` | Agent-to-Agent (A2A) discovery card (`protocolVersion: 0.3.0`) pointing to `https://thecitadelapp.com/api/a2a/lead-photo`. |
| `https://thecitadelapp.com/llms.txt` | Concise `llms.txt` directory covering The Citadel's lead-photo check, frameworks, and public routes. |

---

## Web Diagnostics & Pricing

- **Free Lead Photo Check:** [https://thecitadelapp.com/lead-photo-check](https://thecitadelapp.com/lead-photo-check) — one uploaded photo, one first-frame signal, no sign-in or payment required.
- **Full Profile Upgrade ([Pricing](https://thecitadelapp.com/pricing)):** `$24.99` one-time purchase (30 Intel credits — covers 1 Full Profile Audit at 15 credits plus 1 Post-Reshoot Verification Check, or up to 3 Photo Forge photos).
- **Private Profile Signal Audit:** [https://thecitadelapp.com/dating-profile-audit/start](https://thecitadelapp.com/dating-profile-audit/start)

---

## Verify Live with `curl`

Run the included smoke-test script (no token required):

```bash
chmod +x ./examples/verify-mcp.sh
./examples/verify-mcp.sh
```

Direct `curl` example for `citadel_evaluate_profile_readiness`:

```bash
curl -sS -X POST https://thecitadelapp.com/api/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "citadel_evaluate_profile_readiness",
      "arguments": {
        "photoCount": 4,
        "soloClearLeadPhoto": true,
        "promptCount": 3
      }
    }
  }'
```

---

## Repository Contents

- [`server.json`](./server.json) — Official MCP Registry manifest (`2025-12-11` schema, version `1.0.0`)
- [`.cursor/mcp.json`](./.cursor/mcp.json) — Cursor Streamable HTTP MCP configuration
- [`claude_desktop_config.json`](./claude_desktop_config.json) — Claude Desktop `mcp-remote` configuration
- [`examples/verify-mcp.sh`](./examples/verify-mcp.sh) — Executable `curl` smoke-test script
- [`LICENSE`](./LICENSE) — MIT License

---

## Publisher, Support & Policies

- **Publisher:** The Citadel Operations
- **Support:** [support@thecitadelapp.com](mailto:support@thecitadelapp.com)
- **Policies:** [Privacy Policy](https://thecitadelapp.com/privacy) · [Terms of Service](https://thecitadelapp.com/terms)
- **License:** [MIT](./LICENSE)

## Zero-Install Stdio Bridge (`npx`)

For stdio-only MCP clients (like Claude Desktop), connect without cloning or managing dependencies:

```json
{
  "mcpServers": {
    "thecitadelapp-mcp": {
      "command": "npx",
      "args": [
        "-y",
        "github:venkork/citadel-mcp"
      ]
    }
  }
}
```

Or run directly via terminal: `npx -y github:venkork/citadel-mcp` (package ID: `thecitadelapp-mcp@1.0.0`).
