#!/usr/bin/env bash
# 从 skill 的模式规则生成两份可独立复制的单文件提示词。
# Agent 安装时由 SKILL.md 自动选模式；手动使用时只复制对应的一个文件。

set -euo pipefail
cd "$(dirname "$0")/.."

SKILL_DIR="skills/voice-preserving-essay-editor"
VERSION="$(sed -n 's/^  version: *"\{0,1\}\([^"]*\)"\{0,1\} *$/\1/p' "$SKILL_DIR/SKILL.md" | head -1)"
[ -n "$VERSION" ] || { echo "无法从 SKILL.md 读取版本号" >&2; exit 1; }

mkdir -p dist

emit_intro() {
  local title="$1"
  printf '# %s v%s\n\n' "$title" "$VERSION"
  cat <<'INTRO'
> **怎么用**：把本文件全部复制，作为第一条消息粘贴给任意 AI 聊天工具，
> 然后在第二条消息里贴上你的原稿。本文件是完整提示词，不需要安装插件或读取外部文件。
>
> 只整理作者提供的材料；交付 Markdown 正文不代表自动发布到平台。

---

INTRO
}

emit_ref() {
  local name="$1"
  sed '/<!-- dist:strip-start -->/,/<!-- dist:strip-end -->/d; s/^# /## /' "$SKILL_DIR/references/$name.md" \
    | sed -E 's/\[([^]]+)\]\([[:alnum:]-]+\.md\)/\1/g'
  printf '\n---\n\n'
}

emit_footer() {
  cat <<'FOOTER'
*本文件由 `scripts/build-dist.sh` 从 `skills/voice-preserving-essay-editor/` 自动生成，请勿直接编辑。*
*仓库：https://github.com/MonsterPPPP/18trees-AI-writing-skill · License: MIT*
FOOTER
}

{
  emit_intro "中文口播与个人随笔整理器 · Voice-Preserving Essay Editor"
  emit_ref personal-essay
  for ref in core-principles ai-tells paragraph-rhythm formatting editing-boundaries oral-disfluency workflow-checklist; do
    emit_ref "$ref"
  done
  emit_footer
} > dist/voice-preserving-essay-editor.md

{
  emit_intro "知识型随笔整理器 · Knowledge Essay Editor"
  emit_ref knowledge-essay
  emit_footer
} > dist/knowledge-essay-editor.md

echo "已生成 dist/voice-preserving-essay-editor.md 和 dist/knowledge-essay-editor.md"
