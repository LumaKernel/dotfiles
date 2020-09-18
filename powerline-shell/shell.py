import os
from powerline_shell.utils import ThreadedSegment


class Segment(ThreadedSegment):
    def add_to_powerline(self):
        self.join()
        if 'shell_name' not in os.environ:
            return
        self.powerline.append(
            " " + os.environ['shell_name'] + " ",
            0,
            157,
        )
