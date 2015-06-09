# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Thrift aims to make reliable, performant communication and data serialization across languages as efficient and seamless as possible."
HOMEPAGE="http://thrift.apache.org"
SRC_URI="http://www.apache.org/dist/${PN}/${PV}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"

IUSE="cxx glib zlib qt4"

DEPEND="
	cxx? (
		dev-libs/libevent
		sys-libs/zlib
		)
	glib? (	dev-libs/glib )
	>=sys-devel/gcc-4.2
	>=dev-libs/boost-1.53.0[static-libs]
	sys-devel/make
	>=sys-devel/bison-2.5
	virtual/pkgconfig
	sys-devel/flex
	virtual/yacc
"

RDEPEND="${DEPEND}"

src_prepare() {
	chmod a+x ${S}/configure
	chmod a+x ${S}/lib/erl/rebar
	mkdir -p ${S}/lib/erl/test
}

src_configure() {
	econf \
		--without-go \
		--without-lua \
		--without-d \
		--without-nodejs \
		--without-java \
		--without-python \
		--without-perl \
		--without-ruby \
		--without-erlang \
		--without-csharp \
		--without-haskell \
		--without-php \
		$(use_with glib c_glib) \
		$(use_with cxx cpp) \
		$(use_with cxx libevent) \
		$(use cxx && use_with zlib) \
		$(use_with qt4) \
		--program-suffix=-${SLOT}
}

src_compile() {
	emake || die "Error: emake failed!"
}
