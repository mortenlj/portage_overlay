# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/maven-bin/maven-bin-3.0.4-r1.ebuild,v 1.5 2012/12/22 15:39:57 ago Exp $

EAPI="4"

inherit java-pkg-2

MY_BUILD="2138"
MY_PN="davmail"
MY_P="${MY_PN}-linux-x86_64-${PV}-${MY_BUILD}"

DESCRIPTION="DavMail POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange Gateway"
SRC_URI="http://downloads.sourceforge.net/project/${MY_PN}/${MY_PN}/${PV}/${MY_P}.tgz"
HOMEPAGE="http://davmail.sourceforge.net/"

LICENSE="GPL"
SLOT="4.2"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.6
	${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	local dest="/opt/${MY_P}"
	local ddest="${ED}${dest}"

	dodir "${dest}"
	cp -Rp davmail.* lib "${ddest}" || die "failed to copy"

	java-pkg_regjar "${ddest}"/lib/*.jar
	java-pkg_regjar "${ddest}"/davmail.jar

	dodir /usr/bin
	# From davmail.sh
	# BASE=`dirname $0`
	# for i in $BASE/lib/*; do export CLASSPATH=$CLASSPATH:$i; done
	# java -cp $BASE/davmail.jar:$CLASSPATH davmail.DavGateway $1
	java-pkg_dolauncher davmail --main davmail.DavGateway --jar davmail
}
