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

_Comprehensive abstract list lives in `/papers/README.md`._

---

## 📝 How to Contribute a Paper

1. **Fork** the repo and create a feature branch:  
   `git checkout -b feat/my-white-paper`
2. Copy the `templates/paper_template.md` (or `.tex`) into `/drafts/<descriptive_title>/`.
3. Commit figures to `/figures/` and cite them relatively.
4. Push & open a **Pull Request**. The CI will auto-build a preview PDF.
5. Two maintainers + optional external reviewers approve → merge → paper is promoted to `/papers/` and assigned a DOI.

See `CONTRIBUTING.md` for detailed style & formatting rules.

## 📄 White Paper LaTeX Template
Located in templates/overby-whitepaper.tex:

📌 Export via:

```bash
pdflatex overby-whitepaper.tex
```
→ Produces overby-whitepaper.pdf publishable to /whitepapers/.

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
