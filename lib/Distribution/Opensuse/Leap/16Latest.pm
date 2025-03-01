# SUSE's openQA tests
#
# Copyright 2024 SUSE LLC
# SPDX-License-Identifier: FSFAP

# Summary: The class represents current (i.e. latest) SLE 16 distribution and
# provides access to its features.
#
# Maintainer: QE YaST and Migration (QE Yam) <qe-yam at suse de>

package Distribution::Opensuse::Leap::16Latest;
use parent Distribution::Opensuse::AgamaDevel;
use strict;
use warnings FATAL => 'all';

use Yam::Agama::Pom::GrubMenuLeapPage;

sub get_grub_menu_installed_system {
    my $self = shift;
    return Yam::Agama::Pom::GrubMenuLeapPage->new({grub_menu_base => $self->get_grub_menu_base()});
}

1;
