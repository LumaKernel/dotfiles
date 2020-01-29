import re
import subprocess
from powerline_shell.utils import ThreadedSegment

prog = re.compile('microsoft', flags=re.IGNORECASE)


class Segment(ThreadedSegment):
    def run(self):
        try:
            p1 = subprocess.Popen(["uname", "-a"], stdout=subprocess.PIPE)
            self.uname = p1.communicate()[0].decode("utf-8").rstrip()
        except OSError:
            self.uname = None

    def add_to_powerline(self):
        self.join()
        if not self.uname:
            return
        is_wsl = bool(prog.search(self.uname))
        if not is_wsl:
            return
        self.powerline.append(
            " WSL ",
            self.segment_def.get("fg_color", self.powerline.theme.PATH_FG),
            self.segment_def.get("bg_color", self.powerline.theme.PATH_BG))

