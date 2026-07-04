#!/bin/bash
echo "╔══════════════════════════════════════════╗"
echo "║   FCC Menu - Choose an option           ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "1) Claude Code - Write code"
echo "2) llm.py (fastest) - Quick questions"
echo "3) llm.py (full chain) - Complex questions"
echo "4) Universal agent - Auto fallback"
echo "5) Switch to Kimi (fastest)"
echo "6) Switch to Nemotron"
echo "7) Switch to DeepSeek"
echo "8) Check status"
echo "9) Test everything"
echo "0) Exit"
echo ""
read -p "Enter choice: " choice

case $choice in
    1) read -p "Enter your prompt: " prompt; fcc-claude -p "$prompt" ;;
    2) read -p "Enter your prompt: " prompt; ~/llm_launch.sh "$prompt" --fast ;;
    3) read -p "Enter your prompt: " prompt; ~/llm_launch.sh "$prompt" ;;
    4) read -p "Enter your prompt: " prompt; ~/agent_final.sh "$prompt" ;;
    5) ~/switch.sh kimi ;;
    6) ~/switch.sh nemotron ;;
    7) ~/switch.sh deepseek ;;
    8) ~/status_accurate.sh ;;
    9) ~/test_working.sh ;;
    0) exit 0 ;;
    *) echo "Invalid choice" ;;
esac
