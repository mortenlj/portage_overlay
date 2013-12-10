# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

BUILD=129.1359

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

QA_TEXTRELS="opt/${P}/bin/libbreakgen*.so opt/${P}/bin/libyjpagent-linux*.so"

src_install () {
	dodir /usr/bin
	dodir /opt/${P}/
	dodir /usr/share/pixmaps

	insinto /opt/${P}/bin

	# Install executables
	insopts -m0755
	doins bin/idea.sh bin/inspect.sh
	doins bin/fsnotifier bin/fsnotifier64

	# Install data files
	insopts -m0644
	doins bin/appletviewer.policy bin/libbreakgen.so bin/libbreakgen64.so bin/libyjpagent-linux.so bin/libyjpagent-linux64.so bin/log.xml
	doins bin/idea.vmoptions bin/idea64.vmoptions bin/idea.properties
	insinto /opt/${P}
	doins -r help lib plugins redist license

	# Install pixmaps
	insinto /usr/share/pixmaps
	newins bin/idea.png idea-${SLOT}.png

	# Install documentation
	dodoc *.txt

	# Install default VM-options
	insinto /etc/env.d
	newins ${FILESDIR}/99idea 99idea-${SLOT}
	insinto /etc
	doins ${FILESDIR}/idea.vmoptions

	# Launchers are necessary as IDEA depends on the fact being called from its
	# homedir.
	for i in idea inspect; do
		dosym ${D}/opt/${P}/bin/${i}.sh /usr/bin/${i}-${SLOT}
	done

	make_desktop_entry idea-${SLOT} "Intellij IDEA ${PV}" idea-${SLOT} "Development;IDE"
}
