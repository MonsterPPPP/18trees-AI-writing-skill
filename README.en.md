<p align="center">
  <img src="./assets/banner.webp" alt="十八木" width="100%" />
</p>

<p align="center">
  <a href="./README.md">中文</a> · <strong>English</strong>
</p>

# 18trees-AI-writing-skill

Turns Chinese dictated drafts, rough essays, and technical learning conversations into articles that **still read unmistakably as your own**. The installed skill selects a personal essay or knowledge essay mode based on the draft's main purpose.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## What problem it solves

You write with voice input, and the transcript comes out as a lump: filler words, repeated “I think,” broken sentence breaks, wrong proper nouns, and no paragraph breaks. A technical discussion may also contain mistaken guesses, AI replies, and unverified formulas or code.

**Hand it straight to an AI to clean up and the problem gets worse.** It elevates your conclusions for you, softens your points, stuffs in "not X, but Y", splits it into a pile of bullet lists, bolds until it glows. The article comes out clean, but it no longer reads like you.

This skill puts **editing before polishing, while preserving the author and checking knowledge**. Personal mode removes dictation noise without flattening the author's judgments or tone. Knowledge mode checks technical claims while preserving the real questions and learning process.

- ✅ Fixes ASR errors, typos, wrong proper nouns, factual errors
- ✅ Removes mechanical repetition and filler phrases case by case, while keeping meaningful hesitation and changes of mind
- ✅ Rearranges paragraphs, headings, bold, layout
- ✅ In knowledge essays, checks key premises, formulas, code, and who said what; marks unresolved core claims
- ❌ Does not elevate your conclusions for you
- ❌ Does not rewrite strong claims as "possibly" or "maybe"
- ❌ Does not add AI-flavored sentence patterns like "not X, but Y"
- ❌ Does not turn a personal note into WeChat-public-account chicken soup or a consulting report

The existing [real before/after example](examples/) covers personal dictation: a 620-character draft, its edited version, and the reason for each change. Knowledge mode is based on the author's *Knowledge Essay Writing Specification v0.1*; the repository does not yet include a real knowledge-essay before/after example.

## Two writing modes

| Main purpose of the draft | With the installed skill | Copy into a chat tool or Coding Agent |
| --- | --- | --- |
| Express personal experiences, views, or feelings; technical ideas are incidental | Selects personal dictation and essay mode | Copy the complete [personal prompt](dist/voice-preserving-essay-editor.md) |
| Explain engineering, mathematics, code, or scientific reasoning; personal experience frames the question | Selects knowledge essay mode | Copy the complete [knowledge prompt](dist/knowledge-essay-editor.md) |

An explicit style request takes precedence. For a mixed draft, select the mode that matches its main thread and account for the other kind of content where it occurs. Each copyable file is complete: **copy just one**. Knowledge mode checks verifiable claims without presenting an AI reply as the author's own discovery or changing the author's value judgments.

---

## Installation

### Claude Code

```bash
/plugin marketplace add MonsterPPPP/18trees-AI-writing-skill
```

```bash
/plugin install voice-preserving-essay-editor@18trees-ai-writing
```

Or install manually: copy the entire `skills/voice-preserving-essay-editor/` folder into `~/.claude/skills/`.

### Codex

Copy `skills/voice-preserving-essay-editor/` into `~/.codex/skills/` (for a project-level install, put it in `.codex/skills/`).

### Any AI chat tool (ChatGPT / Gemini / DeepSeek / Kimi / Doubao …)

**No installation needed.** Choose one `dist/` file from the table above, copy **the entire contents**, paste it as your first message, then paste in your draft.

Each file contains all the rules for its mode and needs no other repository file, plugin, or API. Checking knowledge still depends on the tool's access to suitable sources; when a core claim cannot be verified, the rules require it to remain an open question or be marked unverified.

### How to use it once installed

Just say what you want in plain words, and the skill triggers automatically:

> Clean up this dictated draft for me.
> This one is a speech-to-text transcript — tidy it up, keep my tone.
> Turn this conversation about formulas and code into an essay; check the reasoning and preserve the questions I actually asked.

---

## Repository structure

```
.
├── skills/voice-preserving-essay-editor/   ← rule source files (single source of truth)
│   ├── SKILL.md                            Entry point: mode selection and shared boundaries
│   ├── references/                         Personal mode, knowledge mode, and conditional rules
│   └── agents/openai.yaml                  Codex UI metadata
├── dist/
│   ├── voice-preserving-essay-editor.md    ← complete personal-mode prompt
│   └── knowledge-essay-editor.md           ← complete knowledge-mode prompt
├── examples/                               Existing personal dictation before/after
└── scripts/build-dist.sh                   Generates both files from skills/
```

**Two delivery formats**: `skills/` is the split version that selects a mode (for Claude Code / Codex); `dist/` contains one complete file per mode (for tools where you paste instructions). `dist/` is generated from the rule source — edit only `skills/`, then run:

```bash
bash scripts/build-dist.sh
```

---

## Design principles

The rules have three layers:

1. **SKILL.md**: select a mode by the draft's main purpose and state the shared author-fidelity and fact boundaries.
2. **references/**: personal mode keeps its existing rules and adds [disfluency decisions](skills/voice-preserving-essay-editor/references/oral-disfluency.md); [knowledge mode](skills/voice-preserving-essay-editor/references/knowledge-essay.md) covers attribution, factual checking, and technical explanation.
3. **Execution flow**: personal mode removes dictation noise; knowledge mode identifies sources and gaps, then checks, edits, and reviews the result.

The final self-check is one question:

> **Am I cleaning up the author's draft, or writing in their place?**

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). There is exactly one core constraint: **this is a cumulative skill — incremental improvement only, never regression** — new rules may only be added or refined; an old rule that has been confirmed effective must not be deleted.

## License

[MIT](LICENSE) © 2026 十八木
