set -l BASE_URL 'https://api.github.com'
set -l USER_AGENT 'curl'

function license --description 'Fetch licenses from choosealicense.com'
	set -l argc (count $argv)

	if test $argc = 0
		set -l li_key (curl -fsSL -A 'curl' "https://api.github.com/licenses" -o - | jq -r '.[].key' | fzf)

		if test (string length "$li_key") -eq 0
			return 1
		end
		set -f li_name "$li_key"
	else
		set -f li_name $argv[1]
	end
	set -l year (date +'%Y')
	curl -fsSL -A 'curl' "https://api.github.com/licenses/$li_name" | jq -r '.body' | sed -e "s/\[year\]/$year/" -e "s/\[fullname\]/Benjamin Brassart/" -e '$d'
end
