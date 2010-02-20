# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/dircproxy/dircproxy-1.1.0-r1.ebuild,v 1.5 2006/04/05 17:03:32 mcummings Exp $

inherit subversion eutils

DESCRIPTION="an IRC proxy server"
HOMEPAGE="http://dircproxy.securiweb.net/"
REVISION=679

ESVN_REPO_URI="http://dircproxy.googlecode.com/svn/trunk@${REVISION}"
#              This variable sets the URI from which the sources will be fetched.  The subversion eclass supports fetching from
#              the following protocols: http, https, and svn.  This variable is required to be set.

ESVN_PROJECT="dircproxy-svn"
#              This variable defines the name of the project and defaults to '${PN/-svn}'.

ESVN_BOOTSTRAP="autogen.sh"
#              This variable defines the name of the bootstrap script to execute in preparation for the  build  process.   This
#              variable is empty by default.  Note: "./" is automatically prepended, so it is unnecessary for the ebuild author
#              to do so.

ESVN_OPTIONS=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~amd64 ~sparc"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	subversion_src_unpack
	# We need to create the ChangeLog here
	TZ=UTC svn log -v "${ESVN_REPO_URI} -r ${REVISION} ${ESVN_OPTIONS}" >ChangeLog
	# patch "${S}/src/irc_server.c" "${FILESDIR}/segfault_fix-1.2.0.patch"
	patch "${S}/src/irc_server.c" "${FILESDIR}/action-without-param-segfault_fix-1.2.0.patch"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog FAQ NEWS PROTOCOL README* TODO INSTALL
}
