# SUSE's openQA tests
#
# Copyright SUSE LLC
# SPDX-License-Identifier: FSFAP

# Package: MozillaFirefox
# Summary: Firefox Printing - Alignment Test
# - Copy /data/x11/firefox/alignmenttest to /home/bernhard/ffprint/
# - Launch firefox
# - Open "/home/bernhard/ffprint/alignmenttest" and check result
# - Send key Ctrl-P to print the page
# - Click ">" button to view the next pages
# - Click the Save button
# - Specify the path and name of the output file
# - Exit firefox
# - Verify the output file
# - Remove the output file
# Maintainer: Grace Wang<grace.wang@suse.com>

use strict;
use warnings;
use base "x11test";
use testapi;

sub run {
    my $self = shift;
    my $file = "alignmenttest";

    # Copy the destination file to home directory
    # Open the destination file
    # Use Ctrl-P to print the file
    $self->firefox_print2file_overview($file);
    assert_and_click("firefox-print-$file-overview-NextPage");
    assert_screen("firefox-print-$file-2ndPage");

    # Print to PDF
    $self->firefox_print($file);

    # Verify output file
    $self->verify_firefox_print_output($file);

    # Clean up output file
    $self->cleanup_firefox_print;
}
1;
