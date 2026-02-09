#!/usr/bin/env python3
"""
Clean-Apex Validation Hook

Lightweight, readability-focused checks for clean-apex. This is NOT a full
compiler or security/performance validator.
"""

import json
import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple

APEX_EXTENSIONS = {".cls", ".trigger"}

# Keep these minimal and easy to extend
OO_SUFFIXES = [
    "Builder",
    "Setter",
    "Manager",
    "Validator",
    "Enricher",
    "Mapper",
    "Provider",
    "Factory",
    "Handler",
    "Processor",
]
ENTRYPOINT_HINTS = ["Rest", "Controller", "Batch", "Schedulable", "Queueable", "Trigger"]
SERVICE_SUFFIX = "Service"
SELECTOR_HINTS = ["Selector", "Query"]

DML_PATTERNS = [
    r"\binsert\b",
    r"\bupdate\b",
    r"\bdelete\b",
    r"\bupsert\b",
    r"\bundelete\b",
    r"Database\.(insert|update|delete|upsert|undelete)",
]

SOQL_PATTERNS = [
    r"\[\s*SELECT\b",
    r"Database\.query\b",
]

BAD_VAR_PREFIXES = ["obj", "str", "id"]
GENERIC_MAP_STEMS = {
    "map",
    "data",
    "result",
    "value",
    "item",
    "items",
    "record",
    "records",
    "object",
    "objects",
}

COMMENT_LINE_PATTERN = re.compile(r"^\s*//")
BLOCK_COMMENT_START_PATTERN = re.compile(r"/\*")
BLOCK_COMMENT_END_PATTERN = re.compile(r"\*/")
JAVADOC_START_PATTERN = re.compile(r"^\s*/\*\*")
SUPPRESSION_PATTERN = re.compile(r"clean-apex:\s*(disable|allow)=")
CODE_LIKE_PATTERN = re.compile(r"[;{}()]")
CLASS_OR_METHOD_PATTERN = re.compile(
    r"\b(class|interface|enum)\b|"
    r"\b(public|private|protected|global)\b[\w<>\s,]*\([^)]*\)\s*\{?"
)


def is_apex_file(file_path: str) -> bool:
    return Path(file_path).suffix.lower() in APEX_EXTENSIONS


def read_file(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except Exception:
        return ""


def load_template_index_map(repo_root: Path) -> Dict[str, str]:
    index_path = repo_root / "clean-apex" / "templates" / "TEMPLATE_INDEX.md"
    if not index_path.exists():
        return {}
    content = read_file(index_path)
    mapping: Dict[str, str] = {}
    for line in content.splitlines():
        if ":" not in line:
            continue
        label, rest = line.split(":", 1)
        label = label.strip().lower()
        filenames = re.findall(r"[A-Za-z0-9_.-]+\.(?:cls|trigger)", rest)
        if not filenames:
            continue
        for fname in filenames:
            if "test" in label:
                mapping[fname] = "test"
            elif "entry" in label:
                mapping[fname] = "entry-point"
            elif "service" in label:
                mapping[fname] = "service"
            elif label.startswith("oo"):
                mapping[fname] = "oo"
            elif "selector" in label or "query" in label:
                mapping[fname] = "selector"
    return mapping


def find_class_name(content: str) -> Optional[str]:
    match = re.search(r"\b(class|interface)\s+([A-Za-z_][A-Za-z0-9_]*)", content)
    if match:
        return match.group(2)
    return None


def parse_suppression_directives(lines: List[str]) -> Tuple[set, Dict[int, set]]:
    file_disabled: set = set()
    line_allowed: Dict[int, set] = {}
    for i, line in enumerate(lines, 1):
        disable_match = re.search(r"clean-apex:\s*disable=([A-Z_,]+)", line)
        if disable_match:
            file_disabled.update(
                part.strip() for part in disable_match.group(1).split(",") if part.strip()
            )

        allow_match = re.search(r"clean-apex:\s*allow=([A-Z_,]+)", line)
        if allow_match:
            line_allowed[i] = {
                part.strip() for part in allow_match.group(1).split(",") if part.strip()
            }
    return file_disabled, line_allowed


def is_reasonable_map_name(var_name: str) -> bool:
    if "To" in var_name or "By" in var_name:
        return True
    if var_name.endswith("Lookup") or var_name.endswith("Index"):
        return True
    if var_name.endswith("Map"):
        stem = var_name[:-3]
        if stem and stem.lower() not in GENERIC_MAP_STEMS:
            return True
    return False


def is_test_class(content: str, class_name: Optional[str]) -> bool:
    if "@IsTest" in content:
        return True
    if class_name and class_name.endswith("Test"):
        return True
    return False


def classify_layer(
    file_path: Path,
    content: str,
    class_name: Optional[str],
    index_map: Dict[str, str],
) -> str:
    mapped = index_map.get(file_path.name)
    if mapped:
        return mapped

    if file_path.suffix.lower() == ".trigger":
        return "entry-point"

    if is_test_class(content, class_name):
        return "test"

    if class_name:
        if "@RestResource" in content:
            return "entry-point"
        if class_name.endswith(SERVICE_SUFFIX):
            return "service"
        if any(class_name.endswith(hint) for hint in SELECTOR_HINTS):
            return "selector"
        if any(hint in class_name for hint in ENTRYPOINT_HINTS):
            return "entry-point"

    # Default to OO layer for unclassified classes
    return "oo"


def collect_issues(content: str, layer: str, class_name: Optional[str]) -> List[Tuple[int, str, str]]:
    issues: List[Tuple[int, str, str]] = []
    lines = content.splitlines()
    file_disabled, line_allowed = parse_suppression_directives(lines)
    emitted_block_comment_noise: set = set()

    def add_issue(line_no: int, code: str, message: str) -> None:
        if code in file_disabled:
            return
        if code in line_allowed.get(line_no, set()):
            return
        issues.append((line_no, code, message))

    # Naming: OO class suffix rule
    if layer == "oo" and class_name:
        if not any(class_name.endswith(suffix) for suffix in OO_SUFFIXES):
            add_issue(1, "OO_NAMING", f"OO class should use role suffix: {', '.join(OO_SUFFIXES)}")

    # Naming: variable prefixes, List/Set suffixes, Map naming
    for i, line in enumerate(lines, 1):
        # Variable prefix rule
        for prefix in BAD_VAR_PREFIXES:
            if re.search(rf"\b(?:String|Integer|Id|Decimal|Boolean|Date|Datetime|Long|Double|Object)\s+{prefix}[A-Z]\w*\b", line):
                add_issue(i, "VAR_PREFIX", f"Avoid misleading prefix '{prefix}' in variable names")

        # List/Set naming rule
        list_match = re.search(r"\bList<[^>]+>\s+([A-Za-z_][A-Za-z0-9_]*)", line)
        if list_match:
            var_name = list_match.group(1)
            if var_name.endswith("List"):
                add_issue(i, "LIST_NAMING", "List variable should be plural, avoid 'List' suffix")
        set_match = re.search(r"\bSet<[^>]+>\s+([A-Za-z_][A-Za-z0-9_]*)", line)
        if set_match:
            var_name = set_match.group(1)
            if var_name.endswith("Set"):
                add_issue(i, "SET_NAMING", "Set variable should be plural, avoid 'Set' suffix")

        # Map naming rule
        map_match = re.search(r"\bMap<[^>]+>\s+([A-Za-z_][A-Za-z0-9_]*)", line)
        if map_match:
            var_name = map_match.group(1)
            if not is_reasonable_map_name(var_name):
                add_issue(
                    i,
                    "MAP_NAMING",
                    "Map variable should be semantic (e.g., IdToAccount, itemsByType, AccountMap)",
                )

    # Comment hygiene: discourage non-essential comments and auto JavaDoc
    in_block_comment = False
    block_start_line = 0
    for i, line in enumerate(lines, 1):
        stripped = line.strip()

        if COMMENT_LINE_PATTERN.search(line):
            if SUPPRESSION_PATTERN.search(line):
                continue
            add_issue(i, "COMMENT_NOISE", "Avoid comments unless code cannot express intent directly")

        if not in_block_comment and BLOCK_COMMENT_START_PATTERN.search(line):
            in_block_comment = True
            block_start_line = i
            if JAVADOC_START_PATTERN.search(line):
                next_code = ""
                for candidate in lines[i:]:
                    candidate = candidate.strip()
                    if not candidate:
                        continue
                    next_code = candidate
                    break
                if CLASS_OR_METHOD_PATTERN.search(next_code):
                    add_issue(
                        i,
                        "AUTO_JAVADOC",
                        "Do not use auto-generated JavaDoc-style comments for classes/methods",
                    )
            elif not SUPPRESSION_PATTERN.search(line):
                add_issue(
                    i,
                    "COMMENT_NOISE",
                    "Avoid comments unless code cannot express intent directly",
                )
            continue

        if in_block_comment:
            if (
                block_start_line not in emitted_block_comment_noise
                and not SUPPRESSION_PATTERN.search(line)
                and not CODE_LIKE_PATTERN.search(stripped)
            ):
                add_issue(
                    block_start_line,
                    "COMMENT_NOISE",
                    "Avoid comments unless code cannot express intent directly",
                )
                emitted_block_comment_noise.add(block_start_line)
            if BLOCK_COMMENT_END_PATTERN.search(line):
                in_block_comment = False

    # DML in OO layer
    if layer == "oo":
        for i, line in enumerate(lines, 1):
            for pat in DML_PATTERNS:
                if re.search(pat, line, re.IGNORECASE):
                    add_issue(i, "OO_DML", "OO layer must not perform DML")
                    break

    # SOQL in OO layer must be via selector/query DI
    if layer == "oo":
        has_soql = any(re.search(pat, content, re.IGNORECASE) for pat in SOQL_PATTERNS)
        if has_soql:
            has_selector_prop = re.search(r"\b\w*(Selector|Query)\w*\s+\w+\s*(=|;)", content) is not None
            if not has_selector_prop:
                add_issue(1, "OO_SOQL_DI", "SOQL in OO should be injected via selector/query property")

    # Error handling: catch blocks in non-entrypoint should rethrow
    if layer != "entry-point":
        for i, line in enumerate(lines, 1):
            if "catch" in line:
                # naive block scan to see if throw exists nearby
                block = "\n".join(lines[i - 1 : min(i + 8, len(lines))])
                if "throw" not in block:
                    add_issue(i, "CATCH_RETHROW", "Non-entry-point catch should rethrow to entry-point")

    # Entry-point should handle exceptions
    if layer == "entry-point":
        requires_try_catch = "@RestResource" in content or "RestContext" in content
        if requires_try_catch and ("try" not in content or "catch" not in content):
            add_issue(1, "ENTRY_TRY_CATCH", "Entry-point should handle exceptions with try/catch")

    # Tests: OO unit tests should not use DML
    if layer == "test":
        if class_name and ("Unit" in class_name or "OO" in class_name):
            for i, line in enumerate(lines, 1):
                for pat in DML_PATTERNS:
                    if re.search(pat, line, re.IGNORECASE):
                        add_issue(i, "OO_TEST_DML", "OO unit tests must not use DML")
                        break

    return issues


def main() -> None:
    try:
        hook_input = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)

    tool_input = hook_input.get("tool_input", {})
    file_path = tool_input.get("file_path", "")

    if not file_path:
        sys.exit(0)

    path = Path(file_path)
    if not is_apex_file(file_path):
        sys.exit(0)

    if not path.exists():
        sys.exit(0)

    content = read_file(path)
    if not content:
        sys.exit(0)

    repo_root = Path(os.getcwd())
    index_map = load_template_index_map(repo_root)
    class_name = find_class_name(content)
    layer = classify_layer(path, content, class_name, index_map)

    issues = collect_issues(content, layer, class_name)

    if not issues:
        sys.exit(0)

    lines = []
    lines.append("=" * 60)
    lines.append("🧼 CLEAN-APEX VALIDATION RESULTS")
    lines.append(f"   File: {file_path}")
    lines.append(f"   Layer: {layer}")
    lines.append("=" * 60)
    for line_no, code, message in issues:
        lines.append(f"- {code} line {line_no}: {message}")
    lines.append("=" * 60)

    print("\n".join(lines))


if __name__ == "__main__":
    main()
