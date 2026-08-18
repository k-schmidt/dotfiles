#!/bin/bash

set -u -o pipefail

validation_failed=0
rendered_file="$(mktemp)"
trap 'rm -f "$rendered_file"' EXIT

for source_file in "$@"; do
	input_file="$source_file"

	if [[ "$source_file" == *.tmpl ]]; then
		if ! chezmoi execute-template <"$source_file" >"$rendered_file"; then
			echo "Failed to render $source_file" >&2
			validation_failed=1
			continue
		fi
		input_file="$rendered_file"
	fi

	case "$source_file" in
	dot_bash_profile | dot_bashrc)
		shell_name="bash"
		;;
	dot_p10k.zsh | dot_zshrc)
		shell_name="zsh"
		;;
	*)
		shebang=""
		IFS= read -r shebang <"$input_file" || true
		case "$shebang" in
		*bash*) shell_name="bash" ;;
		*zsh*) shell_name="zsh" ;;
		*'/sh') shell_name="sh" ;;
		*)
			echo "Cannot determine the shell for $source_file" >&2
			validation_failed=1
			continue
			;;
		esac
		;;
	esac

	if ! "$shell_name" -n "$input_file"; then
		echo "Shell syntax validation failed for $source_file" >&2
		validation_failed=1
	fi
done

exit "$validation_failed"
