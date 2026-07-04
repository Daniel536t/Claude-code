#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
export FCC_CODEX_API_KEY="freecc"

# Codex requires --skip-git-repo-check after 'exec' or before
# The correct usage is: codex exec --skip-git-repo-check "prompt"
# Or: codex --skip-git-repo-check exec "prompt"

# Check if we're in exec mode
if [[ "$1" == "exec" ]]; then
    shift
    # Add --skip-git-repo-check after exec
    codex exec --skip-git-repo-check \
        -c 'model_provider="fcc"' \
        -c 'model_providers.fcc.name="Free Claude Code"' \
        -c 'model_providers.fcc.base_url="http://127.0.0.1:8082/v1"' \
        -c 'model_providers.fcc.env_key="FCC_CODEX_API_KEY"' \
        -c 'model_providers.fcc.wire_api="responses"' \
        "$@"
else
    # Interactive mode or other commands
    codex --skip-git-repo-check \
        -c 'model_provider="fcc"' \
        -c 'model_providers.fcc.name="Free Claude Code"' \
        -c 'model_providers.fcc.base_url="http://127.0.0.1:8082/v1"' \
        -c 'model_providers.fcc.env_key="FCC_CODEX_API_KEY"' \
        -c 'model_providers.fcc.wire_api="responses"' \
        "$@"
fi
