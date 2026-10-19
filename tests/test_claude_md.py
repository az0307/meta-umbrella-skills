"""
Tests for CLAUDE.md.

CLAUDE.md is a documentation/guidance file (not executable code) that tells
Claude Code how this repository is organized and how to work with it. Since
there is no application code in this PR, these tests validate:

  * The file exists, is readable, and is well-formed Markdown.
  * It contains the expected sections and guidance content.
  * The paths, filenames, and directory structure it references actually
    exist in the repository (so the documentation doesn't drift out of
    sync with reality).
  * The domain groupings and skill listings it describes match the actual
    `skills/` directory layout.

These are plain `unittest` tests (stdlib only) since the repository does not
currently have a test runner or dependency (pytest/jest/etc.) configured.
"""

import re
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CLAUDE_MD_PATH = REPO_ROOT / "CLAUDE.md"


class ClaudeMdFileTests(unittest.TestCase):
    """Basic existence / sanity checks for CLAUDE.md."""

    @classmethod
    def setUpClass(cls):
        cls.content = CLAUDE_MD_PATH.read_text(encoding="utf-8")

    def test_file_exists(self):
        self.assertTrue(
            CLAUDE_MD_PATH.is_file(), "CLAUDE.md must exist at the repo root"
        )

    def test_file_not_empty(self):
        self.assertGreater(len(self.content.strip()), 0, "CLAUDE.md must not be empty")

    def test_starts_with_h1_title(self):
        first_line = self.content.splitlines()[0]
        self.assertEqual(first_line, "# CLAUDE.md")

    def test_no_trailing_whitespace_on_lines(self):
        offending = [
            i + 1
            for i, line in enumerate(self.content.splitlines())
            if line != line.rstrip()
        ]
        self.assertEqual(
            offending, [], f"Lines with trailing whitespace: {offending}"
        )

    def test_code_fences_are_balanced(self):
        fence_count = len(re.findall(r"^```", self.content, flags=re.MULTILINE))
        self.assertEqual(
            fence_count % 2, 0, "Markdown code fences (```) must be balanced"
        )

    def test_ends_with_newline(self):
        self.assertTrue(
            self.content.endswith("\n"), "File should end with a trailing newline"
        )


class ClaudeMdSectionTests(unittest.TestCase):
    """Verify the expected top-level sections/headings are present."""

    @classmethod
    def setUpClass(cls):
        cls.content = CLAUDE_MD_PATH.read_text(encoding="utf-8")
        cls.headings = re.findall(r"^##\s+(.+)$", cls.content, flags=re.MULTILINE)

    def test_expected_headings_present(self):
        expected = [
            "Project Overview",
            "Structure",
            "Quick Start (from README)",
            "Working Conventions",
            "Related Repos",
        ]
        for heading in expected:
            with self.subTest(heading=heading):
                self.assertIn(heading, self.headings)

    def test_headings_appear_in_expected_order(self):
        expected_order = [
            "Project Overview",
            "Structure",
            "Quick Start (from README)",
            "Working Conventions",
            "Related Repos",
        ]
        self.assertEqual(self.headings, expected_order)

    def test_guidance_intro_line_present(self):
        self.assertIn(
            "This file provides guidance to Claude Code (claude.ai/code) "
            "when working with code in this repository.",
            self.content,
        )


class ClaudeMdContentAccuracyTests(unittest.TestCase):
    """Verify the descriptive content matches reality / makes sense."""

    @classmethod
    def setUpClass(cls):
        cls.content = CLAUDE_MD_PATH.read_text(encoding="utf-8")

    def test_mentions_project_name(self):
        self.assertIn("Meta Umbrella Skills", self.content)

    def test_describes_non_compiled_nature(self):
        self.assertIn("not a compiled application", self.content)
        self.assertIn("`package.json` carries only metadata (no build).", self.content)

    def test_quick_start_steps_present(self):
        self.assertIn(".env.example", self.content)
        self.assertIn(".env", self.content)
        self.assertIn("config/claude_desktop_config.json", self.content)
        self.assertIn("Restart Claude Desktop.", self.content)

    def test_working_conventions_mention_skill_authoring(self):
        self.assertIn("skills/<domain>/<name>.md", self.content)
        self.assertIn("skills/meta-orchestrator.md", self.content)

    def test_working_conventions_mention_snapshots(self):
        self.assertIn("backups/", self.content)
        self.assertIn("archives/", self.content)
        self.assertIn("backups/backup-*/skills/", self.content)

    def test_never_commit_env_warning_present(self):
        self.assertIn("Never commit `.env` or real API tokens", self.content)

    def test_related_repos_section_lists_expected_repos(self):
        self.assertIn("meta-power-user-workflow", self.content)
        self.assertIn("meta-automation-hub", self.content)


class ClaudeMdReferencedPathsExistTests(unittest.TestCase):
    """
    Ensure every concrete file/directory path referenced in the 'Structure'
    section of CLAUDE.md actually exists in the repository, so the docs
    don't drift out of sync with the real layout.
    """

    # Paths explicitly called out in the CLAUDE.md "Structure" block,
    # relative to the repo root.
    REFERENCED_PATHS = [
        "skills",
        "skills/meta-orchestrator.md",
        "skills/compliance",
        "skills/creative",
        "skills/development",
        "skills/operations",
        "skills/research",
        "config/claude_desktop_config.json",
        "agent.md",
        "scripts",
        "autonomous-systems/diagnostics.ps1",
        "health-check.ps1",
        "create_files.py",
        "setup_generator.py",
        "Taskfile.yml",
        "archives",
        "backups",
        "README.md",
        "QUICK_START.md",
        "CHANGELOG.md",
        "CONTRIBUTING.md",
        "SECURITY.md",
        "INSTALLATION_TOOLS.md",
    ]

    def test_referenced_paths_exist(self):
        missing = [
            p for p in self.REFERENCED_PATHS if not (REPO_ROOT / p).exists()
        ]
        self.assertEqual(
            missing,
            [],
            f"CLAUDE.md references paths that do not exist in the repo: {missing}",
        )

    def test_env_example_exists_for_documented_quickstart(self):
        self.assertTrue(
            (REPO_ROOT / ".env.example").is_file(),
            "CLAUDE.md documents copying .env.example, but it is missing",
        )


class ClaudeMdSkillDomainConsistencyTests(unittest.TestCase):
    """
    Verify the domain groupings and skill lists documented in CLAUDE.md's
    Structure section match the actual skills/ directory contents.
    """

    DOCUMENTED_DOMAINS = {
        "compliance": {"ethics-advisor", "legal-reviewer", "security-auditor"},
        "creative": {"brand-designer", "content-writer", "pdf-generator", "ux-designer"},
        "development": {
            "code-architect",
            "build-engineer",
            "debug-specialist",
            "deploy-manager",
            "container-manager",
            "database-administrator",
            "git-operations-manager",
            "web-automator",
        },
        "operations": {
            "automation-engineer",
            "context-manager",
            "documentation-specialist",
            "project-manager",
            "team-communicator",
        },
        "research": {
            "data-analyst",
            "market-researcher",
            "search-specialist",
            "technical-researcher",
            "web-researcher-enhanced",
        },
    }

    def test_all_documented_domains_are_directories(self):
        skills_dir = REPO_ROOT / "skills"
        for domain in self.DOCUMENTED_DOMAINS:
            with self.subTest(domain=domain):
                self.assertTrue(
                    (skills_dir / domain).is_dir(),
                    f"Documented domain '{domain}' is not a directory under skills/",
                )

    def test_documented_skills_exist_within_their_domain(self):
        skills_dir = REPO_ROOT / "skills"
        for domain, skill_names in self.DOCUMENTED_DOMAINS.items():
            domain_dir = skills_dir / domain
            actual_stems = {p.stem for p in domain_dir.glob("*.md")}
            for skill_name in skill_names:
                with self.subTest(domain=domain, skill=skill_name):
                    self.assertIn(
                        skill_name,
                        actual_stems,
                        f"Documented skill '{skill_name}' not found as a .md "
                        f"file under skills/{domain}/",
                    )

    def test_no_undocumented_extra_domain_directories(self):
        """
        Every subdirectory under skills/ should be one of the domains
        CLAUDE.md documents, keeping the domain grouping consistent as
        the file instructs ("Keep the domain grouping ... consistent").
        """
        skills_dir = REPO_ROOT / "skills"
        actual_domain_dirs = {p.name for p in skills_dir.iterdir() if p.is_dir()}
        undocumented = actual_domain_dirs - set(self.DOCUMENTED_DOMAINS.keys())
        self.assertEqual(
            undocumented,
            set(),
            f"Found skill domain directories not documented in CLAUDE.md: {undocumented}",
        )


if __name__ == "__main__":
    unittest.main()