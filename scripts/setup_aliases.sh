#!/bin/bash
echo "=== Setting up permanent aliases ==="

# Remove old alias lines from bashrc
sed -i '/# ===== FCC ALIASES/,/# ==== FCC ALIASES/d' ~/.bashrc 2>/dev/null

# Add fresh aliases
cat >> ~/.bashrc << 'ALIASEOF'

# ===== FCC ALIASES =====
alias claude='fcc-claude'
alias ask='~/llm_launch.sh'
alias ask-fast='~/llm_launch.sh --fast'
alias agent='~/agent_final.sh'
alias status='~/status_accurate.sh'
alias test='~/test_working.sh'
alias kimi='~/switch.sh kimi'
alias nemotron='~/switch.sh nemotron'
alias deepseek='~/switch.sh deepseek'
alias restart='~/fcc_working.sh'

echo "✅ FCC aliases loaded"
ALIASEOF

# Also create .bash_aliases for Ubuntu
cat > ~/.bash_aliases << 'ALIASEOF'
# FCC Aliases
alias claude='fcc-claude'
alias ask='~/llm_launch.sh'
alias ask-fast='~/llm_launch.sh --fast'
alias agent='~/agent_final.sh'
alias status='~/status_accurate.sh'
alias test='~/test_working.sh'
alias kimi='~/switch.sh kimi'
alias nemotron='~/switch.sh nemotron'
alias deepseek='~/switch.sh deepseek'
alias restart='~/fcc_working.sh'
ALIASEOF

# Source everything
source ~/.bashrc
source ~/.bash_aliases 2>/dev/null

echo "✅ Aliases setup complete!"
echo ""
echo "Testing aliases:"
alias | grep -E "claude|ask|agent|status" | head -5

echo ""
echo "Now use:"
echo "  claude -p 'Write a function'"
echo "  ask 'What is AI?'"
echo "  status"
