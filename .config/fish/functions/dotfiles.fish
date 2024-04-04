set -l CARGO_PACKAGE_FILE $XDG_CONFIG_HOME/cargo.txt

function dotfiles --description 'Manage dotfiles'
    if test (count $argv) = 0
        echo "Available sub-commands: cargo" >&2
        return
    end

    set -l cmd $argv[1]

    switch $cmd
    case cargo
        set -l argv $argv[1:]

        if test (count $argv) = 0
            return
        end

        set -l cmd $argv[1]

        switch $cmd
        case install
            set -l cargo_packages (command cat $CARGO_PACKAGE_FILE)

            cargo install --locked --jobs=$CPU_COUNT -- $cargo_packages
        case update
            jq -r '.installs | keys | .[]' < $XDG_CONFIG_HOME/.cargo/.crates2.json | cut -d ' ' -f 1 > $CARGO_PACKAGE_FILE
        case list
            command cat $CARGO_PACKAGE_FILE
        case '*'
            echo "" >&2
            return 1
        end
    case '*'
        echo "Invalid sub-command $cmd" >&2
        return 1
    end
end
