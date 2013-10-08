# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit rpm

MY_PV="0.4.1-6"

DESCRIPTION="Brother's brscan4 scanner driver"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_scn.html#brscan4"
SRC_URI="
	x86? ( brscan4-${MY_PV}.i386.rpm )
	amd64? ( brscan4-${MY_PV}.x86_64.rpm )
"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="fetch strip"
DOWNLOAD_URL="
	x86? (
	http://www.brother.com/cgi-bin/agreement/agreement.cgi?dlfile=http://www.brother.com/pub/bsc/linux/dlf/brscan4-${MY_PV}.i386.rpm&lang=English_lpr )
	amd64? (
	http://www.brother.com/cgi-bin/agreement/agreement.cgi?dlfile=http://www.brother.com/pub/bsc/linux/dlf/brscan4-${MY_PV}.x86_64.rpm&lang=English_lpr )
"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_nofetch() {
	einfo "Please download ${A} from ${DOWNLOAD_URL}."
	einfo "Select 'I Accept' and move the file to ${DISTDIR}."
}

src_unpack() {
	rpm_unpack || die "Error unpacking ${A}."
}

src_install() {
	cp -r $WORKDIR $D
	mv $D/work/* $D
	rm -r $D/work/
}

pkg_postinst() {
	echo
	einfo "For network scanning, please follow the instructions on"
	einfo "http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/instruction_scn1b.html"
	echo
	# TODO: Do this step automatically, and also the opposite step on removal
	einfo "Now run 'setupSaneScan4 -i' to complete the installation"
}

