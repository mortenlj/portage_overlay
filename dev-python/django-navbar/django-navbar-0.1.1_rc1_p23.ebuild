# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django/django-0.95.ebuild,v 1.2 2006/08/13 15:40:12 lucass Exp $

inherit subversion distutils versionator

DESCRIPTION="Dynamic site navigation trees for django sites"
HOMEPAGE="http://code.google.com/p/django-navbar/"

# Get just the patch number (aka revision)
PATCH=$(get_version_component_range $(get_version_component_count))
REVISION=${PATCH/p}

ESVN_REPO_URI="http://django-navbar.googlecode.com/svn/trunk@${REVISION}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.5"
DOCS="docs/* AUTHORS INSTALL LICENSE README"

src_unpack() {
        subversion_src_unpack
}

src_install()
{
        distutils_src_install
}

