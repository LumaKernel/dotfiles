import os
from powerline_shell.utils import ThreadedSegment

colors = {
    'fish': 157,
    'bash': 221,
}

class Segment(ThreadedSegment):
    def add_to_powerline(self):
        self.join()
        if 'shell_name' not in os.environ:
            return
        shell_name = os.environ.get('shell_name', '')
        self.powerline.append(
            " " + shell_name + " ",
            0,
            colors.get(shell_name, 255),
        )
