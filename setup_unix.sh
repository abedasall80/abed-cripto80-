#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PYTHON_BIN="${PYTHON_BIN:-python3}"
"$PYTHON_BIN" -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r python_engine/requirements.txt pytest
.venv/bin/python -m py_compile python_engine/app.py python_engine/quant_engine/indicators.py
echo "Setup complete. Run ./start_unix.sh"
