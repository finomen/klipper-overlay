# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for klipper service"

ACCT_USER_HOME=/opt/klipper
ACCT_USER_GROUPS=( "klipper" "dialout" )
ACCT_USER_ID="741"

acct-user_add_deps
