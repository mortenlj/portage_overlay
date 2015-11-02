EAPI=5
inherit eutils

DESCRIPTION="Schibsted IT VPN"
HOMEPAGE="http://gate.schibsted.no"

KEYWORDS="~amd64 ~x86"
SLOT="1"

RESTRICT="fetch"

SRC_URI="https://confluence.finn.no/download/attachments/DUMMY/ubuntu-nc-updated.tar.gz -> ${P}.tar.gz"

S=$WORKDIR

RDEPEND="dev-python/pexpect
    dev-python/elementtidy"
DEPEND="${RDEPEND}"

QA_PREBUILT="*nc*"

pkg_nofetch() {
    einfo "Please download the latest version of the ubuntu package from"
    einfo "https://confluence.finn.no/display/TEKK/Linux+VPN"
    einfo "and place it in ${DISTDIR} named '${P}.tar.gz'"
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
