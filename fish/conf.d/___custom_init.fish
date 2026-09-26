# I placed this file here to run any configuration before plugins load

# Set this to stop grc breaking the async prompt plugin
set -gx grc_plugin_ignore_execs env

# Fixes alt-left/right to change dirs not updating in the prompt
# also fixes jobs?? or not??
set async_prompt_on_variable fish_bind_mode PWD status
