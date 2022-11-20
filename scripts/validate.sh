#!/bin/bash

BLUE='\033[0;34m'
NC='\033[0m' # No Color

cd ../

action="${BLUE}Install Dependencies${NC}"
echo "┌───────────────────────────────────────┐"
echo -e "│ ${action}                  │"
echo "└───────────────────────────────────────┘"
sh ./pub_get.sh


action="${BLUE}Check Formatting${NC}"
echo "┌───────────────────────────────────────┐"
echo -e "│ ${action}                      │"
echo "└───────────────────────────────────────┘"
dart format . -l 100 --fix
echo ""


action="${BLUE}Analyze${NC}"
echo "┌───────────────────────────────────────┐"
echo -e "│ ${action}                               │"
echo "└───────────────────────────────────────┘"
dart analyze --fatal-infos --fatal-warnings
echo ""


action="${BLUE}Run Tests${NC}"
echo "┌───────────────────────────────────────┐"
echo -e "│ ${action}                             │"
echo "└───────────────────────────────────────┘"
dart test --color -r expanded
echo ""


action="${BLUE}Pub.dev Analysis${NC}"
echo "┌───────────────────────────────────────┐"
echo -e "│ ${action}                      │"
echo "└───────────────────────────────────────┘"
dart pub global run pana -l 100 --exit-code-threshold 30
echo ""
