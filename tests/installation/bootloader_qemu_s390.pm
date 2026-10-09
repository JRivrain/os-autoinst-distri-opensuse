# SUSE's openQA tests
#
# Copyright 2024 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Summary: Interface with the qemu bootloader on s390x
# Maintainer: QE Core <qe-core@suse.de>

## no os-autoinst style

package bootloader_qemu_s390;

use base "installbasetest";
use strict;
use warnings;
use testapi;
use version_utils 'is_agama';

sub run {
    my ($self) = @_;

    # On s390x with qemu backend, the VNC display is inactive (black) during boot 
   # because the bootloader uses the SCLP serial console.
    # We just wait for the login prompt to prove the installed system boots.
    wait_serial('login:', 300) or die "System didn't boot to login prompt";

    select_console('root-console');
    assert_script_run('lscpu');
}

1;
