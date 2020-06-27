import re
import subprocess
from powerline_shell.utils import ThreadedSegment


class Segment(ThreadedSegment):
    def run(self):
        try:
            is_wsl_prog = re.compile('microsoft', flags=re.IGNORECASE)
            is_wsl2_prog = re.compile('microsoft')

            p1 = subprocess.Popen(["uname", "-r"], stdout=subprocess.PIPE)
            self.uname = p1.communicate()[0].decode("utf-8").rstrip()

            self.is_wsl = bool(is_wsl_prog.search(self.uname))
            self.is_wsl2 = bool(is_wsl2_prog.search(self.uname))
        except OSError:
            self.uname = None

    def add_to_powerline(self):
        self.join()
        if not self.uname:
            return
        if not self.is_wsl:
            return
        self.powerline.append(
            " WSL " if not self.is_wsl2 else " WSL2 ",
            self.segment_def.get("fg_color", self.powerline.theme.PATH_FG),
            self.segment_def.get("bg_color", self.powerline.theme.PATH_BG))

