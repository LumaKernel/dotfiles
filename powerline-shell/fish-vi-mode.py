import os
import re
import subprocess
from powerline_shell.utils import ThreadedSegment


vi_modes = {
        'default': {
            'screen': 'N',
            'fg': 0,
            'bg': 154,
        },
        'insert': {
            'screen': 'I',
            'fg': 0,
            'bg': 111,
        },
        'replace_one': {
            'screen': 'R',
            'fg': 0,
            'bg': 220,
        },
        'visual': {
            'screen': 'V',
            'fg': 0,
            'bg': 219,
        },
    }


class Segment(ThreadedSegment):
    def add_to_powerline(self):
        self.join()
        if not(
                'powerline_fish_key_bindings' in os.environ
                and 'powerline_fish_bind_mode' in os.environ ):
            return
        fish_key_bindings = os.environ['powerline_fish_key_bindings']
        fish_bind_mode = os.environ['powerline_fish_bind_mode']
        if fish_key_bindings != 'fish_vi_key_bindings':
            return
        if not( fish_bind_mode in vi_modes ):
            self.powerline.append(
                    " " + fish_bind_mode + " ",
                    0,
                    15)
            return
        self.powerline.append(
                " " + vi_modes[fish_bind_mode]['screen'] + " ",
                vi_modes[fish_bind_mode]['fg'],
                vi_modes[fish_bind_mode]['bg'])

