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

IUSE="java cxx python perl ruby php erlang csharp objc smalltalk ocaml haskell javascript glib go zlib d qt4"

DEPEND="
	java? (
		>=virtual/jdk-1.7.0
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
	go? ( >=dev-lang/go-1.4 )
	javascript? ( >=net-libs/nodejs-0.12 )
	haskell? (
		dev-haskell/hashable
		dev-haskell/unordered-containers
		dev-haskell/vector
		dev-haskell/scientific
		dev-haskell/split
		dev-haskell/tf-random
		dev-haskell/quickcheck
		dev-haskell/attoparsec
		)
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
#    for uflag in ruby cxx haskell go; do
#        if use ${uflag} ; then
#            ewarn "Building ${uflag} library fails, ignoring use flag"
#        fi
#    done
    for uflag in python glib ; do
        if use ${uflag} ; then
            ewarn "${uflag} library does not respect slotting!"
        fi
    done

	econf \
		$(use_with go) \
		--without-lua \
		$(use_with d) \
		$(use_with javascript nodejs) \
		$(use_with java) \
		$(use_with python) \
		$(use_with perl) \
		$(use_with ruby) \
		$(use_with erlang) \
		$(use_with csharp) \
		$(use_with haskell) \
		$(use_with php) $(use_with php php_extension) \
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
