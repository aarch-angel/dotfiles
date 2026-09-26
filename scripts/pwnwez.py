import os
import atexit
import subprocess
import json
import sys

import pwndbg
from pwndbg.commands.context import contextoutput

# Setup logging to file
LOG_FILE = os.path.expanduser("~/.pwndbg_wezterm.log")
log_file = open(LOG_FILE, 'w')

def log(msg):
    print(msg, file=log_file)
    log_file.flush()
    print(msg, file=sys.stderr)  # Also to stderr in case we can see it

# Helper function to get pane ID from wezterm and get its TTY
def split_pane(direction, percent=None, target_pane=None, command=None):
    # We'll have the pane write its TTY to a temp file so we can read it
    import tempfile
    tty_file = tempfile.NamedTemporaryFile(mode='w', delete=False, suffix='.tty')
    tty_filename = tty_file.name
    tty_file.close()
    
    cmd = ['wezterm', 'cli', 'split-pane', direction]
    
    if percent:
        cmd.extend(['--percent', str(percent)])
    
    if target_pane:
        cmd.extend(['--pane-id', target_pane])
    
    if command:
        cmd.extend(['--'])
        cmd.extend(command)
    else:
        # Write TTY to file, then keep pane alive with cat
        cmd.extend(['--', 'sh', '-c', f'tty > {tty_filename}; cat -'])
    
    log(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True, check=True)
    pane_id = result.stdout.strip()
    log(f"Got pane ID: {pane_id}")
    
    # Give the pane a moment to write the TTY file
    import time
    time.sleep(0.5)
    
    # Read the TTY from the file
    tty = None
    try:
        with open(tty_filename, 'r') as f:
            tty = f.read().strip()
            log(f"Read TTY from file: {tty}")
    except Exception as e:
        log(f"Error reading TTY file: {e}")
    
    os.unlink(tty_filename)
    
    return (pane_id, tty)

# Create panes with specific layout
# Split vertical to make the main window at the bottom, disasm at top
disasm_id = split_pane('--top', 75)
panes = {'disasm': disasm_id}

# Split vertical to make stack below disasm, keeping disasm at top
stack_id = split_pane('--bottom', 40, disasm_id)
panes['stack'] = stack_id

# Split horizontal next to stack for backtrace on the right
backtrace_id = split_pane('--right', 30, stack_id)
panes['backtrace'] = backtrace_id

# Split horizontal next to disasm for registers on the right
regs_id = split_pane('--right', 30, disasm_id)
panes['regs'] = regs_id

# Split horizontal next to the main pane for julia
julia_id = split_pane('--right', 30, command=['julia'])
panes['julia'] = julia_id

# Get TTY paths for each pane
pane_ttys = {}
for section, pane_id in panes.items():
    tty = get_pane_tty(pane_id)
    if tty:
        pane_ttys[section] = tty
        log(f"Pane {section}: ID={pane_id}, TTY={tty}")
    else:
        log(f"Warning: Could not find TTY for pane {section}")

# Tell pwndbg which panes are to be used for what
for section in ['disasm', 'stack', 'backtrace', 'regs']:
    if section in pane_ttys:
        log(f"Setting contextoutput for {section} to {pane_ttys[section]}")
        contextoutput(section, pane_ttys[section], True, 'top', False)

# Also add the sections legend and expressions to already existing panes
if 'stack' in pane_ttys:
    log(f"Setting contextoutput for legend to {pane_ttys['stack']}")
    contextoutput("legend", pane_ttys['stack'], True)
if 'regs' in pane_ttys:
    log(f"Setting contextoutput for expressions to {pane_ttys['regs']}")
    contextoutput("expressions", pane_ttys['regs'], True, 'top', False)

# To see more options to customize run `theme` and `config` in gdb
# Increase the amount of lines shown in disasm and stack
pwndbg.config.context_disasm_lines.value = 25
pwndbg.config.context_stack_lines.value = "18"
# Give backtrace a little more color
pwndbg.config.backtrace_prefix_color.value = "red,bold"
pwndbg.config.backtrace_address_color.value = "gray"
pwndbg.config.backtrace_symbol_color.value = "red"
pwndbg.config.backtrace_frame_label_color.value = "green"

# Remove the panes when gdb is exited
def cleanup():
    for section, pane_id in panes.items():
        log(f"Closing pane {section} (ID={pane_id})")
        subprocess.run(['wezterm', 'cli', 'close-pane', '--pane-id', pane_id], 
                      capture_output=True)
    log_file.close()

atexit.register(cleanup)
