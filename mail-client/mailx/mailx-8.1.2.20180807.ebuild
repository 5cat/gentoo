# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DP="bsd-${PN}_${PV%.*}-0.${PV##*.}cvs"
DPT="${DP}.orig.tar.xz"
DPP="${DP}-1.debian.tar.xz"

DESCRIPTION="The $ mail program, which is used to send mail via shell scripts"
HOMEPAGE="https://www.debian.org/"
SRC_URI="http://http.debian.net/debian/pool/main/b/bsd-${PN}/${DPT}
	http://http.debian.net/debian/pool/main/b/bsd-${PN}/${DPP}"

S="${WORKDIR}/${DP/_/-}.orig"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND=">=net-libs/liblockfile-1.03
	dev-libs/libbsd
	virtual/mta
	mail-client/mailx-support"

RDEPEND="${DEPEND}
	!mail-client/nail
	!net-mail/mailutils"

src_prepare() {
	eapply "${WORKDIR}/debian/patches"
	eapply "${FILESDIR}/${PN}-8.1.2.20050715-offsetof.patch"
	eapply "${FILESDIR}/${PN}-8.1.2.20180807-fno-common.patch"
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" EXTRAFLAGS="${CFLAGS}"
}

src_install() {
	dobin mail

	doman mail.1

	dosym mail /usr/bin/Mail
	dosym mail /usr/bin/mailx
	dosym mail.1 /usr/share/man/man1/Mail.1

	insinto /usr/share/mailx/
	doins misc/mail.help misc/mail.tildehelp
	insinto /etc
	doins misc/mail.rc
}
