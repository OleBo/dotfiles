# XDG Base Directory

[XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

Single base directory relative to which user-specific configuration files should be written. This directory is defined by the environment variable `$XDG_CONFIG_HOME`. If `$XDG_CONFIG_HOME` is either not set or empty, a default equal to `$HOME/.config` should be used.
