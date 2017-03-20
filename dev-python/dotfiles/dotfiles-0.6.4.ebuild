EAPI="6"
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Easily manage your dotfiles"
HOMEPAGE="https://github.com/jbernard/dotfiles"
SRC_URI="http://pypi.python.org/packages/source/d/dotfiles/${P}.tar.gz"

LICENSE="ISC"
KEYWORDS="amd64"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/setuptools
	dev-python/click
	dev-python/py
"
RDEPEND="${DEPEND}"
