# AGENTS.md

给 AI 编程助手看的安装与维护说明。

## 这个仓库是什么

一个跨工具 AI skill：把中文口播稿、语音转写和粗糙随笔整理成保留作者声音的文章。

- **规则源文件**：`skills/voice-preserving-essay-editor/`
- **生成物**：`dist/voice-preserving-essay-editor.md`（单文件完整版，由脚本生成，不要直接编辑）

## 安装这个 skill

### Claude Code

项目级：把 `skills/voice-preserving-essay-editor/` 复制到项目的 `.claude/skills/`。
用户级：复制到 `~/.claude/skills/`。

或走插件市场：

```bash
/plugin marketplace add MonsterPPPP/18trees-AI-writing-skill
/plugin install voice-preserving-essay-editor@18trees-ai-writing
```

### OpenAI Codex

项目级：复制到 `.codex/skills/`。用户级：复制到 `~/.codex/skills/`。

目录结构应为：

```
~/.codex/skills/voice-preserving-essay-editor/
├── SKILL.md
├── references/
└── agents/openai.yaml
```

### 其他工具

`SKILL.md` 的 frontmatter 只依赖两个字段：`name` 和 `description`。任何支持 skill / 自定义指令的工具，只要读取这两个字段就能识别本 skill；`references/` 按需读取。

对于不支持 skill 机制的工具（网页版聊天机器人等），直接把 `dist/voice-preserving-essay-editor.md` 的全部内容作为系统提示或首条消息送给模型。

## 修改规则时

1. 只改 `skills/voice-preserving-essay-editor/` 下的文件
2. 运行 `bash scripts/build-dist.sh` 重新生成 `dist/`
3. 两个目录一起提交

**这是累计式 skill——只增量优化，不回退。** 不得删除 `CONTRIBUTING.md` 中列出的 10 条已确认规则。

## 验证改动

- 检查 `dist/` 与 `skills/` 是否一致：重新跑一次 `build-dist.sh`，`git diff` 应无输出
- 检查 frontmatter：`name` ≤ 64 字符，`description` 非空
- 改了规则就对照 `examples/` 走一遍，确认示例仍然符合规则
