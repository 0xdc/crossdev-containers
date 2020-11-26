#! /usr/bin/env python
"""
Get gcc versions from the portage tree
"""

import portage

[ print(x.split('-', 2)[2]) for x in portage.portdb.match('sys-devel/gcc') ]
