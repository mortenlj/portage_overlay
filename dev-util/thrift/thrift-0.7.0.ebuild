# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Thrift aims to make reliable, performant communication and data serialization across languages as efficient and seamless as possible."
HOMEPAGE="http://thrift.apache.org"
SRC_URI="http://www.apache.org/dist/${PN}/${PV}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"

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
	python? ( >=dev-lang/python-2.4 )
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
	>=sys-devel/gcc-3.3.5
	>=dev-libs/boost-1.34.0
	sys-devel/make
	dev-util/pkgconfig
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
		$(use_with java) \
		$(use_with python) \
		$(use_with perl) \
		$(use_with ruby) \
		$(use_with erlang) \
		$(use_with csharp) \
		$(use_with haskell) \
		$(use_with php) $(use_with php php_extension) \
		$(use_with cxx cpp) $(use_with cxx libevent) $(use_with cxx zlib)
}

src_compile() {
	emake -j1 || die "Error: emake failed!"
}
