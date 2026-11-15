#!/usr/bin/env bash
set -euo pipefail

MCP_URL="${CITADEL_MCP_URL:-https://thecitadelapp.com/api/mcp}"
WELL_KNOWN_URL="${CITADEL_WELL_KNOWN_URL:-https://thecitadelapp.com/.well-known/mcp.json}"

echo "Verifying The Citadel Remote MCP endpoint: ${MCP_URL}"
echo ""

echo "1) GET /.well-known/mcp.json..."
curl -fsS "${WELL_KNOWN_URL}" | head -c 500
echo ""
echo ""

echo "2) JSON-RPC initialize..."
INIT_RESP="$(curl -fsS -X POST "${MCP_URL}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2025-03-26",
      "capabilities": {},
      "clientInfo": { "name": "citadel-mcp-verify", "version": "1.0.0" }
    }
  }')"
echo "${INIT_RESP}" | head -c 500
echo ""
echo ""

echo "3) JSON-RPC tools/list..."
TOOLS_RESP="$(curl -fsS -X POST "${MCP_URL}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/list",
    "params": {}
  }')"

if command -v python3 >/dev/null 2>&1; then
  TOOLS_RESP_JSON="${TOOLS_RESP}" python3 - <<'PY'
import json, os, sys
data = json.loads(os.environ["TOOLS_RESP_JSON"])
tools = data.get("result", {}).get("tools", [])
if not tools:
    print("No tools returned", file=sys.stderr)
    sys.exit(1)
print(f"Discovered {len(tools)} public tool(s):")
for t in tools:
    print(f"  - {t.get('name')}")
PY
else
  echo "${TOOLS_RESP}" | head -c 600
fi
echo ""

echo "4) Smoke test: citadel_platform_status..."
STATUS_RESP="$(curl -fsS -X POST "${MCP_URL}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 3,
    "method": "tools/call",
    "params": {
      "name": "citadel_platform_status",
      "arguments": {}
    }
  }')"

if command -v python3 >/dev/null 2>&1; then
  STATUS_RESP_JSON="${STATUS_RESP}" python3 - <<'PY'
import json, os, sys
data = json.loads(os.environ["STATUS_RESP_JSON"])
if "error" in data:
    print("citadel_platform_status error:", data["error"], file=sys.stderr)
    sys.exit(1)
sc = data.get("result", {}).get("structuredContent", {})
print("  status:", sc.get("status"), "| version:", sc.get("version"), "| protocols:", sc.get("protocols"))
PY
else
  echo "${STATUS_RESP}" | head -c 500
fi
echo ""

echo "5) Smoke test: citadel_get_lead_photo_rubric..."
RUBRIC_RESP="$(curl -fsS -X POST "${MCP_URL}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 4,
    "method": "tools/call",
    "params": {
      "name": "citadel_get_lead_photo_rubric",
      "arguments": { "platform": "hinge" }
    }
  }')"

if command -v python3 >/dev/null 2>&1; then
  RUBRIC_RESP_JSON="${RUBRIC_RESP}" python3 - <<'PY'
import json, os, sys
data = json.loads(os.environ["RUBRIC_RESP_JSON"])
if "error" in data:
    print("citadel_get_lead_photo_rubric error:", data["error"], file=sys.stderr)
    sys.exit(1)
sc = data.get("result", {}).get("structuredContent", {})
dims = sc.get("dimensions", [])
print("  platform:", sc.get("platform"), "| rubricVersion:", sc.get("rubricVersion"), "| dimensions:", len(dims))
PY
else
  echo "${RUBRIC_RESP}" | head -c 500
fi
echo ""

echo "6) Smoke test: citadel_evaluate_profile_readiness..."
READY_RESP="$(curl -fsS -X POST "${MCP_URL}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 5,
    "method": "tools/call",
    "params": {
      "name": "citadel_evaluate_profile_readiness",
      "arguments": { "photoCount": 4, "soloClearLeadPhoto": true, "promptCount": 3 }
    }
  }')"

if command -v python3 >/dev/null 2>&1; then
  READY_RESP_JSON="${READY_RESP}" python3 - <<'PY'
import json, os, sys
data = json.loads(os.environ["READY_RESP_JSON"])
if "error" in data:
    print("citadel_evaluate_profile_readiness error:", data["error"], file=sys.stderr)
    sys.exit(1)
sc = data.get("result", {}).get("structuredContent", {})
print("  score:", sc.get("score"), "| verdict:", sc.get("verdict"), "| issues:", len(sc.get("issues", [])))
PY
else
  echo "${READY_RESP}" | head -c 500
fi

echo ""
echo "Verification completed."
