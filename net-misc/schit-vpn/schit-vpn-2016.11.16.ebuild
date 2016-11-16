EAPI=5
inherit eutils

DESCRIPTION="Schibsted IT VPN"
HOMEPAGE="http://gate.schibsted.no"

KEYWORDS="~amd64 ~x86"
SLOT="1"

RESTRICT="fetch"

SRC_URI="https://artifacts.schibsted.io/artifactory/generic-local/finntech/${PN}/${P}.tar.gz"

S=$WORKDIR

RDEPEND="dev-python/pexpect
    dev-python/elementtidy"
DEPEND="${RDEPEND}"

QA_PREBUILT="*nc*"

pkg_nofetch() {
    einfo "Please download '${P}.tar.gz' from"
    einfo "https://artifacts.schibsted.io/artifactory/generic-local/finntech/${PN}"
    einfo "and place it in ${DISTDIR}"
}

src_install() {
    local exes="libncui.so ncdiag ncsvc ncui schit"
    insinto /opt/
    doins -r $S/nc
    for exe in ${exes}; do
        fperms a+x /opt/nc/${exe}
    done
    fperms a+s /opt/nc/ncsvc
    dosym /opt/nc/schit /usr/bin/schit
}
