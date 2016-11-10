
EAPI=6

DESCRIPTION="A file change monitor that receives notifications when the contents of the specified files or directories are modified."
HOMEPAGE="http://emcrisostomo.github.io/fswatch/"
SRC_URI="https://github.com/emcrisostomo/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""
