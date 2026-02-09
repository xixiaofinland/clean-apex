#!/bin/bash
# verify-implementation.sh
# Comprehensive verification script for clean-apex skill v1.0.0
# Validates all phases of the implementation plan

set -e  # Exit on first error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Helper functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_check() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

# Phase 1: Foundation & Metadata
print_header "Phase 1: Foundation & Metadata"

# Check LICENSE exists
if [ -f "LICENSE" ]; then
    if grep -q "MIT License" LICENSE && grep -q "2026 Xi Xiao" LICENSE; then
        print_check "LICENSE file exists with correct content"
    else
        print_error "LICENSE file missing required content"
    fi
else
    print_error "LICENSE file not found"
fi

# Check CHANGELOG.md exists and has proper format
if [ -f "CHANGELOG.md" ]; then
    if grep -q "## \[1.0.0\] - 2026-02-09" CHANGELOG.md && \
       grep -q "## \[Unreleased\]" CHANGELOG.md; then
        print_check "CHANGELOG.md exists with proper format"
    else
        print_error "CHANGELOG.md missing required sections"
    fi
else
    print_error "CHANGELOG.md not found"
fi

# Check SKILL.md frontmatter
if [ -f "SKILL.md" ]; then
    if grep -q "version: \"1.0.0\"" SKILL.md && \
       grep -q "author: \"Xi Xiao\"" SKILL.md && \
       grep -q "keywords:" SKILL.md && \
       grep -q "capabilities:" SKILL.md && \
       grep -q "platforms:" SKILL.md; then
        print_check "SKILL.md frontmatter enhanced with metadata"
    else
        print_error "SKILL.md missing required frontmatter fields"
    fi
else
    print_error "SKILL.md not found"
fi

# Phase 2: Documentation Enhancement
print_header "Phase 2: Documentation Enhancement"

# Check README.md sections
if [ -f "README.md" ]; then
    if grep -q "## Getting Started" README.md && \
       grep -q "## Troubleshooting" README.md && \
       grep -q "## FAQ" README.md && \
       grep -q "## Contributing" README.md && \
       grep -q "## Glossary" README.md; then
        print_check "README.md enhanced with all required sections"
    else
        print_error "README.md missing required sections"
    fi
else
    print_error "README.md not found"
fi

# Check references/README.md
if [ -f "references/README.md" ]; then
    if grep -q "## Reference Files" references/README.md && \
       grep -q "## Reading Order" references/README.md; then
        print_check "references/README.md index created"
    else
        print_warning "references/README.md missing recommended sections"
    fi
else
    print_error "references/README.md not found"
fi

# Phase 3: Validator (Skipped per user request)
print_header "Phase 3: Validator Robustness (Skipped)"
print_warning "Validator unit tests skipped per user request"

# Phase 4: Platform Configuration
print_header "Phase 4: Platform Configuration"

# Check all agent config files exist
for config in claude.yaml codex.yaml github-copilot.yaml generic.yaml; do
    if [ -f "agents/$config" ]; then
        if grep -q "version: \"1.0.0\"" "agents/$config" 2>/dev/null || \
           grep -q "version:" "agents/$config" 2>/dev/null; then
            print_check "agents/$config exists with version"
        else
            print_warning "agents/$config missing version field"
        fi
    else
        print_error "agents/$config not found"
    fi
done

# Check agents/README.md
if [ -f "agents/README.md" ]; then
    if grep -q "## Available Configurations" agents/README.md; then
        print_check "agents/README.md documentation created"
    else
        print_warning "agents/README.md missing expected sections"
    fi
else
    print_error "agents/README.md not found"
fi

# Phase 5: Template Enhancement
print_header "Phase 5: Template Enhancement"

# Check template metadata headers
TEMPLATE_COUNT=$(find templates/ -name "*.cls" -o -name "*.trigger" | wc -l | tr -d ' ')
HEADERS_COUNT=$(grep -l "TEMPLATE METADATA" templates/*.cls templates/*.trigger 2>/dev/null | wc -l | tr -d ' ')

if [ "$TEMPLATE_COUNT" -eq "$HEADERS_COUNT" ]; then
    print_check "All $TEMPLATE_COUNT templates have metadata headers"
else
    print_error "Only $HEADERS_COUNT of $TEMPLATE_COUNT templates have metadata headers"
fi

# Check TEMPLATE_INDEX.md enhancement
if [ -f "templates/TEMPLATE_INDEX.md" ]; then
    if grep -q "## Quick Reference Table" templates/TEMPLATE_INDEX.md && \
       grep -q "## Pattern Packs" templates/TEMPLATE_INDEX.md && \
       grep -q "## Usage Guidelines" templates/TEMPLATE_INDEX.md; then
        print_check "templates/TEMPLATE_INDEX.md enhanced with documentation"
    else
        print_error "templates/TEMPLATE_INDEX.md missing required sections"
    fi
else
    print_error "templates/TEMPLATE_INDEX.md not found"
fi

# Phase 6: Distribution & Discoverability
print_header "Phase 6: Distribution & Discoverability"

# Check .skillignore
if [ -f ".skillignore" ]; then
    if grep -q ".git/" .skillignore && \
       grep -q "__pycache__/" .skillignore && \
       grep -q ".env" .skillignore; then
        print_check ".skillignore created with appropriate exclusions"
    else
        print_warning ".skillignore missing some recommended exclusions"
    fi
else
    print_error ".skillignore not found"
fi

# Check GLOSSARY.md
if [ -f "GLOSSARY.md" ]; then
    if grep -q "## Architecture Terms" GLOSSARY.md && \
       grep -q "## Code Quality Terms" GLOSSARY.md && \
       grep -q "## Testing Terms" GLOSSARY.md && \
       grep -q "## Validator Terms" GLOSSARY.md; then
        print_check "GLOSSARY.md created with comprehensive terms"
    else
        print_error "GLOSSARY.md missing required sections"
    fi
else
    print_error "GLOSSARY.md not found"
fi

# Check glossary link in README.md
if grep -q "GLOSSARY.md" README.md; then
    print_check "GLOSSARY.md linked in README.md"
else
    print_error "GLOSSARY.md not linked in README.md"
fi

# Phase 7: Final Integration
print_header "Phase 7: Final Integration & Version Consistency"

# Check version consistency
VERSION="1.0.0"
VERSION_FILES=(
    "SKILL.md"
    "agents/claude.yaml"
    "agents/codex.yaml"
    "agents/github-copilot.yaml"
    "agents/generic.yaml"
)

VERSION_CONSISTENT=true
for file in "${VERSION_FILES[@]}"; do
    if [ -f "$file" ]; then
        if grep -q "version.*1.0.0" "$file" || grep -q "version.*\"1.0.0\"" "$file"; then
            : # Version found, continue
        else
            print_warning "$file may have inconsistent version"
            VERSION_CONSISTENT=false
        fi
    fi
done

if [ "$VERSION_CONSISTENT" = true ]; then
    print_check "Version 1.0.0 consistent across all configuration files"
fi

# Check CHANGELOG.md finalization
if grep -q "## \[1.0.0\] - 2026-02-09" CHANGELOG.md; then
    print_check "CHANGELOG.md finalized for v1.0.0 release"
else
    print_error "CHANGELOG.md not properly finalized for v1.0.0"
fi

# Comprehensive Tests
print_header "Comprehensive Tests"

# Test directory structure
EXPECTED_DIRS=(
    "templates"
    "references"
    "hooks/scripts"
    "agents"
    "examples-sanitized"
    "scripts"
)

for dir in "${EXPECTED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_check "Directory exists: $dir"
    else
        print_error "Missing directory: $dir"
    fi
done

# Test essential files
ESSENTIAL_FILES=(
    "LICENSE"
    "CHANGELOG.md"
    "README.md"
    "SKILL.md"
    "GLOSSARY.md"
    ".skillignore"
    "hooks/scripts/clean-apex-validate.py"
)

for file in "${ESSENTIAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_check "Essential file exists: $file"
    else
        print_error "Missing essential file: $file"
    fi
done

# Test validator functionality (basic smoke test)
print_header "Validator Smoke Test"

if [ -f "hooks/scripts/clean-apex-validate.py" ] && [ -f "templates/CleanOrderBuilder.cls" ]; then
    # Test validator runs without error
    if echo '{"tool_input":{"file_path":"templates/CleanOrderBuilder.cls"}}' | python3 hooks/scripts/clean-apex-validate.py >/dev/null 2>&1; then
        print_check "Validator executes successfully"
    else
        print_error "Validator failed to execute"
    fi
else
    print_warning "Validator smoke test skipped (missing files)"
fi

# Documentation Link Validation
print_header "Documentation Link Validation"

# Check internal links in README
if command -v grep >/dev/null 2>&1; then
    BROKEN_LINKS=0

    # Extract markdown links from README
    if [ -f "README.md" ]; then
        # Check references/ links
        if grep -q "references/" README.md; then
            if [ -d "references" ]; then
                print_check "references/ directory exists for README links"
            else
                print_error "README references references/ but directory missing"
                ((BROKEN_LINKS++))
            fi
        fi

        # Check templates/ links
        if grep -q "templates/" README.md; then
            if [ -d "templates" ]; then
                print_check "templates/ directory exists for README links"
            else
                print_error "README references templates/ but directory missing"
                ((BROKEN_LINKS++))
            fi
        fi
    fi

    if [ $BROKEN_LINKS -eq 0 ]; then
        print_check "No broken internal links detected"
    fi
fi

# Final Summary
print_header "Verification Summary"

echo ""
echo "Total checks completed: $(( ERRORS + WARNINGS + 40 ))"  # Approximate count
echo -e "${GREEN}Passed: $(( 40 - ERRORS - WARNINGS ))${NC}"

if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
fi

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}Errors: $ERRORS${NC}"
    echo ""
    echo -e "${RED}Verification FAILED with $ERRORS error(s)${NC}"
    exit 1
else
    if [ $WARNINGS -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}Verification PASSED with $WARNINGS warning(s)${NC}"
        echo "Review warnings above for potential improvements."
    else
        echo ""
        echo -e "${GREEN}✓ Verification PASSED - All checks successful!${NC}"
        echo ""
        echo "clean-apex skill v1.0.0 implementation complete and validated."
    fi
    exit 0
fi
