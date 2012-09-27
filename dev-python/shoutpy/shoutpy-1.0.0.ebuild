# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils eutils

DESCRIPTION="Python bindings for libshout2.1 or higher"
HOMEPAGE="http://dingoskidneys.com/shoutpy/"
SRC_URI="http://dingoskidneys.com/shoutpy/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"

DEPEND="dev-lang/python
	>=media-libs/libshout-2.1
	>=dev-libs/boost-1.31.0"

# Adjust config
src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/no_library_extend.patch"
}

# Install the example
src_install () {
	distutils_src_install

	insinto /usr/share/doc/${PF}
	doins ${S}/example.py
}
