#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# Set required environment variables
export FCC_CODEX_API_KEY="freecc"
export OPENAI_BASE_URL="http://127.0.0.1:8082/v1"

# Use Codex with custom config
codex \
  -c 'model_provider="fcc"' \
  -c 'model_providers.fcc.name="Free Claude Code"' \
  -c 'model_providers.fcc.base_url="http://127.0.0.1:8082/v1"' \
  -c 'model_providers.fcc.env_key="FCC_CODEX_API_KEY"' \
  -c 'model_providers.fcc.wire_api="responses"' \
  "$@"
