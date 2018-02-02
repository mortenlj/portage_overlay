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
    doins -r .

    local exe
    for exe in \
        usr/bin/xerox* \
        usr/lib/cups/filter/Xerox* \
        opt/Xerox/prtsys/v5lib/lib*.so \
        opt/Xerox/prtsys/PatchAppArmorPolicy \
        opt/Xerox/prtsys/x* ; do

        fperms +x "/${exe}"

		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${exe} && $(od -t x1 -N 4 "${exe}") == *"7f 45 4c 46"* ]] || continue
		patchelf --set-rpath /opt/Xerox/prtsys/v5lib "${D}${exe}" || \
			die "patchelf failed on ${exe}"
    done

    pushd "${D}opt/Xerox/prtsys" || die
    echo " CUPS" > "${D}opt/Xerox/prtsys/.xp_cfg"
    env | grep DISPLAY > "${D}opt/Xerox/prtsys/.xp_disp"
    popd || die

    dodir /etc/xdg/autostart
    insinto /etc/xdg/autostart

    echo "# Grant lp print-time xhost permissions" > PrtDrv-xhost-permissions.desktop
    echo "[Desktop Entry]" >> PrtDrv-xhost-permissions.desktop
    echo "Name=Print-Time Dialog Permissions" >> PrtDrv-xhost-permissions.desktop
    echo "Type=Application" >> PrtDrv-xhost-permissions.desktop
    echo "Exec=xhost +si:localuser:lp" >> PrtDrv-xhost-permissions.desktop

    doins PrtDrv-xhost-permissions.desktop
}
