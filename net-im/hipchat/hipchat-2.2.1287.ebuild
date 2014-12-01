EAPI=5
inherit eutils

DESCRIPTION="Atlassian HipChat native client"
HOMEPAGE="http://hipchat.com"

KEYWORDS="~amd64 ~x86"
SLOT="1"

SRC_URI="
    x86?   ( http://downloads.hipchat.com/linux/arch/i686/hipchat-${PV}-i686.pkg.tar.xz )
    amd64? ( http://downloads.hipchat.com/linux/arch/x86_64/hipchat-${PV}-x86_64.pkg.tar.xz )"

S=$WORKDIR

RDEPEND="app-text/aspell"
DEPEND="${RDEPEND}"

src_install() {
    insinto /opt/
    doins -r $S/opt/HipChat
    insinto /usr/
    doins -r $S/usr/share
    fperms ugo+x /opt/HipChat/bin/hipchat
    fperms ugo+x /opt/HipChat/bin/linuxbrowserlaunch
    fperms ugo+x /opt/HipChat/bin/HipChatNowPlaying.rb
    fperms ugo+x /opt/HipChat/bin/hellocpp
    fperms ugo+x /opt/HipChat/lib/hipchat.bin
    dosym /opt/HipChat/bin/hipchat /usr/bin/hipchat
}
