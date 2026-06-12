# AGENTS — Notes for AI coding agents

Purpose: give concise, actionable instructions so coding agents can be productive in this repo.

Quick commands
- `typst compile "<path-to-main.typ>" "<output.pdf>" --root .` — compile a note; run from repository root.
- `typst watch "<path-to-main.typ>"` — watch & rebuild on changes.
- `xelatex -interaction=nonstopmode <file>.tex` — for LaTeX templates under `99-索引与模板/TexTemplate`.

Where to start
- Overview: [README.md](README.md)
- Typst template: [99-索引与模板/TypstTemplate/computer-notes.typ](99-索引与模板/TypstTemplate/computer-notes.typ)
- Examples/demo: [99-索引与模板/TypstTemplate/example.typ](99-索引与模板/TypstTemplate/example.typ)
- Agent skills & rules: [.agents/](.agents/)

Key conventions agents should follow
- Entry points are `main.typ` files (e.g., `01-计算机基础/计算机基础/main.typ`), not `initial.typ`.
- Always run `typst compile ... --root .` from the repository root to allow template imports.
- Do not modify public interfaces in `99-索引与模板/TypstTemplate/computer-notes.typ` (backwards compatibility).
- Keep changes local to a module (e.g., `01-计算机基础/`, `02-编程语言/`) and prefer adding examples rather than broad refactors.
- Commit messages are written in Chinese (see `.agents/rules/git-commit-message.md`).

Important locations
- Templates and tools: `99-索引与模板` (TypstTemplate, TexTemplate, ForCopyTypst)
- Top-level notes: `01-计算机基础`, `02-编程语言`, `03-开发方向`, `04-数据与智能`, `05-安全与密码`, `06-工程化与运维`
- Agent configuration: `.agents/` (skills, rules, commands)

Typst entry-point structure
Each topic folder contains a `main.typ` that imports the template, sets metadata, and `#include`s chapter files from a `chapters/` subdirectory. Chapter files must also `#import` the template at their top (relative path `../../../99-索引与模板/TypstTemplate/computer-notes.typ` for depth-2 folders).

If you're unsure
- Link rather than duplicate: prefer to link existing docs (README, template README) instead of copying them here.
- Ask before making wide-reaching edits to templates under `99-索引与模板`.

— End
