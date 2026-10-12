#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
[[ -x .venv/bin/python ]] || { echo "Run ./setup_unix.sh first"; exit 1; }
(cd python_engine && ../.venv/bin/python -m uvicorn app:app --host 127.0.0.1 --port 8000) &
API_PID=$!
(.venv/bin/python -m http.server 8080 --bind 127.0.0.1 --directory site) &
WEB_PID=$!
trap 'kill "$API_PID" "$WEB_PID" 2>/dev/null || true' EXIT INT TERM
sleep 2
echo "Frontend: http://127.0.0.1:8080"
echo "API health: http://127.0.0.1:8000/health"
wait
