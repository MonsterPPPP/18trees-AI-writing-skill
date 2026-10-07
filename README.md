<p align="center">
  <img src="./assets/banner.webp" alt="十八木" width="100%" />
</p>

<p align="center">
  中文 · <a href="./README.en.md">English</a>
</p>

# 18trees-AI-writing-skill

把中文口播稿、粗糙随笔或知识学习对话，整理成**仍然明显像你自己写的**文章。Agent 按文章的主要目的自动选择个人随笔或知识型随笔模式。

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 它解决什么问题

你用语音输入写东西，转写出来是一坨：口水词、反复的“我觉得”、断句乱、专名错、一整块不分段。讨论技术问题时，还可能混着错误猜测、AI 回复和未核实的公式或代码。

**直接丢给 AI 整理，问题更大。** 它会替你升华结论、把观点写软、塞进"不是……而是……"、拆成一堆 bullet list、加粗到发光。文章变干净了，但读起来不像你了。

这个 skill 反过来：**整理优先于润色，作者保真与知识准确同时成立**。个人随笔模式清理口播污染，保留判断和语气；知识型模式核验可检验的技术论证，保留真实的提问与理解过程。

- ✅ 修 ASR 错误、错别字、专名、事实错误
- ✅ 逐处清理口癖、机械重复、断句污染和半截句；保留有意义的犹豫与认识变化
- ✅ 重排段落、标题、加粗、排版
- ✅ 对知识型随笔核对关键前提、公式、代码和对话归属；无法核实的核心内容明确标出
- ❌ 不替你升华结论
- ❌ 不把强判断写成"可能""也许"
- ❌ 不加"不是……而是……"这类 AI 味句式
- ❌ 不把随笔改成公众号鸡汤或咨询报告

现有[真实对照](examples/)展示个人口播模式：一份 620 字的原稿、整理后的成稿，以及改动依据。知识型模式的规则来自作者提供的《知识型随笔写作规范 v0.1》；仓库暂未收录真实的知识型前后对照。

## 两种写作模式

| 稿件主要目的 | Agent 安装后 | 手动复制给聊天工具或 Coding Agent |
| --- | --- | --- |
| 表达个人经历、观点和感受；技术词只是联想或比喻 | 自动选个人口播与随笔模式 | 复制[个人随笔完整提示词](dist/voice-preserving-essay-editor.md) |
| 讲清工程、数学、代码或科学问题的知识和推理；个人经历用于引出问题 | 自动选知识型随笔模式 | 复制[知识型随笔完整提示词](dist/knowledge-essay-editor.md) |

用户明确指定风格时按用户要求；混合稿按文章主线选择，并在相关段落兼顾另一种内容。两份可复制文件各自完整，**只复制其中一份**。知识型模式会核对可检验的命题，但不会把 AI 的回答冒充作者的发现，也不会替作者改变价值判断。

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

**不用安装。** 按上表选择一个 `dist/` 文件，把**全部内容**复制，作为第一条消息粘贴进去，然后贴上你的稿子。

每个文件都是对应模式的完整规则，不依赖其他仓库文件、插件或 API。知识核验仍需所用工具具备相应资料访问能力；无法核实时，按规则保留疑问或标明未验证。

### 装好之后怎么用

直接说人话就行，skill 会自动触发：

> 帮我整理这份口播稿。
> 这是语音转写的，整理一下，保留我的语气。
> 把这段关于公式和代码的学习对话整理成随笔，核对推导，保留我真正提出的问题。

---

## 仓库结构

```
.
├── skills/voice-preserving-essay-editor/   ← 规则源文件（唯一真相）
│   ├── SKILL.md                            入口：两种模式的选择与共用边界
│   ├── references/                         个人模式、知识模式和按需细则
│   └── agents/openai.yaml                  Codex UI 元数据
├── dist/
│   ├── voice-preserving-essay-editor.md    ← 个人模式完整提示词
│   └── knowledge-essay-editor.md           ← 知识模式完整提示词
├── examples/                                现有个人口播原稿 → 成稿对照
└── scripts/build-dist.sh                    从规则源生成两份 dist/
```

**两种交付形态**：`skills/` 是能自动选模式的拆分版（给 Claude Code / Codex 用）；`dist/` 是按模式分开的单文件版（给手动复制的工具用）。`dist/` 由脚本生成，改规则只改 `skills/`，然后跑：

```bash
bash scripts/build-dist.sh
```

---

## 设计原则

规则分三层——

1. **SKILL.md**：按主要写作目的分流，并约束两种模式共同的作者保真和事实边界。
2. **references/**：个人模式保留既有规则并增加[口癖判断](skills/voice-preserving-essay-editor/references/oral-disfluency.md)；[知识模式](skills/voice-preserving-essay-editor/references/knowledge-essay.md)规定对话归属、知识核验和技术表达。
3. **执行流程**：个人模式清理口播污染；知识模式先辨明来源与知识缺口，再核验、整理和自检。

最后一道自检是一个问题：

> **我是在整理作者，还是在替作者写作？**

---

## 贡献

见 [CONTRIBUTING.md](CONTRIBUTING.md)。核心约束只有一条：**这是累计式 skill，只增量优化不回退**——新规则只能增加或细化，不得删除已确认有效的旧规则。

## License

[MIT](LICENSE) © 2026 十八木
