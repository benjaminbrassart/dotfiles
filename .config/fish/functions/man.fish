function man --wraps man
	set -lx PAGER 'nvim +Man!'

	command man $argv
end
