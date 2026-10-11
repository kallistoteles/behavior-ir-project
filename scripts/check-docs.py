"""Check top-level Markdown whitespace and ordinary inline local links.

External URLs are not fetched. Code examples are excluded from link checks.
"""

import argparse
from collections import Counter
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit


def visible_lines(content):
    fence = None
    for number, line in enumerate(content.splitlines(), 1):
        marker = re.match(r"^\s{0,3}(`{3,}|~{3,})", line)
        if marker:
            value = marker.group(1)
            if fence is None:
                fence = value
            elif value[0] == fence[0] and len(value) >= len(fence):
                fence = None
            continue
        if fence is None:
            yield number, line


def heading_ids(content):
    counts = Counter()
    identifiers = set()
    for _, line in visible_lines(content):
        heading = re.match(r"^\s{0,3}#{1,6}\s+(.+?)(?:\s+#+)?\s*$", line)
        if heading:
            slug = re.sub(r"[^\w\s-]", "", heading.group(1).lower()).replace(" ", "-")
            count = counts[slug]
            identifiers.add(f"{slug}-{count}" if count else slug)
            counts[slug] += 1
    return identifiers


def check_documents(root):
    errors = []
    documents = sorted(root.glob("*.md"))
    if not documents:
        return ["No top-level Markdown documents found."]
    for document in documents:
        try:
            content = document.read_text(encoding="utf-8")
        except (OSError, UnicodeError) as error:
            errors.append(f"{document.name}: cannot read document: {error}")
            continue
        if not content.endswith("\n"):
            errors.append(f"{document.name}: missing final newline")
        for number, line in enumerate(content.splitlines(), 1):
            if line != line.rstrip():
                errors.append(f"{document.name}:{number}: trailing whitespace")
        for number, line in visible_lines(content):
            line = re.sub(r"(`+).*?\1", "", line)
            for target in re.findall(r"\[[^\]]*\]\(([^\s)]+)\)", line):
                try:
                    link = urlsplit(target)
                    if link.scheme or link.netloc:
                        continue
                    destination = (
                        (document.parent / unquote(link.path)).resolve()
                        if link.path else document
                    )
                    if not destination.is_relative_to(root) or not destination.is_file():
                        errors.append(f"{document.name}:{number}: missing local target: {target}")
                    elif link.fragment:
                        headings = heading_ids(destination.read_text(encoding="utf-8"))
                        if unquote(link.fragment) not in headings:
                            errors.append(f"{document.name}:{number}: missing heading: {target}")
                except (ValueError, OSError, UnicodeError) as error:
                    errors.append(f"{document.name}:{number}: invalid link {target}: {error}")
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    errors = check_documents(args.root.resolve())
    for error in errors:
        print(f"check-docs: {error}", file=sys.stderr)
    if errors:
        return 1
    print("check-docs: OK (local inline links, headings and whitespace)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
