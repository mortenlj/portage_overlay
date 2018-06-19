# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A bash-tool to store your private data inside a git repository"
HOMEPAGE="http://git-secret.io/"
SRC_URI="https://github.com/sobolevn/git-secret/archive/v${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="x86 amd64"

RDEPEND=">=dev-vcs/git-2.7.0
         >=app-crypt/gnupg-1.4.20
"

src_compile() {
	emake build
}

src_install() {
    # We are going to side-step the install-script that is included,
    # because it makes assumptions about where man-pages go that doesn't
    # suit us, and there is no easy way to fix it. There are only a
    # couple files to install, so we'll do it directly.
	prefix="${D}/usr"
	bindir="${prefix}/bin/"
	mandir="${D}/usr/share/man"

    install -d "${bindir}"
    install "${S}/git-secret" "${bindir}"

    for num in 1 7; do
        source="${S}/man/man${num}"
        dest="${mandir}/man${num}"
        install -d "${dest}"
        install $(find "${source}" -name "*.${num}" -print0 | xargs -0) "${dest}"
    done
}
