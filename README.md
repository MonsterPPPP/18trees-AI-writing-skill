<p align="center">
  <img src="./assets/banner.webp" alt="十八木" width="100%" />
</p>

<p align="center">
  中文 · <a href="./README.en.md">English</a>
</p>

# 18trees-AI-writing-skill

把中文口播稿、语音转写和粗糙随笔，整理成**仍然明显像你自己写的**文章。

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 它解决什么问题

你用语音输入写东西，转写出来是一坨：口水词、断句乱、专名错、一整块不分段。

**直接丢给 AI 整理，问题更大。** 它会替你升华结论、把观点写软、塞进"不是……而是……"、拆成一堆 bullet list、加粗到发光。文章变干净了，但读起来不像你了。

这个 skill 反过来：**整理优先于润色，保真优先于稳健**。它修正事实和口播污染，但不动你的判断、语气和锋利度。

- ✅ 修 ASR 错误、错别字、专名、事实错误
- ✅ 删口水词、断句污染、半截句
- ✅ 重排段落、标题、加粗、排版
- ❌ 不替你升华结论
- ❌ 不把强判断写成"可能""也许"
- ❌ 不加"不是……而是……"这类 AI 味句式
- ❌ 不把随笔改成公众号鸡汤或咨询报告

看真实对照：[examples/](examples/) —— 一份 620 字的口播原稿，和整理后的成稿，以及每处改动对应的规则。

---

## 安装

### Claude Code

```bash
/plugin marketplace add MonsterPPPP/18trees-AI-writing-skill
```

```bash
/plugin install voice-preserving-essay-editor@18trees-ai-writing
```

或者手动装：把 `skills/voice-preserving-essay-editor/` 整个文件夹复制到 `~/.claude/skills/`。

### Codex

把 `skills/voice-preserving-essay-editor/` 复制到 `~/.codex/skills/`（项目级则放 `.codex/skills/`）。

### 任意 AI 聊天工具（ChatGPT / Gemini / DeepSeek / Kimi / 豆包……）

**不用安装。** 打开 [`dist/voice-preserving-essay-editor.md`](dist/voice-preserving-essay-editor.md)，把**全部内容**复制，作为第一条消息粘贴进去，然后贴上你的稿子。

这个文件是所有规则的完整合订版，不依赖任何外部文件、插件或 API。

### 装好之后怎么用

直接说人话就行，skill 会自动触发：

> 帮我整理这份口播稿。
> 这是语音转写的，整理一下，保留我的语气。
> 检查这篇稿子的段落节奏和 AI 味。

---

## 仓库结构

```
.
├── skills/voice-preserving-essay-editor/   ← 规则源文件（唯一真相）
│   ├── SKILL.md                            入口：任务、优先级、硬约束、路由
│   ├── references/                         按需加载的细则
│   └── agents/openai.yaml                  Codex UI 元数据
├── dist/
│   └── voice-preserving-essay-editor.md    ← 单文件完整版（自动生成，给 chatbot 用）
├── examples/                                原稿 → 成稿 对照，附逐条规则解释
└── scripts/build-dist.sh                    由 skills/ 生成 dist/
```

**两种交付形态**：`skills/` 是按需加载的拆分版（给 Claude Code / Codex 用）；`dist/` 是全部规则合订的单文件版（给没有 skill 机制的工具用）。`dist/` 由脚本生成，改规则只改 `skills/`，然后跑：

```bash
bash scripts/build-dist.sh
```

---

## 设计原则

这个 skill 本身遵守它要求的写作原则：段落有骨架，短句有锋芒，长短交替，但不碎。规则分三层——

1. **SKILL.md**：任务本质、编辑优先级、事实与观点边界、AI 味红线、段落硬约束
2. **references/**：段落节奏、排版、编辑边界、AI 味清单、执行流程与自检
3. **执行流程**：先修事实 → 再修结构 → 最后修句子 → 输出前逐项自检

最后一道自检是一个问题：

> **我是在整理作者，还是在替作者写作？**

---

## 贡献

见 [CONTRIBUTING.md](CONTRIBUTING.md)。核心约束只有一条：**这是累计式 skill，只增量优化不回退**——新规则只能增加或细化，不得删除已确认有效的旧规则。

## License

[MIT](LICENSE) © 2026 十八木
