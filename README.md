# 📄 Overby Industries — White Papers

[![License: CC BY-4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](LICENSE)
![Build White Papers](https://github.com/Overby-Industries/whitepapers/actions/workflows/latex-build.yml/badge.svg)
[![Latest Release](https://img.shields.io/github/v/release/Overby-Industries/whitepapers)](https://github.com/Overby-Industries/whitepapers/releases)
[![Latest PDFs](https://img.shields.io/badge/download-latest%20papers-blue)](https://github.com/Overby-Industries/whitepapers/tree/main/dist)
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

This repository is the technical/policy backbone referenced by the [Overby Industries PWA](https://github.com/Overby-Industries/overby-industries-pwa) and org profile: it's where the ISRU, zero-waste, and open-governance concepts described elsewhere get written up in full, citable detail.

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
whitepapers/
├── papers/          # Final, DOI-ready releases (LaTeX source, one folder per paper)
│   └── 2025-overby-industries-vision/
├── drafts/          # Active in-progress manuscripts
├── figures/         # Shared SVG/PNG figures & diagrams
├── templates/       # LaTeX / Markdown submission templates
├── references/      # BibTeX database, data sets, external links
├── tools/           # Build scripts (Pandoc, LaTeX, CI preview)
└── dist/            # CI-built PDFs (generated, not hand-edited)
```

*Auto-rendering:* every push triggers GitHub Actions that compiles the `.tex` sources under `papers/` and `drafts/` into review-quality PDFs in `dist/`.

---

## 🚀 Featured Papers (Index)

| Year | Title | Lead Author(s) | Status |
|------|-------|----------------|--------|
| 2025 | Overby Industries: An Ethical, Zero-Waste Roadmap to Sustainable Space Industry | Overby Industries R&D Division | ✅ Published — [source](papers/2025-overby-industries-vision/overby-industries-vision.tex) |
| 2026 | Magnetohydrodynamic Ionic-Liquid Generator & Dual-Mode Propulsion | Overby Industries R&D Division | 📝 Draft v0.1 — [source](papers/2026-mhd-power-propulsion/mhd-power-propulsion.tex) — implemented in [`power-and-propulsion`](https://github.com/Overby-Industries/power-and-propulsion) |

_Additional entries are added as papers move from `drafts/` into `papers/`._

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
   - Once accepted, your draft moves from `drafts/<title>/` into `papers/<title>/` as source.
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
Every push/PR compiles `.tex` files under `papers/` and `drafts/` to `.pdf` in `/dist/` for preview.

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
The authoritative list of accepted/published white papers is the **Featured Papers** table above in this README.

Each entry links both to:
- Source (`.tex`) files under `papers/<title>/`
- Compiled PDFs (either `/dist/` or attached to the latest Release)

## 📑 Citation & License

Unless otherwise noted, all content is released under **Creative Commons Attribution 4.0**.  
To cite any paper:

```bibtex
@techreport{overby2026mhd,
  title     = {Magnetohydrodynamic Ionic-Liquid Generator & Dual-Mode Propulsion},
  author    = {{Overby Industries R\&D Division}},
  institution = {Overby Industries},
  year      = {2026},
  note      = {Draft v0.1},
  doi       = {10.5281/zenodo.<placeholder>}
}
```

---

## 🤝 Code of Conduct

We operate as a **planet-scale civic movement**. All contributors agree to uphold a welcoming, inclusive environment. See `CODE_OF_CONDUCT.md`.

---

## 📬 Contact

• General inquiries: info@overbyindustries.space  
• Technical lead (power & propulsion): founder@overbyindustries.space  
• Website: https://overbyindustries.space  

Let’s write the papers that power the engines that move humanity forward. 🌍🚀
