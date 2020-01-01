#!/usr/bin/ebuild

EAPI=5

inherit eutils

BUILD=193.5233.102

S="${WORKDIR}/${PN}-IU-${BUILD}"
DESCRIPTION="An intelligent Java IDE intensely focused on developer productivity."
HOMEPAGE="http://www.jetbrains.com/idea/index.html"
SRC_URI="http://download.jetbrains.com/idea/ideaIU-${PV}.tar.gz"
SLOT=2019
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
RDEPEND=">=virtual/jdk-1.8"

src_install () {
	dodir /usr/bin
	dodir /opt/${P}/
	dodir /usr/share/pixmaps


	# Install executables
	exeinto /opt/${P}/bin
	doexe bin/idea.sh bin/inspect.sh bin/format.sh
	doexe bin/fsnotifier bin/fsnotifier64
	doexe bin/printenv.py bin/restart.py

	# Install data files
	insinto /opt/${P}/bin
	insopts -m0644
	doins bin/libdbm64.so bin/appletviewer.policy bin/log.xml
	doins bin/idea.vmoptions bin/idea64.vmoptions bin/idea.properties
	insinto /opt/${P}
	doins -r help lib plugins redist license jbr
	doins build.txt product-info.json

	# Clear out some problematic files not needed for x86/amd64
	rm -rf ${ED}opt/${P}/plugins/tfsIntegration/lib/native/{aix,freebsd,hpux,macosx,solaris,win32}
	rm -rf ${ED}opt/${P}/plugins/tfsIntegration/lib/native/linux/{arm,ppc}

	# Install pixmaps
	insinto /usr/share/pixmaps
	newins bin/idea.png idea-${SLOT}.png
	newins bin/idea.svg idea-${SLOT}.svg

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
