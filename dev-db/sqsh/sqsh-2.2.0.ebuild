# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/dircproxy/dircproxy-1.2.0_rc1.ebuild,v 1.5 2010/04/13 18:39:38 armin76 Exp $

EAPI=5

inherit eutils

DESCRIPTION="Sybase isql replacement"
HOMEPAGE="http://sourceforge.net/projects/sqsh/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

DEPEND="sys-libs/readline"

src_configure() {
    if [ -z "${SYBASE}" ]; then
        die "You must have Sybase installed, and the SYBASE environment variable set"
    fi
    econf --with-readline
}

