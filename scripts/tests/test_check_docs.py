"""Exercise documentation checks through their command-line interface."""

from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "check-docs.py"


class DocumentationChecks(unittest.TestCase):
    def check_documents(self, documents):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name, content in documents.items():
                (root / name).write_text(content, encoding="utf-8")
            return subprocess.run(
                [sys.executable, str(SCRIPT), "--root", str(root)],
                capture_output=True,
                text=True,
                check=False,
            )

    def test_valid_local_links_and_external_links(self):
        result = self.check_documents({
            "README.md": "# Overview\n\n[Guide](GUIDE.md#development)\n"
            "[External](https://example.invalid/unavailable)\n",
            "GUIDE.md": "# Guide\n\n## Development\n\n[Home](README.md)\n",
        })
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_missing_local_target_is_rejected(self):
        result = self.check_documents({"README.md": "[Missing](missing.md)\n"})
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIn("missing.md", result.stderr)

    def test_missing_heading_is_rejected(self):
        result = self.check_documents({
            "README.md": "# Overview\n\n[Missing](README.md#missing)\n",
        })
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIn("missing", result.stderr)

    def test_trailing_whitespace_is_rejected(self):
        result = self.check_documents({"README.md": "# Overview  \n"})
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIn("whitespace", result.stderr)

    def test_missing_final_newline_is_rejected(self):
        result = self.check_documents({"README.md": "# Overview"})
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIn("newline", result.stderr)

    def test_links_inside_code_examples_are_not_checked(self):
        result = self.check_documents({
            "README.md": "# Overview\n\n```markdown\n[Example](missing.md)\n```\n"
            "\nInline example: `[Example](missing.md)`.\n",
        })
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_empty_documentation_directory_is_rejected(self):
        result = self.check_documents({})
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIn("Markdown", result.stderr)


if __name__ == "__main__":
    unittest.main()
