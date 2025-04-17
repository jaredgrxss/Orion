<p align="center">
  <img src="https://github.com/user-attachments/assets/15e76b61-8782-492d-bcb9-b9d8dee62635"
 alt="Orion Logo" width="450"/>
</p>

<div align="center">
  
  [Problem](#what-problem-does-orion-solve) • 
  [Features](#key-features) • 
  [Core Commands](#core-commands)

</div>

<h3 align="center"><strong>An Advanced Dependency Analyzer for Ruby Projects</strong></h3>



  <p align="center">
      <em>Secure, optimize, and understand your Ruby dependencies—before they become a problem.</em>
  </p>

---

## What Problem Does Orion Solve?

Ruby development is elegant—until your `Gemfile.lock` turns into a tangled mess of outdated, insecure, or bloated gems. Developers are often left wondering:

- Is any gem introducing **security vulnerabilities**?
- Are we relying on **abandoned or deprecated gems**?
- How **bloated or inefficient** is our dependency tree?
- Is there a **better alternative** that boosts performance or reliability?

Tools like `bundler-audit` and `dependabot` offer partial insights. **Orion** goes further. It gives you a complete, actionable picture of your dependencies—so you can build safer, faster Ruby applications.

---

## Key Features

| Feature                        | Description |
|-------------------------------|-------------|
| 🔐 **Security Scanning**       | Detect CVEs using trusted vulnerability databases (e.g. [rubysec](https://github.com/rubysec/ruby-advisory-db)). |
| 🧠 **Gem Health Check**        | Identify outdated or unmaintained gems and recommend better-maintained alternatives. |
| 🌐 **Dependency Graphing**     | Visualize your entire dependency tree (CLI ASCII or exportable formats). |
| ⚡ **Performance Insights**    | Analyze memory/load-time performance and flag bottleneck gems. |
| 🧹 **Automated Fixes**         | Automatically upgrade vulnerable gems and clean up unused dependencies. |
| 📊 **Customizable Reports**    | Quick overviews or deep-dive audits tailored to your needs. |
| 🔎 **Code Quality Scanner**    | Lint your codebase, catch potential security flaws, and track metrics via a single CLI. |

---

---

## Core Commands

### `orion analyze gems`

> 📦 Analyze gem dependencies for health, vulnerabilities, and bloat

**Options**:
- `-lockfile=PATH` (default: `./Gemfile.lock`)
- `-format=json|table` (default: `table`)
- `-include-dev`

**What It Does**:
- Scans gems for:
  - CVEs (via RubySec)
  - Staleness / abandonware
  - Popularity / health
  - Bloat / unused
- Outputs actionable suggestions

---

### `orion analyze code`

> 🧹 Run code quality checks and detect security/linting issues

**Options**:
- `-path=PATH` (default: `./`)
- `-format=json|table`
- `-profile`
- `-fix`

**What It Does**:
- Lints your code
- Optionally profiles performance
- Highlights risky or inefficient patterns

---

### `orion graph`

> 🌐 Visualize your full gem dependency graph

**Options**:
- `-export=graph.png|graph.dot`
- `-highlight-vulnerable`
- `-depth=NUM`

**What It Does**:
- ASCII or visual dependency tree
- Highlights vulnerabilities, stale gems, unused gems

---

### `orion fix`

> 🛠 Apply safe fixes for known issues

**Options**:
- `-update-vulnerable`
- `-remove-unused`
- `-dry-run`
- `-commit`

**What It Does**:
- Auto-upgrades vulnerable gems
- Removes unused ones
- Creates a branch and commits changes

---

### `orion report`

> 🧾 Output a consolidated audit report from previous analyses

**Options**:
- `-type=gems|code|full`
- `-output=report.md|report.json`
- `-open`

**What It Does**:
- Aggregates analysis results
- Saves markdown/JSON reports
- CI/CD friendly


