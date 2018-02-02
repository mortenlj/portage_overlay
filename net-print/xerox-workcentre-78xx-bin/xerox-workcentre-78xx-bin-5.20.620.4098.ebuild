EAPI="6"

inherit eutils unpacker

DESCRIPTION="Printer drivers for Xerox Workcentre 78XX"
HOMEPAGE="http://www.support.xerox.com/support/workcentre-7800-series/downloads/enus.html?associatedProduct=WorkCentre-78xx-built-in+controller&operatingSystem=linux&fileLanguage=en_GB"

SRC_URI="x86? ( Xeroxv5Pkg-Linuxi686-${PV}.deb )
	amd64? ( Xeroxv5Pkg-Linuxx86_64-${PV}.deb )"

RESTRICT="mirror strip fetch"

LICENSE="Xerox"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="net-print/cups"

S="${WORKDIR}"

pkg_nofetch() {
    einfo "Please download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
}

src_install() {
    local exe
    for exe in \
        ${S}/usr/bin/xerox* \
        ${S}/usr/libexec/cups/filter/Xerox* \
        ${S}/opt/Xerox/prtsys/v5lib/lib* \
        ${S}/opt/Xerox/prtsys/PatchAppArmorPolicy \
        ${S}/opt/Xerox/prtsys/x* ; do

		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${exe} && $(od -t x1 -N 4 "${exe}") == *"7f 45 4c 46"* ]] || continue
		patchelf --set-rpath /opt/Xerox/prtsys/v5lib "${exe}" || \
			die "patchelf failed on ${exe}"
    done

    doins -r opt

    exeinto /usr/bin
    doexe usr/bin/xerox*
    exeinto /opt/Xerox/prtsys/
    doexe opt/Xerox/prtsys/x*

    exeinto /usr/libexec/cups/filter/
    doexe usr/lib/cups/filter/Xerox*

    exeinto /opt/Xerox/prtsys/v5lib/
    doexe opt/Xerox/prtsys/v5lib/lib*

    local ppd
    for ppd in opt/Xerox/prtsys/ppd/*.ppd; do
    	dosym "../../../../${ppd}" "/usr/share/cups/model/$(basename ${ppd})"
    done

    echo " CUPS" > "${D}opt/Xerox/prtsys/.xp_cfg"

    dodir /etc/xdg/autostart
    insinto /etc/xdg/autostart

    echo "# Grant lp print-time xhost permissions" > PrtDrv-xhost-permissions.desktop
    echo "[Desktop Entry]" >> PrtDrv-xhost-permissions.desktop
    echo "Name=Print-Time Dialog Permissions" >> PrtDrv-xhost-permissions.desktop
    echo "Type=Application" >> PrtDrv-xhost-permissions.desktop
    echo "Exec=xhost +si:localuser:lp" >> PrtDrv-xhost-permissions.desktop

    doins PrtDrv-xhost-permissions.desktop
}
