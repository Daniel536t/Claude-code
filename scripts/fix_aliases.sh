#!/bin/bash
echo "=== Fixing Aliases ==="

# Remove any conflicting aliases
unalias claude 2>/dev/null
unalias ask 2>/dev/null
unalias agent 2>/dev/null

# Add correct aliases
cat >> ~/.bashrc << 'ALIASEOF'

# ===== FCC ALIASES (FIXED) =====
# NEVER use 'claude' directly - it requires Anthropic login!
# Always use 'fcc-claude' or the 'claude' alias below

alias claude='fcc-claude'           # Correct: uses FCC proxy
alias claude-p='fcc-claude -p'      # Shortcut for prompting

alias ask='~/llm_launch.sh'         # llm.py full chain
alias ask-fast='~/llm_launch.sh --fast'  # llm.py fastest only

alias agent='~/agent_final.sh'      # Universal agent
alias status='~/status_accurate.sh' # Check status
alias test='~/test_working.sh'      # Test everything

alias kimi='~/switch.sh kimi'       # Switch to fastest
alias nemotron='~/switch.sh nemotron'
alias deepseek='~/switch.sh deepseek'

alias restart='~/fcc_working.sh'    # Restart proxy

echo "✅ FCC aliases loaded - use 'claude' (not 'claude' directly!)"
ALIASEOF

# Reload
source ~/.bashrc

echo "✅ Aliases fixed!"
echo ""
echo "Now use:"
echo "  claude -p 'Write a Python function'  # This will use FCC proxy"
echo "  ask 'What is AI?'                    # llm.py full chain"
echo "  status                               # Check everything"
