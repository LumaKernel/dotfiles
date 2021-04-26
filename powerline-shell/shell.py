import os
from powerline_shell.utils import ThreadedSegment

definitions = {
    'fish': {
        'abbr': 'fi',
        'color': 157,
    },
    'bash': {
        'abbr': 'ba',
        'color': 221,
    },
}

class Segment(ThreadedSegment):
    def add_to_powerline(self):
        self.join()
        if 'SHELL_NAME' not in os.environ:
            return
        shell_name = os.environ.get('SHELL_NAME', '')
        this_definition = definitions.get(shell_name, {})
        self.powerline.append(
            ' ' + this_definition.get('abbr', '?') + ' ',
            0,
            this_definition.get('color', 255),
        )
