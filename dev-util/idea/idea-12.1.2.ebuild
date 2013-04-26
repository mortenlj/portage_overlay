# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

BUILD=129.354

S="${WORKDIR}/${PN}-IU-${BUILD}"
DESCRIPTION="An intelligent Java IDE intensely focused on developer productivity."
HOMEPAGE="http://www.jetbrains.com/idea/index.html"
SRC_URI="http://download.jetbrains.com/idea/ideaIU-${PV}.tar.gz"
SLOT="0"
LICENSE="|| (
	IntelliJ-IDEA-academic
	IntelliJ-IDEA-classroom
	IntelliJ-IDEA-commercial
	IntelliJ-IDEA-personal
	IntelliJ-IDEA-opensource )"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jdk-1.6"

QA_TEXTRELS_x86="opt/${P}/bin/libbreakgen.so"

src_install () {
	dodir /usr/bin
	dodir /opt/${P}/
	dodir /usr/share/pixmaps

	insinto /opt/${P}/bin

	# Install executables
	insopts -m0755
	doins bin/idea.sh bin/inspect.sh

	# Install data files
	insopts -m0644
	doins bin/appletviewer.policy bin/libbreakgen.so bin/log.xml
	doins bin/idea.vmoptions bin/idea.properties
	insinto /opt/${P}
	doins -r help lib plugins redist license

	# Install pixmaps
	insinto /usr/share/pixmaps
	doins bin/*.png

	# Install documentation
	dodoc *.txt

	# Install default VM-options
	insinto /etc/env.d
	doins ${FILESDIR}/99idea
	insinto /etc
	doins ${FILESDIR}/idea.vmoptions

	# Launchers are necessary as IDEA depends on the fact being called from its
	# homedir.
	for i in idea inspect; do
		ln -s "${D}/opt/${P}/bin/$i.sh" "${D}/usr/bin/$i"
	done

	make_desktop_entry idea "Intellij IDEA" idea "Development;IDE"
}
