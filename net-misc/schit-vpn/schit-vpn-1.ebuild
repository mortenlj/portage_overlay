EAPI=5
inherit eutils

DESCRIPTION="Schibsted IT VPN"
HOMEPAGE="http://gate.schibsted.no"

KEYWORDS="~amd64 ~x86"
SLOT="1"

SRC_URI="https://confluence.finn.no/download/attachments/30442257/ubuntu-nc.gz?version=${PV}"

S=$WORKDIR

RDEPEND="dev-python/pexpect
    dev-python/elementtidy"
DEPEND="${RDEPEND}"

QA_PREBUILT="*nc*"

src_unpack() {
    local source=${DISTDIR}/${A}
    local target=${DISTDIR}/ubuntu-nc-${PV}.tar.gz
    if [[ ${source} -nt ${target} ]] ; then
        einfo "Copying ${source} to ${target}"
        cp ${source} ${target}
    fi
    unpack ubuntu-nc-${PV}.tar.gz
}

src_install() {
    local exes="ncdiag ncsvc ncui schit"
    insinto /opt/
    doins -r $S/nc
    for exe in ${exes}; do
        fperms ugo+x /opt/nc/${exe}
    done
    dosym /opt/nc/schit /usr/bin/schit
}
