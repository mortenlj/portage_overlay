#!/usr/bin/ebuild

EAPI=5

inherit eutils

BUILD=173.3942.27

S="${WORKDIR}/${PN}-IU-${BUILD}"
DESCRIPTION="An intelligent Java IDE intensely focused on developer productivity."
HOMEPAGE="http://www.jetbrains.com/idea/index.html"
SRC_URI="http://download.jetbrains.com/idea/ideaIU-${PV}.tar.gz"
SLOT=2017
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

QA_TEXTRELS="opt/${P}/bin/libyjpagent-linux*.so"

src_install () {
	dodir /usr/bin
	dodir /opt/${P}/
	dodir /usr/share/pixmaps


	# Install executables
	exeinto /opt/${P}/bin
	doexe bin/idea.sh bin/inspect.sh bin/format.sh
	doexe bin/fsnotifier bin/fsnotifier-arm bin/fsnotifier64
	doexe bin/printenv.py bin/restart.py

	# Install data files
	insinto /opt/${P}/bin
	insopts -m0644
	doins bin/appletviewer.policy bin/libyjpagent-linux.so bin/libyjpagent-linux64.so bin/log.xml
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

	dosym ${D}opt/${P}/bin/inspect.sh /usr/bin/inspect-${SLOT}

	# We make a wrapper for the idea command to add some cli goodness
	sed -e "s~@@IDEA_EXECUTABLE@@~/opt/${P}/bin/idea.sh~g" ${FILESDIR}/idea-wrapper.sh > ${T}/idea-${SLOT} || die "sed failed"
	exeinto /usr/bin
	doexe ${T}/idea-${SLOT}

	make_desktop_entry idea-${SLOT} "Intellij IDEA ${PV}" idea-${SLOT} "Development;IDE"
}
