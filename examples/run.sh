#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_automation_keys info
PYTHONPATH=src python -m gbt_automation_keys check --payload '{}'
PYTHONPATH=src python -m gbt_automation_keys run   --payload '{}'
