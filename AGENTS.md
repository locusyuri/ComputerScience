# AGENTS — Notes for AI coding agents

Purpose: give concise, actionable instructions so coding agents can be productive in this repo.

Quick commands
- `typst compile "<path-to-initial.typ>" "<output.pdf>" --root .` — compile a note; run from repository root.
- `typst watch "<path-to-initial.typ>"` — watch & rebuild on changes.
- `xelatex -interaction=nonstopmode <file>.tex` — for LaTeX templates under `99-索引与模板/TexTemplate`.

Where to start
- Overview: [README.md](README.md)
- Typst template: [99-索引与模板/TypstTemplate/computer-notes.typ](99-索引与模板/TypstTemplate/computer-notes.typ)
- Examples/demo: [99-索引与模板/TypstTemplate/example.typ](99-索引与模板/TypstTemplate/example.typ)

Key conventions agents should follow
- Only compile `initial.typ` files (they are the canonical entry points).
- Always run `typst compile ... --root .` from the repository root to allow template imports.
- Do not modify public interfaces in `99-索引与模板/TypstTemplate/computer-notes.typ` (backwards compatibility).
- Keep changes local to a module (e.g., `01-计算机基础/`, `02-编程语言/`) and prefer adding examples rather than broad refactors.

Important locations
- Templates and tools: [99-索引与模板](99-索引与模板)
- Top-level notes: `01-计算机基础`, `02-编程语言`, `03-开发方向`, `04-数据与智能`, `05-安全与密码`, `06-工程化与运维`

Adaptations performed
- Fixed SKILL files copied from another project that referenced the wrong template or paths:
  - [.github/skills/template-usage/SKILL.md](.github/skills/template-usage/SKILL.md) — updated `TypstTemplate/math-notes.typ` → `TypstTemplate/computer-notes.typ` and institute name.
  - [.github/skills/typst-compile/SKILL.md](.github/skills/typst-compile/SKILL.md) — updated example cwd `c:\\Notiz\\MathRepo` → `c:\\Notiz\\ComputerScience` and example compile paths.
  - [.github/skills/typst-writing-conventions/SKILL.md](.github/skills/typst-writing-conventions/SKILL.md) — made description generic to this repository.

If you're unsure
- Link rather than duplicate: prefer to link existing docs (README, template README) instead of copying them here.
- Ask before making wide-reaching edits to templates under `99-索引与模板`.

Next suggested customizations
- Create a short `.github/copilot-instructions.md` that references this `AGENTS.md` and lists quick test/build commands for CI.
- Add a lightweight `skill` describing how to run `typst compile` on Windows and common pitfalls (fonts, network packages).

— End
