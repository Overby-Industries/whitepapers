# 📄 Overby Industries — White Papers

[![License: CC BY-4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](LICENSE)
![Build White Papers](https://github.com/Overby-Industries/whitepapers/actions/workflows/latex-build.yml/badge.svg)
[![Latest Release](https://img.shields.io/github/v/release/Overby-Industries/whitepapers)](https://github.com/Overby-Industries/whitepapers/releases)
[![Latest PDFs](https://img.shields.io/badge/download-latest%20papers-blue)](https://github.com/Overby-Industries/whitepapers/tree/main/whitepapers/dist)
![Last Update](https://img.shields.io/github/last-commit/Overby-Industries/whitepapers)
![Repo Size](https://img.shields.io/github/repo-size/Overby-Industries/whitepapers)
![Contributors](https://img.shields.io/github/contributors/Overby-Industries/whitepapers)
![Issues](https://img.shields.io/github/issues-raw/Overby-Industries/whitepapers)
![Pull Requests](https://img.shields.io/github/issues-pr-raw/Overby-Industries/whitepapers)
![Commit Activity](https://img.shields.io/github/commit-activity/m/Overby-Industries/whitepapers)

A dedicated home for peer-review-ready technical and policy white papers that advance  
Overby Industries’ mission: **open, democratic space power & propulsion for “We the People of Earth.”**
> **Towards Open, Democratic Spaceflight**  
> Research, design, and technical vision documents for the Overby Industries propulsion and power ecosystem.

---
[![Anurag's GitHub stats](https://github-readme-stats.vercel.app/api?username=Overby-Industries)](https://github.com/Overby-Industries/github-readme-stats)
[![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=Overby-Industries)](https://github.com/Overby-Industries/github-readme-stats)

## 📚 Purpose

This repository is the **public library** of Overby Industries' official white papers and research documents.  
It serves as both a technical archive and a civic declaration of our commitment to **planetary-scale power, propulsion, and freedom in space**.

Our goal: to make next-generation aerospace concepts accessible to a **global community of thinkers, builders, and explorers**.

1. **Consolidate knowledge** – maintain a single, well-indexed archive of published papers.  
2. **Elevate transparency** – share complete research packages (PDF, source, figures, data).  
3. **Invite collaboration** – provide templates and a PR workflow so anyone can propose new work.  

Whether you are researching MHD ionic-liquid generators, atmosphere-breathing electric propulsion, or supply-chain architectures for asteroid outposts, this repository is the canonical reference point.

---

## 🗂️ Repository Structure
Each paper is versioned and archived here with supporting material:

```
white-papers/
├── papers/          # Final, DOI-ready releases (PDF + source)
│   ├── 2024_MHD_Ionic_Generator/
│   └── ...
├── drafts/          # Active in-progress manuscripts
├── figures/         # Shared SVG/PNG figures & diagrams
├── templates/       # LaTeX / Markdown submission templates
├── references/      # BibTeX database, data sets, external links
└── tools/           # Build scripts (Pandoc, LaTeX, CI preview)
```

*Auto-rendering:* every push triggers GitHub Actions that compile LaTeX/Markdown into review-quality PDFs and post them in the relevant folder.

---

## 🚀 Featured Papers (Index)

| Year | Title | Lead Author(s) | Status |
|------|-------|----------------|--------|
| 2025 | Magnetohydrodynamic Ionic-Liquid Generator & Dual-Mode Propulsion | K. Overby | ✅ Published |
| 2024 | Solar-Wind Ion Capture for Unlimited ΔV | A. Doe, B. Rao | 🔄 In Review |
| 2023 | Open Civic Aerospace: Governance Model | S. Lee | ✅ Published |

_Comprehensive abstract list lives in `/whitepapers/README.md`._

---

## 📝 How to Contribute a Paper

We welcome contributions of new ideas, concepts, and technical papers.  
Here’s the workflow:

- **Fork this repo** and create a feature branch:
```bash
git checkout -b feat/my-white-paper
```
- Use the template:
Copy templates/overby-whitepaper.tex into: `drafts/<descriptive-title>/`
   - Work on your `.tex` file there.
- Figures:
   - Commit figures to `/figures/` and use relative paths for citations.
   - (SVG or PDF preferred for clarity.)
- Push your branch and open a Pull Request.
   - The CI will build a preview PDF automatically.
- Review/Approval:
   - At least two maintainers (plus optional external reviewers) approve.
- Promotion:
   - Once accepted, your draft moves into `/whitepapers/` as source.
   - From there, the CI pipeline will:
      - Compile your `.tex` into PDF
      - Auto‑publish it to the `dist/` folder
      - Attach it to the latest GitHub Release
## 📄 White Paper LaTeX Template
Located in `templates/overby-whitepaper.tex`.

Compile locally:

```bash
pdflatex overby-whitepaper.tex
```
This produces a `.pdf` version, also auto‑built by CI/CD when pushed.

## ⚡ Auto‑Publishing Flow
There are two build triggers:

- Normal Push:
Every push/PR compiles `.tex` to `.pdf` in `/whitepapers/dist/` for preview.

Example:

![Build White Papers](https://github.com/Overby-Industries/whitepapers/actions/workflows/latex-build.yml/badge.svg)

- Release Tag:
Tag a commit to make an official release:

```bash
git tag v1.0
git push origin v1.0
```
The workflow will:
- Compile your LaTeX to PDF
- Create a GitHub Release called v1.0
- Attach compiled PDFs as downloadable assets

Visitors will now see an official:

👉 “White Paper v1.0 — Download PDF” section here.

## 📚 Paper Index
The authoritative list of accepted/published white papers lives in:
➡️ `/whitepapers/README.md`

This index links both to:
- Source (`.tex`) files
- Compiled PDFs (either /whitepapers/dist/ or attached to the latest Release)

Example entry:

```markdown
- **The MHD Power + Propulsion Architecture**  
  [Source](mhd-generator.tex) · [Download PDF](../dist/mhd-generator.pdf)
```

## 📑 Citation & License

Unless otherwise noted, all content is released under **Creative Commons Attribution 4.0**.  
To cite any paper:

```bibtex
@techreport{overby2024mhd,
  title     = {Magnetohydrodynamic Ionic-Liquid Generator & Dual-Mode Propulsion},
  author    = {Overby, J. and Collaborators},
  institution = {Overby Industries},
  year      = {2024},
  doi       = {10.5281/zenodo.<placeholder>}
}
```

---

## 🤝 Code of Conduct

We operate as a **planet-scale civic movement**. All contributors agree to uphold a welcoming, inclusive environment. See `CODE_OF_CONDUCT.md`.

---

## 📬 Contact

• General inquiries: info@overbyindustries.space  
• Technical lead (power & propulsion): propulsion@overbyindustries.space  
• Website: https://overbyindustries.space  

Let’s write the papers that power the engines that move humanity forward. 🌍🚀
