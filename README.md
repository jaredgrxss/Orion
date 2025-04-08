<p align="center">
  <img src="https://github.com/user-attachments/assets/16a9c7f8-e645-423a-9a3a-9933ac847b2c" alt="Orion Logo" width="400"/>
</p>

<div align="center">
  
  [Problem](#what-problem-does-orion-solve) • 
  [Features](#key-features) • 
  [Usage](#example-usage)
  
</div>

---

**Advanced Dependency Analyzer for Ruby Projects**

> Secure, optimize, and understand your Ruby dependencies—before they become a problem.

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

## Example Usage

```bash
$ orion analyze (for the entire suite of analysis tools to run)
$ orion analyze code (for code quality and linting)
$ orion analyze gems (for gem health, security, and dependency graphing)

