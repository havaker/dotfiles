function venv
    set -x VIRTUAL_ENV_DISABLE_PROMPT yes
    source (find . -name 'activate.fish' | head -n 1)
end
