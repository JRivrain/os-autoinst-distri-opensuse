# SUSE's openQA tests
#
# Copyright © 2021 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved. This file is offered as-is,
# without any warranty.

# Summary: The class introduces business actions for Registration dialog
# when the system is already registered.
#
# Maintainer: QE YaST <qa-sle-yast@suse.de>

package Installation::Registration::RegistrationController;
use strict;
use warnings;
use Installation::Registration::RegistrationPage;
use YuiRestClient;

sub new {
    my ($class, $args) = @_;
    my $self = bless {}, $class;
    return $self->init($args);
}

sub init {
    my ($self, $args) = @_;
    $self->{RegistrationPage}    = Installation::Registration::RegistrationPage->new({app => YuiRestClient::get_app()});
    $self->{UseUpdateReposPopup} = Installation::Warnings::ConfirmationWarning->new({app => YuiRestClient::get_app()});
    return $self;
}

sub get_registration_page {
    my ($self) = @_;
    die "Registration page is not displayed" unless $self->{RegistrationPage}->is_shown();
    return $self->{RegistrationPage};
}

sub get_update_repository_popup {
    my ($self) = @_;
    return $self->{UseUpdateReposPopup};
}

sub register_product_with_regcode {
    my ($self, $reg_code) = @_;
    $self->get_registration_page->enter_reg_code($reg_code);
}

1;
