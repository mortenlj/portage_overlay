# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Thrift aims to make reliable, performant communication and data serialization across languages as efficient and seamless as possible."
HOMEPAGE="http://thrift.apache.org"
SRC_URI="http://www.apache.org/dist/${PN}/${PV}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0.9"
KEYWORDS="~x86 ~amd64"

IUSE="java cxx python perl ruby php erlang csharp objc smalltalk ocaml haskell javascript glib"

DEPEND="
	java? (
		>=virtual/jdk-1.5.0
		dev-java/ant
		dev-java/ant-ivy
		dev-java/commons-lang
		dev-java/slf4j-api
		)
	cxx? (
		dev-libs/libevent
		sys-libs/zlib
		)
	python? ( >=dev-lang/python-2.6 )
	perl? (
		>=dev-lang/perl-5.0
		dev-perl/Bit-Vector
		dev-perl/Class-Accessor
		)
	ruby? ( >=dev-lang/ruby-1.8 )
	php? ( >=dev-lang/php-5.0 )
	erlang? ( >=dev-lang/erlang-12.0.0 )
	csharp? ( >=dev-lang/mono-1.2.4 )
	glib? (	dev-libs/glib )
	>=sys-devel/gcc-4.2
	>=dev-libs/boost-1.40.0
	sys-devel/make
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
    if use ruby ; then
        ewarn "Building ruby library fails, ignoring use flag"
    fi
    if use cxx ; then
        ewarn "Building C++ library fails, ignoring use flag"
    fi
    if use python ; then
        ewarn "Python library does not respect slotting, ignoring use flag"
    fi

	econf \
		--without-go \
		$(use_with java) \
		--without-python \
		$(use_with perl) \
		--without-ruby \
		$(use_with erlang) \
		$(use_with csharp) \
		$(use_with haskell) \
		$(use_with php) $(use_with php php_extension) \
		--without-cpp --without-libevent --without-zlib \
		--program-suffix=-${PV}
}

src_compile() {
	emake || die "Error: emake failed!"
}
