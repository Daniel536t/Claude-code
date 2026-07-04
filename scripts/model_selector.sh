#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# Configuration file
CONFIG_FILE=~/.fcc/.env
BACKUP_DIR=~/.fcc/backups

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Provider definitions
declare -A PROVIDERS

# NVIDIA NIM models
PROVIDERS["nim_kimi"]="nvidia_nim/moonshotai/kimi-k2.6|NVIDIA NIM - Kimi K2.6 (Fastest)"
PROVIDERS["nim_glm52"]="nvidia_nim/z-ai/glm-5.2|NVIDIA NIM - GLM 5.2"
PROVIDERS["nim_nemotron"]="nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b|NVIDIA NIM - Nemotron 3 Ultra"
PROVIDERS["nim_deepseek"]="nvidia_nim/deepseek-ai/deepseek-v4-flash|NVIDIA NIM - DeepSeek V4 Flash"
PROVIDERS["nim_glm51"]="nvidia_nim/z-ai/glm-5.1|NVIDIA NIM - GLM 5.1"

# FreeTheAi models (requires daily Discord check-in)
PROVIDERS["fta_deepseek"]="opc/deepseek-v4-flash-free|FreeTheAi - DeepSeek V4 Flash"
PROVIDERS["fta_bigpickle"]="opc/big-pickle|FreeTheAi - Big Pickle"
PROVIDERS["fta_mimo"]="opc/mimo-v2.5-free|FreeTheAi - Mimo V2.5"
PROVIDERS["fta_nemotron"]="opc/nemotron-3-ultra-free|FreeTheAi - Nemotron 3 Ultra"
PROVIDERS["fta_north"]="opc/north-mini-code-free|FreeTheAi - North Mini Code"
PROVIDERS["fta_vova_opus"]="vova/claude-opus-4-8|FreeTheAi - Claude Opus 4.8"
PROVIDERS["fta_vova_sonnet"]="vova/claude-sonnet-4-6|FreeTheAi - Claude Sonnet 4.6"
PROVIDERS["fta_vova_gemini"]="vova/gemini-3.5-flash|FreeTheAi - Gemini 3.5 Flash"
PROVIDERS["fta_vova_glm"]="vova/glm-5.2|FreeTheAi - GLM 5.2"
PROVIDERS["fta_vova_kimi"]="vova/kimi-k2.7-code|FreeTheAi - Kimi K2.7"
PROVIDERS["fta_olm_deepseek"]="olm/deepseek-v4-pro|FreeTheAi - DeepSeek V4 Pro"
PROVIDERS["fta_olm_kimi"]="olm/kimi-k2.7-code|FreeTheAi - Kimi K2.7 Code"
PROVIDERS["fta_glm5"]="glm/glm-5|FreeTheAi - GLM 5"
PROVIDERS["fta_glm52"]="glm/glm-5.2|FreeTheAi - GLM 5.2"
PROVIDERS["fta_glm46"]="glm/glm-4.6|FreeTheAi - GLM 4.6"
PROVIDERS["fta_bbl_gemini"]="bbl/gemini-3.5-flash|FreeTheAi - Gemini 3.5 Flash"
PROVIDERS["fta_bbl_grok"]="bbl/grok-4.1-fast-non-reasoning|FreeTheAi - Grok 4.1"
PROVIDERS["fta_kai_openrouter"]="kai/openrouter/free|FreeTheAi - OpenRouter Free"
PROVIDERS["fta_kai_nemotron"]="kai/nvidia/nemotron-3-super-120b-a12b:free|FreeTheAi - Nemotron 3 Super"

# Sambanova models
PROVIDERS["sn_deepseek"]="DeepSeek-V3.2|Sambanova - DeepSeek V3.2"
PROVIDERS["sn_llama"]="Meta-Llama-3.3-70B-Instruct|Sambanova - Llama 3.3 70B"
PROVIDERS["sn_gemma"]="gemma-4-31B-it|Sambanova - Gemma 4 31B"

# Cloudflare models
PROVIDERS["cf_glm52"]="cloudflare/zai-org/glm-5.2|Cloudflare - GLM 5.2"

function show_menu() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Free Claude Code - Model Selector    ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Current Model:${NC} $(grep "^MODEL=" $CONFIG_FILE | cut -d= -f2)"
    echo ""
    echo -e "${GREEN}Select a model to use:${NC}"
    echo ""
    
    local i=1
    declare -A temp_keys
    
    # NVIDIA NIM
    echo -e "${BLUE}┌── NVIDIA NIM (Fastest) ─────────────────┐${NC}"
    for key in "${!PROVIDERS[@]}"; do
        if [[ $key == nim_* ]]; then
            IFS='|' read -r model desc <<< "${PROVIDERS[$key]}"
            printf "  ${GREEN}%2d)${NC} %-40s\n" $i "$desc"
            temp_keys[$i]="$key"
            ((i++))
        fi
    done
    
    echo -e "${BLUE}├── FreeTheAi (Community) ────────────────┤${NC}"
    for key in "${!PROVIDERS[@]}"; do
        if [[ $key == fta_* ]]; then
            IFS='|' read -r model desc <<< "${PROVIDERS[$key]}"
            printf "  ${GREEN}%2d)${NC} %-40s\n" $i "$desc"
            temp_keys[$i]="$key"
            ((i++))
        fi
    done
    
    echo -e "${BLUE}├── Sambanova (Fallback) ─────────────────┤${NC}"
    for key in "${!PROVIDERS[@]}"; do
        if [[ $key == sn_* ]]; then
            IFS='|' read -r model desc <<< "${PROVIDERS[$key]}"
            printf "  ${GREEN}%2d)${NC} %-40s\n" $i "$desc"
            temp_keys[$i]="$key"
            ((i++))
        fi
    done
    
    echo -e "${BLUE}├── Cloudflare (Edge) ─────────────────────┤${NC}"
    for key in "${!PROVIDERS[@]}"; do
        if [[ $key == cf_* ]]; then
            IFS='|' read -r model desc <<< "${PROVIDERS[$key]}"
            printf "  ${GREEN}%2d)${NC} %-40s\n" $i "$desc"
            temp_keys[$i]="$key"
            ((i++))
        fi
    done
    
    echo -e "${BLUE}└──────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "  ${YELLOW}0)${NC} Exit / Cancel"
    echo -e "  ${YELLOW}r)${NC} Restart proxy after change"
    echo -e "  ${YELLOW}s)${NC} Show current status"
    echo ""
    echo -n "Enter choice: "
}

function switch_model() {
    local key=$1
    IFS='|' read -r model desc <<< "${PROVIDERS[$key]}"
    
    echo ""
    echo -e "${YELLOW}Switching to:${NC} $desc"
    echo -e "${YELLOW}Model slug:${NC} $model"
    
    # Backup current config
    mkdir -p $BACKUP_DIR
    cp $CONFIG_FILE $BACKUP_DIR/.env.backup.$(date +%Y%m%d_%H%M%S)
    
    # Update MODEL
    sed -i "s/^MODEL=.*/MODEL=$model/" $CONFIG_FILE
    
    # Check if this is a FreeTheAi model and update FTA_MODEL
    if [[ $key == fta_* ]]; then
        sed -i "s/^FTA_MODEL=.*/FTA_MODEL=$model/" $CONFIG_FILE
    fi
    
    echo -e "${GREEN}✅ Model updated in config${NC}"
    
    # Ask to restart
    read -p "Restart proxy now? (y/n): " restart
    if [[ $restart == "y" || $restart == "Y" ]]; then
        ~/fcc_restart.sh
        echo ""
        echo -e "${GREEN}✅ Proxy restarted with new model${NC}"
    else
        echo -e "${YELLOW}⚠️  Model changed but proxy not restarted. Run ~/fcc_restart.sh when ready.${NC}"
    fi
}

function show_status() {
    echo ""
    echo -e "${BLUE}=== Current Status ===${NC}"
    echo ""
    echo -e "Model: $(grep "^MODEL=" $CONFIG_FILE | cut -d= -f2)"
    echo -e "Opus:  $(grep "^MODEL_OPUS=" $CONFIG_FILE | cut -d= -f2)"
    echo -e "Sonnet: $(grep "^MODEL_SONNET=" $CONFIG_FILE | cut -d= -f2)"
    echo -e "Haiku:  $(grep "^MODEL_HAIKU=" $CONFIG_FILE | cut -d= -f2)"
    echo ""
    echo -e "Proxy: $(pgrep -f fcc-server > /dev/null && echo "${GREEN}Running${NC}" || echo "${RED}Stopped${NC}")"
    echo ""
    read -p "Press Enter to continue..."
}

# Main loop
while true; do
    show_menu
    read choice
    
    case $choice in
        0|q|Q)
            echo "Exiting..."
            exit 0
            ;;
        r|R)
            ~/fcc_restart.sh
            read -p "Press Enter to continue..."
            ;;
        s|S)
            show_status
            ;;
        [0-9]*)
            if [[ -n "${temp_keys[$choice]}" ]]; then
                switch_model "${temp_keys[$choice]}"
                read -p "Press Enter to continue..."
            else
                echo -e "${RED}Invalid choice${NC}"
                sleep 1
            fi
            ;;
        *)
            echo -e "${RED}Invalid input${NC}"
            sleep 1
            ;;
    esac
done
