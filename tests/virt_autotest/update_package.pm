# SUSE's openQA tests
#
# Copyright © 2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
#
package update_package;
# Summary: update_package: Update all packages and use real repo as guest installation source before test.
# Maintainer: John <xgwang@suse.com>

use strict;
use warnings;
use testapi;
use base "virt_autotest_base";
use virt_utils;
use ipmi_backend_utils;
use Utils::Backends 'is_remote_backend';
use Utils::Architectures;
use version_utils 'is_sle';

sub update_package {
    my $self           = shift;
    my $test_type      = get_var('TEST_TYPE', 'Milestone');
    my $update_pkg_cmd = "source /usr/share/qa/virtautolib/lib/virtlib;update_virt_rpms";
    my $ret;
    if ($test_type eq 'Milestone') {
        $update_pkg_cmd = $update_pkg_cmd . " off on off";
    }
    else {
        $update_pkg_cmd = $update_pkg_cmd . " off off on";
    }

    $update_pkg_cmd = $update_pkg_cmd . " 2>&1 | tee /tmp/update_virt_rpms.log ";
    if (check_var('ARCH', 's390x')) {
        lpar_cmd("$update_pkg_cmd");
        upload_asset "/tmp/update_virt_rpms.log", 1, 1;
    }
    else {
        $ret = $self->execute_script_run($update_pkg_cmd, 7200);
        upload_logs("/tmp/update_virt_rpms.log");
        save_screenshot;
        if ($ret !~ /Need to reboot system to make the rpms work/m) {
            die " Update virt rpms fail, going to terminate following test!";
        }
    }

}

sub run {
    my $self = shift;
    $self->update_package() unless (is_sle('=15-SP2') && (check_var("HOST_HYPERVISOR", "xen") || check_var("SYSTEM_ROLE", "xen")));
    if (!check_var('ARCH', 's390x')) {
        set_serial_console_on_vh('', '', 'xen') if (get_var("XEN")                      || check_var("HOST_HYPERVISOR", "xen"));
        set_serial_console_on_vh('', '', 'kvm') if (check_var("HOST_HYPERVISOR", "kvm") || check_var("SYSTEM_ROLE",     "kvm"));
    }
    update_guest_configurations_with_daily_build();
    if (is_remote_backend && check_var('ARCH', 'aarch64') && !check_var('LINUX_CONSOLE_OVERRIDE', 'ttyAMA0') && (get_var('VIRT_PRJ2_HOST_UPGRADE') || get_var('VIRT_PRJ4_GUEST_UPGRADE'))) {
        my $ipmi_console = get_var('LINUX_CONSOLE_OVERRIDE', 'ttyAMA0');
        assert_script_run("sed -irn \"s/console=ttyAMA0/console=$ipmi_console/g\" /usr/share/qa/virtautolib/lib/vh-update-lib.sh");
    }

    # turn on debug for libvirtd & enable journal with previous reboot
    enable_debug_logging if is_x86_64;

}

sub test_flags {
    return {fatal => 1};
}

1;
