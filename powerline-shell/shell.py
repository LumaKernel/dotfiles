import os
from powerline_shell.utils import ThreadedSegment

colors = {
    'fish': 157,
    'bash': 221,
}

class Segment(ThreadedSegment):
    def add_to_powerline(self):
        self.join()
        if 'SHELL_NAME' not in os.environ:
            return
        SHELL_NAME = os.environ.get('SHELL_NAME', '')
        self.powerline.append(
            " " + SHELL_NAME + " ",
            0,
            colors.get(SHELL_NAME, 255),
        )
