# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Ebuild generated by g-pypi 0.3

EAPI="4-python"

PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="1.* 2.[0-6] 3.* *-jython *-pypy-*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_PN="Kivy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A software library for rapid development of hardware-accelerated multitouch applications."
HOMEPAGE="http://kivy.org"
SRC_URI="https://pypi.python.org/packages/source/K/Kivy/${MY_P}.tar.gz"

LICENSE="LGPL"
KEYWORDS="~amd64"
SLOT="0"
IUSE="doc examples"

DEPEND="$(python_abi_depend "dev-python/pygame" "dev-python/pyenchant" "dev-python/gst-python" ">=dev-python/cython-0.15" "dev-python/setuptools" )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install
	if use doc; then
		dodoc -r doc
	fi
	if use examples; then
		insinto /usr/share/doc/"${PF}"/
		doins -r examples
	fi
}
