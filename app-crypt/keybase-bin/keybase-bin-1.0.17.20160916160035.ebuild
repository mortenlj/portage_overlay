EAPI=6

inherit unpacker versionator

DESCRIPTION="The Keybase Go client, filesystem, and GUI"
HOMEPAGE="http://keybase.io"

MY_PV="$(replace_version_separator 3 '-').9aa63e0"
SRC_BASE="https://prerelease.keybase.io/linux_binaries/deb/keybase_${MY_PV}"
SRC_URI="
    amd64? ( ${SRC_BASE}_amd64.deb )
    x86?   ( ${SRC_BASE}_i386.deb )
"

SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
RESTRICT="mirror strip"
LICENSE="Keybase"
S=${WORKDIR}
RDEPEND="
    sys-fs/fuse
    gnome-base/gconf
"
QA_PREBUILT="
    work/opt/keybase/Keybase
    work/opt/keybase/libnode.so
    work/usr/bin/keybase
    work/usr/bin/kbfsfuse
"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
    # Omit the cronjobs that the Debian package includes.
    rm -rf "${S}/etc"
    eapply_user
}

src_install() {
    cp -R "${S}/" "${D}/" || die "Install failed!"
}

pkg_postinst() {
    if [[ -x /opt/keybase/post_install.sh ]] ; then
        /opt/keybase/post_install.sh
    fi
}
