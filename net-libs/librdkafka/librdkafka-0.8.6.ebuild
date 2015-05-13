
EAPI=5

DESCRIPTION="The Apache Kafka C/C++ library"
HOMEPAGE="https://github.com/edenhill/${PN}"
SRC_URI="https://github.com/edenhill/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

