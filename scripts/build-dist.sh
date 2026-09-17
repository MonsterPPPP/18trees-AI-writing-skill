#!/usr/bin/env bash
# 把 skills/voice-preserving-essay-editor/ 下的 SKILL.md + references/ 拼合成
# dist/ 里的单文件全约束版（供用户直接复制粘贴给任意 chatbot）。
#
# 为什么要有这个脚本：拆分版和单文件版必须内容一致，手抄必然走样。
# 规则只维护在 skills/ 里，dist/ 是生成物 —— 改完规则跑一次本脚本即可。

set -euo pipefail
cd "$(dirname "$0")/.."

SKILL_DIR="skills/voice-preserving-essay-editor"
OUT="dist/voice-preserving-essay-editor.md"

VERSION="$(sed -n 's/^  version: *"\{0,1\}\([^"]*\)"\{0,1\} *$/\1/p' "$SKILL_DIR/SKILL.md" | head -1)"
[ -n "$VERSION" ] || { echo "无法从 SKILL.md 读取版本号" >&2; exit 1; }

mkdir -p dist

{
  cat <<EOF
# 中文口播稿整理器 · Voice-Preserving Essay Editor v${VERSION}

> **怎么用**：把本文件**全部内容**复制，作为第一条消息粘贴给任意 AI 聊天工具
> （ChatGPT / Claude / Gemini / DeepSeek / Kimi / 豆包 等），然后在第二条消息里贴上你要整理的口播稿。
>
> 不需要安装任何插件、skill 或 API。本文件是**完整版**，所有规则都在这里，不依赖任何外部文件。

---

EOF

  # SKILL.md 正文（去掉 YAML frontmatter；H1 降为 H2 与 references 平级；
  # 剥掉 dist:strip 标记的路由表 —— 单文件版里所有内容都已内联，路由无意义）
  sed '1{/^---$/!q}; 1,/^---$/d' "$SKILL_DIR/SKILL.md" \
    | sed '/<!-- dist:strip-start -->/,/<!-- dist:strip-end -->/d' \
    | sed 's/^# /## /'

  echo
  echo "---"
  echo

  for ref in core-principles ai-tells paragraph-rhythm formatting editing-boundaries workflow-checklist; do
    sed 's/^# /## /' "$SKILL_DIR/references/${ref}.md"
    echo
    echo "---"
    echo
  done

  cat <<'FOOTER'
*本文件由 `scripts/build-dist.sh` 从 `skills/voice-preserving-essay-editor/` 自动生成，请勿直接编辑。*
*仓库：https://github.com/MonsterPPPP/18trees-AI-writing-skill · License: MIT*
FOOTER
} > "$OUT"

echo "已生成 $OUT"
