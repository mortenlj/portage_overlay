# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django/django-0.95.ebuild,v 1.2 2006/08/13 15:40:12 lucass Exp $

inherit subversion distutils eutils bash-completion

MY_P="${PN/d/D}-${PV}"
DESCRIPTION="high-level python web framework"
HOMEPAGE="http://www.djangoproject.com/"
REVISION=8961

ESVN_REPO_URI="http://code.djangoproject.com/svn/django/trunk@${REVISION}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="sqlite postgres mysql examples test"

DEPEND=">=dev-python/setuptools-0.6_rc1
	test? ( || (
		( >=dev-python/pysqlite-2.0.3 <dev-lang/python-2.5 )
		>=dev-lang/python-2.5 ) )"

RDEPEND="${DEPEND}
		sqlite? ( || (
			( >=dev-python/pysqlite-2.0.3 <dev-lang/python-2.5 )
			>=dev-lang/python-2.5 ) )
		postgres? ( <dev-python/psycopg-1.99 )
		mysql? ( dev-python/mysql-python )
		dev-python/imaging
		!dev-python/django"

S="${WORKDIR}/${MY_P}"
DOCS="docs/* AUTHORS INSTALL LICENSE"

src_unpack() {
	subversion_src_unpack ${A}; cd "${S}"
	sed -i '/ez_setup/d' setup.py || die "sed failed"
}

src_install()
{
	distutils_python_version

	site_pkgs="/usr/$(get_libdir)/python${PYVER}/site-packages/"
	export PYTHONPATH="${PYTHONPATH}:${D}/${site_pkgs}"
	dodir ${site_pkgs}

	find ${S} -name '.svn' | xargs rm -r

	distutils_src_install

	dobashcompletion extras/django_bash_completion

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

src_test() {
	cat >> tests/settings.py << __EOF__
DATABASE_ENGINE='sqlite3'
ROOT_URLCONF='tests/urls.py'
SITE_ID=1
__EOF__
	PYTHONPATH="." ${python} tests/runtests.py --settings=settings -v1 || die "tests failed"
}
