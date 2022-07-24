# Copyright 1970 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Klipper is a 3d-Printer firmware"
HOMEPAGE="https://www.klipper3d.org/"

LICENSE="GPL-3"
SLOT="0"

PYTHON_COMPAT=( python3_{6..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DEPEND="
	dev-python/cffi
	dev-python/pyserial
	dev-python/greenlet
	dev-python/jinja
	dev-python/markupsafe
	acct-user/klipper
"
# dev-python/python-can
RDEPEND="${DEPEND}"
BDEPEND=""


if [[ ${PV} == *9999 ]]; then
    inherit git-r3
	EGIT_REPO_URI="https://github.com/Klipper3d/klipper.git"
	EGIT_BRANCH="master"
	RESTRICT="getbinpkg"
	KEYWORDS="~arm64 ~arm"
else
	KEYWORDS="arm64 arm"
	SRC_URI="https://github.com/Klipper3d/klipper/archive/refs/tags/v${PV}.tar.gz"
fi

PATCHES="
	${FILESDIR}/01-python3.patch
"

src_compile() {
	python3 klippy/chelper/__init__.py
	chmod +x klippy/klippy.py
	cp ${FILESDIR}/rpi_config .config
	make olddefconfig
	make flash
}

src_install() {
	addwrite /opt/klipper
	insinto /opt/klipper
	doins -r config
	doins -r docs
	doins -r klippy
	exeinto /opt/klipper/klippy
	doexe klippy/klippy.py
	exeinto /opt/klipper/klippy/chelper
	doexe klippy/chelper/c_helper.so
	doins -r lib
	doins -r scripts
	doins -r src
	doins -r test
	doins Makefile
	doins README.md
	newinitd ${FILESDIR}/klipper klipper
}
