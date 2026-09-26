#!/usr/bin/env bash
# Claude Code statusLine — cute palette, no powerline glyphs required
# Segments: [vim] cwd  branch±  CAVEMAN  model  ctx%

RESET='\033[0m'

# Cute palette (truecolor)
C_VIM='\033[38;2;187;131;219m'    # purple
C_DIR='\033[38;2;255;119;169m'    # pink
C_GIT='\033[38;2;255;143;184m'    # light pink
C_MODEL='\033[38;2;135;198;254m'  # sky blue
C_CTX='\033[38;2;78;154;212m'     # steel blue
C_CAVEMAN='\033[38;2;255;165;0m'  # orange

SEP='  '  # plain space separator — no Nerd Font needed

# --- Read JSON from stdin (Claude Code sends it; timeout guards against hang) ---
input=$(timeout 1 cat 2>/dev/null || true)

_jq() { printf '%s' "$input" | jq -r "$1 // empty" 2>/dev/null; }

# Try multiple possible field paths Claude Code might use
cwd=$(_jq '.cwd'); [ -z "$cwd" ] && cwd=$(_jq '.workspace.cwd'); [ -z "$cwd" ] && cwd=$(_jq '.workspace.current_dir')
model=$(_jq '.model.display_name'); [ -z "$model" ] && model=$(_jq '.model.name'); [ -z "$model" ] && model=$(_jq '.model | if type == "string" then . else empty end')
used_pct=$(_jq '.context_window_usage_pct'); [ -z "$used_pct" ] && used_pct=$(_jq '.context_window.used_percentage'); [ -z "$used_pct" ] && used_pct=$(_jq '.context.used_percentage')
vim_mode=$(_jq '.vim_mode'); [ -z "$vim_mode" ] && vim_mode=$(_jq '.vim.mode'); [ -z "$vim_mode" ] && vim_mode=$(_jq '.editor.vim_mode')

# --- Fish-style abbreviated path ---
short_cwd="${cwd/#$HOME/\~}"
abbreviated=""
if [ -n "$short_cwd" ]; then
	IFS='/' read -ra parts <<< "$short_cwd"
	last_idx=$(( ${#parts[@]} - 1 ))
	for i in "${!parts[@]}"; do
		part="${parts[$i]}"
		if [ $i -eq $last_idx ]; then
			abbreviated="${abbreviated}${part}"
		elif [ "$part" = "~" ]; then
			abbreviated="~/"
		elif [ -z "$part" ]; then
			continue
		else
			abbreviated="${abbreviated}${part:0:1}/"
		fi
	done
fi

# --- Git branch + status ---
git_segment=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
	branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
		|| git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
	flags=""
	status_out=$(git -C "$cwd" status --porcelain 2>/dev/null)
	echo "$status_out" | grep -qE '^[MADRC]'  && flags="${flags}+"
	echo "$status_out" | grep -qE '^.[MD]'    && flags="${flags}!"
	echo "$status_out" | grep -qE '^\?\?'     && flags="${flags}?"
	ahead=$(git -C "$cwd" rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
	behind=$(git -C "$cwd" rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
	[ "$ahead"  -gt 0 ] 2>/dev/null && flags="${flags}⇡"
	[ "$behind" -gt 0 ] 2>/dev/null && flags="${flags}⇣"
	[ -n "$branch" ] && git_segment="${branch}${flags:+ ${flags}}"
fi

# --- Context bar ---
ctx_segment=""
if [ -n "$used_pct" ]; then
	used_int=$(printf '%.0f' "$used_pct")
	if   [ "$used_int" -ge 90 ]; then bar="▓▓▓▓▓"
	elif [ "$used_int" -ge 70 ]; then bar="▓▓▓▓░"
	elif [ "$used_int" -ge 50 ]; then bar="▓▓▓░░"
	elif [ "$used_int" -ge 25 ]; then bar="▓▓░░░"
	else                               bar="▓░░░░"
	fi
	ctx_segment="ctx:${used_int}% ${bar}"
fi

# --- Vim mode ---
vim_segment=""
if [ -n "$vim_mode" ]; then
	case "$vim_mode" in
		INSERT)       vim_segment="[I]" ;;
		NORMAL)       vim_segment="[N]" ;;
		VISUAL)       vim_segment="[V]" ;;
		"VISUAL LINE") vim_segment="[VL]" ;;
		*)            vim_segment="[${vim_mode}]" ;;
	esac
fi

# --- Caveman badge (identical logic to caveman-statusline.sh) ---
caveman_segment=""
FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-active"
if [ ! -L "$FLAG" ] && [ -f "$FLAG" ]; then
	MODE=$(head -c 64 "$FLAG" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]')
	MODE=$(printf '%s' "$MODE" | tr -cd 'a-z0-9-')
	case "$MODE" in
		off) ;;  # active flag exists but mode is off — show nothing
		lite|full|ultra|wenyan-lite|wenyan|wenyan-full|wenyan-ultra|commit|review|compress)
			if [ -z "$MODE" ] || [ "$MODE" = "full" ]; then
				caveman_segment="[CAVEMAN]"
			else
				caveman_segment="[CAVEMAN:$(printf '%s' "$MODE" | tr '[:lower:]' '[:upper:]')]"
			fi
			;;
	esac
elif [ -n "${CAVEMAN_LEVEL:-}" ]; then
	caveman_segment="[CAVEMAN:$(printf '%s' "$CAVEMAN_LEVEL" | tr '[:lower:]' '[:upper:]')]"
fi

# --- Assemble ---
out=""

[ -n "$vim_segment" ]    && out="${out}${C_VIM}${vim_segment}${RESET}${SEP}"
[ -n "$abbreviated" ]    && out="${out}${C_DIR}${abbreviated}${RESET}${SEP}"
[ -n "$git_segment" ]    && out="${out}${C_GIT}${git_segment}${RESET}${SEP}"
[ -n "$caveman_segment" ] && out="${out}${C_CAVEMAN}${caveman_segment}${RESET}${SEP}"
[ -n "$model" ]          && out="${out}${C_MODEL}${model}${RESET}${SEP}"
[ -n "$ctx_segment" ]    && out="${out}${C_CTX}${ctx_segment}${RESET}"

printf "%b\n" "$out"
