# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils 

DESCRIPTION="Enhancements to virtualenv"
HOMEPAGE="http://pypi.python.org/pypi/virtualenvwrapper"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/virtualenv"
DEPEND="${RDEPEND}"

src_install() {
    distutils_src_install
    
    insinto /etc/profile.d
    newins "${FILESDIR}/profile-${PV}.sh" virtualenvwrapper.sh
}
