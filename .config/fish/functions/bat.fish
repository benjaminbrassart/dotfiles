function bat --wraps batcat
	set -lx PAGER less
	set -lx GROFF_NO_SGR 1

	command batcat $argv
end
