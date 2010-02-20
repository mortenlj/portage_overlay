# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="NRK Nett-TV as a filesystem"
HOMEPAGE="http://wiki.github.com/klakegg/nrkfs"
SRC_URI="http://dummy.invalid/${P}.tar.gz"
LICENSE="GPL"
KEYWORDS="~x86"
SLOT="0"
IUSE=""
DEPEND="dev-python/fuse-python
    dev-python/beautifulsoup"
RDEPEND="${DEPEND}"
RESTRICT="fetch"
