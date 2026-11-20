if test (uname) = Darwin
    fish_add_path --prepend /nix/var/nix/profiles/default/bin

    set -l android_home "$HOME/Library/Android/sdk"
    if test -d "$android_home"
        set -gx ANDROID_HOME "$android_home"
        fish_add_path --prepend "$ANDROID_HOME/platform-tools"
    end

    if not set -q JAVA_HOME
        for java_home in /opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home /usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home
            if test -d "$java_home"
                set -gx JAVA_HOME "$java_home"
                break
            end
        end
    end
    if set -q JAVA_HOME; and test -d "$JAVA_HOME/bin"
        fish_add_path --prepend "$JAVA_HOME/bin"
    end
    if test -d "$HOME/.maestro/maestro/bin"
        fish_add_path --prepend "$HOME/.maestro/maestro/bin"
    end
    fish_add_path --append "$HOME/.cargo/bin"
end
