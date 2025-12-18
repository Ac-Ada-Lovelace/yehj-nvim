#!/bin/bash
# Verify C# Overseer setup

echo "🔍 Verifying C# Overseer Setup..."
echo

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success=0
fail=0

check() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((success++))
    else
        echo -e "${RED}✗${NC} $1"
        ((fail++))
    fi
}

# Check .NET SDK
echo "1. Checking .NET SDK..."
dotnet --version > /dev/null 2>&1
check ".NET SDK installed"

# Check F# Interactive
echo "2. Checking F# Interactive..."
dotnet fsi --help > /dev/null 2>&1
check "F# Interactive available"

# Check run scripts
echo "3. Checking run scripts..."
if [ -f ~/test/run-csharp.sh ]; then
    echo -e "${GREEN}✓${NC} run-csharp.sh exists"
    ((success++))

    if [ -x ~/test/run-csharp.sh ]; then
        echo -e "${GREEN}✓${NC} run-csharp.sh is executable"
        ((success++))
    else
        echo -e "${RED}✗${NC} run-csharp.sh is not executable"
        echo "  Fix: chmod +x ~/test/run-csharp.sh"
        ((fail++))
    fi
else
    echo -e "${RED}✗${NC} run-csharp.sh not found"
    ((fail++))
fi

if [ -f ~/test/run-fsharp.sh ]; then
    echo -e "${GREEN}✓${NC} run-fsharp.sh exists"
    ((success++))

    if [ -x ~/test/run-fsharp.sh ]; then
        echo -e "${GREEN}✓${NC} run-fsharp.sh is executable"
        ((success++))
    else
        echo -e "${YELLOW}⚠${NC} run-fsharp.sh is not executable"
        echo "  Fix: chmod +x ~/test/run-fsharp.sh"
    fi
else
    echo -e "${YELLOW}⚠${NC} run-fsharp.sh not found (optional)"
fi

# Check Neovim config
echo "4. Checking Neovim configuration..."
if [ -d ~/.config/nvim/lua/overseer/template ]; then
    echo -e "${GREEN}✓${NC} Overseer template directory exists"
    ((success++))
else
    echo -e "${RED}✗${NC} Overseer template directory not found"
    ((fail++))
fi

# Check templates
templates=(
    "csharp-single-file.lua"
    "csharp-with-input.lua"
    "fsharp-script.lua"
)

for template in "${templates[@]}"; do
    if [ -f ~/.config/nvim/lua/overseer/template/"$template" ]; then
        echo -e "${GREEN}✓${NC} Template: $template"
        ((success++))
    else
        echo -e "${RED}✗${NC} Template missing: $template"
        ((fail++))
    fi
done

# Check test files
echo "5. Checking test files..."
if [ -f ~/test/nvim-test.cs ]; then
    echo -e "${GREEN}✓${NC} Test file created"
    ((success++))
else
    echo -e "${YELLOW}⚠${NC} Test file not found (optional)"
fi

# Summary
echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Summary:"
echo -e "  ${GREEN}Success: $success${NC}"
if [ $fail -gt 0 ]; then
    echo -e "  ${RED}Failed:  $fail${NC}"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $fail -eq 0 ]; then
    echo
    echo -e "${GREEN}✓ Setup complete!${NC}"
    echo
    echo "Next steps:"
    echo "  1. Restart Neovim"
    echo "  2. Open a C# file: nvim ~/test/nvim-test.cs"
    echo "  3. Run: :OverseerRun"
    echo "  4. Select: 'C#: Run single file'"
    echo
    echo "Documentation: ~/.config/nvim/CSHARP-TASKS.md"
    exit 0
else
    echo
    echo -e "${RED}✗ Setup incomplete${NC}"
    echo "Please fix the issues above and run again."
    exit 1
fi
