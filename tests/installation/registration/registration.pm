# SUSE's openQA tests
#
# Copyright © 2021 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Register the system with scc in the installer with registration code.
#
# Maintainer: QA SLE YaST team <qa-sle-yast@suse.de>

use base 'y2_installbase';
use strict;
use warnings;
use testapi "get_var";
use Test::Assert ':all';

sub run {
    my $reg_code = get_var('SCC_REGCODE');
    my $expected_popup = 'The registration server offers update repositories.\n\nWould you like to enable these repositories during installation\nin order to receive the latest updates?';
    my $update_repos_popup = $testapi::distri->get_registration()->get_update_repository_popup();
    $testapi::distri->get_registration()->register_product_with_regcode($reg_code);
    $testapi::distri->get_navigation()->proceed_next_screen();
    die 'Update repositories popup was not shown' unless $update_repos_popup->is_shown();
    assert_matches(qr/$expected_popup/, $update_repos_popup->text(),
        "Unexpected text in popup");
    $update_repos_popup->press_yes();
}

1;
