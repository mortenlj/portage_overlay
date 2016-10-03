
EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit versionator distutils-r1 eutils

MY_PV=$(replace_version_separator 2 '-')
MY_P="${PN}-${MY_PV}"

S="${WORKDIR}/${MY_P}"

DESCRIPTION="A tidylib interface for ElementTree"
HOMEPAGE="http://effbot.org/zone/element-tidylib.htm"
SRC_URI="http://effbot.org/media/downloads/elementtidy-${MY_PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/htmltidy
    dev-python/elementtree"
RDEPEND="${DEPEND}"
