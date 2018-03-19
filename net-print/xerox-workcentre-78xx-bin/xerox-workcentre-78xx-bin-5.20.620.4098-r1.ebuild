EAPI="6"

inherit eutils unpacker

DESCRIPTION="Printer drivers for Xerox Workcentre 78XX"
HOMEPAGE="http://www.support.xerox.com/support/workcentre-7800-series/downloads/enus.html?associatedProduct=WorkCentre-78xx-built-in+controller&operatingSystem=linux&fileLanguage=en_GB"

SRC_URI="x86? ( Xeroxv5Pkg-Linuxi686-${PV}.deb )
	amd64? ( Xeroxv5Pkg-Linuxx86_64-${PV}.deb )"

RESTRICT="mirror strip fetch"

LICENSE="Xerox"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="net-print/cups"

S="${WORKDIR}"

pkg_nofetch() {
    einfo "Please download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
}

src_compile() {
    local ppd
    for ppd in opt/Xerox/prtsys/ppd/*.ppd; do
        grep -v XeroxQScript < ${ppd} > ${ppd}.tmp
        mv ${ppd}.tmp ${ppd}
    done
}

src_install() {
    insinto "/usr/share/cups/model"
    doins opt/Xerox/prtsys/ppd/*.ppd
}
