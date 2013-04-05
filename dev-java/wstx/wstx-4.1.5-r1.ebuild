# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/wstx/wstx-3.2.8.ebuild,v 1.6 2010/01/20 02:49:01 ranger Exp $

EAPI=1
JAVA_PKG_IUSE="doc source test"
WANT_ANT_TASKS="ant-nodeps"
MY_PN="woodstox-core"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Woodstox is a high-performance validating namespace-aware XML-processor"
HOMEPAGE="http://woodstox.codehaus.org/"
SRC_URI="http://woodstox.codehaus.org/${PV}/${MY_PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="4.1"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

COMMON_DEP="
	dev-java/sax:0
	java-virtuals/jaxp-virtual
	dev-java/stax:0
	dev-java/stax2-api:0
	dev-java/msv:0
	dev-java/xsdlib:0
	dev-java/relaxng-datatype:0
	dev-java/junit:0
	dev-java/osgi-core-api:0
	test? ( dev-java/ant:0 )"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

EANT_BUILD_TARGET="jars"
EANT_DOC_TARGET="javadoc"

S="${WORKDIR}/woodstox-${PV}"

JAVA_ANT_REWRITE_CLASSPATH="true"

src_unpack(){
	unpack ${A}
	rm -v "${S}"/lib/osgi/*.jar || die
	rm -v "${S}"/lib/msv/*.jar || die
	rm -v "${S}"/lib/*.jar || die

	cd "${S}"
	sed -i -e "s@<import .*repackage-msv.xml.* />@<\!-- \\0 -->@" build.xml || die "Unable to disable import of repackage-msv.xml"
	sed -i -e 's@<target name="jars" depends="jars.osgi, jar.stax2test, repackage-msv" />@<target name="jars" depends="jars.osgi" />@' build.xml || die "Unable to remove target repackage-msv"
	sed -i -e 's@<target name="jars.osgi" depends="osgi-stax2, osgi-woodstox-lgpl, osgi-woodstox-asl" />@<target name="jars.osgi" depends="osgi-woodstox-asl"/>@' build-osgi.xml || die "Unable to disable targets osgi-stax2 and osgi-woodstox-lgpl"
}

EANT_GENTOO_CLASSPATH="sax,jaxp-virtual,msv,xsdlib,relaxng-datatype,junit,stax2-api,osgi-core-api"

src_test(){
	ANT_TASKS="ant-junit ant-nodeps ant-trax" eant test || die "Tests failed"
}

src_install() {
	java-pkg_newjar build/"${MY_PN}"-asl-"${PV}".jar "${PN}".jar
	use doc && java-pkg_dojavadoc build/javadoc
	use source && java-pkg_dosrc src
}
