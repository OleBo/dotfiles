# -*- coding: utf-8 -*-


import rlcompleter
import readline
import atexit
import os
import sys
import pprint


# Enable tab completion.
# Source: https://docs.python.org/3/library/rlcompleter.html
readline.parse_and_bind("tab: complete")

# Enable history file.
# Source: https://docs.python.org/3/library/readline.html
# supports concurrent interactive sessions, by only appending the new history.
histfile = os.path.join(os.path.expanduser("~"), ".python_history")

try:
    readline.read_history_file(histfile)
    h_len = readline.get_current_history_length()
except FileNotFoundError:
    open(histfile, 'wb').close()
    h_len = 0


def save(prev_h_len, histfile):
    new_h_len = readline.get_current_history_length()
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
    readline.append_history_file(new_h_len - prev_h_len, histfile)


atexit.register(save, h_len, histfile)


# Enable pretty printing for stdout.
orig_displayhook = sys.displayhook


def myhook(value):
    if value is not None:
        __builtins__._ = value
        pprint.pprint(value)


__builtins__.pprint_on = lambda: setattr(sys, 'displayhook', myhook)
__builtins__.pprint_off = lambda: setattr(sys, 'displayhook', orig_displayhook)
__builtins__.pprint_usage = \
    """
    >>> data = dict.fromkeys(range(10))
    >>> data
    {0: None, 1: None, 2: None, 3: None, 4: None}
    >>> pprint_on()
    >>> data
    {0: None,
     1: None,
     2: None,
     3: None,
     4: None}
    >>> pprint_off()
    >>> data
    {0: None, 1: None, 2: None, 3: None, 4: None}
    """
pprint_on()

print(
    'Persistent session history, tab completion and pretty printing are'
    ' enabled.')
