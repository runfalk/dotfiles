if [ $(uname) == "Linux" ]; then
	# Make commands colorful by default
	alias ls="ls --color=auto"
	alias grep="grep --color=auto"

	# Add auto-complete support
	if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
		# Ubuntu
		. /etc/bash_completion
	elif [ -f /etc/profile.d/bash_completion.sh ]; then
		# Fedora
		. /etc/profile.d/bash_completion.sh
	fi

    # Ensure the terminal listens to window resizing. If this is not set there
    # is a weird line wrap bug on some platforms
    shopt -s checkwinsize
elif [ $(uname) == "Darwin" ]; then
	# Add default linux style colors to macOS
	export CLICOLOR="1"
	export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"

	# Ensure Homebrew is installed ([] must not be used in if)
	if hash brew 2>/dev/null; then
		# Add auto-complete support
		if [ -f $(brew --prefix)/etc/bash_completion ]; then
			. $(brew --prefix)/etc/bash_completion
		fi
	fi
fi

# Replace ls with eza if it's installed
if hash eza 2> /dev/null; then
    alias ls="eza"
fi

# Add ~/.local/bin to patch since it is a common installation location
PATH="$PATH:$HOME/.local/bin"

# Recursively print MD5 checksum of all files within the current directory
md5r() {
	find $1 -type f|xargs md5sum|sed s#$1/##
}

# Run all custom bash commands by default
if [ -d "$HOME/.bashrc.d" ]; then
	for i in $HOME/.bashrc.d/*; do
		if [ -r "$i" ]; then
			source "$i"
		fi
	done
	unset i
fi
