# SUSE's openQA tests
#
# Copyright © 2019 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved. This file is offered as-is,
# without any warranty.

# Summary: modify and resize existing partitions on a pre-formatted disk.
# Maintainer: Jonathan Rivrain <jrivrain@suse.com>

use strict;
use warnings;
use parent 'y2_installbase';
use testapi;
use version_utils ':VERSION';
use scheduler 'get_test_suite_data';

sub run {
    my $test_data   = get_test_suite_data();
    my $partitioner = $testapi::distri->get_expert_partitioner();
    $partitioner->run_expert_partitioner();
    my $disk       = $test_data->{disks}[0]->{name};
    my @partitions = @{$test_data->{disks}[0]->{partitions}};
    my $root_part  = $partitions[0];

    record_info("Resize root");
    $partitioner->resize_partition({disk => $disk, partition => $root_part});
    for my $part (@partitions) {
        record_info("Edit $part->{name}", "$part");
        $partitioner->edit_partition_on_gpt_disk({disk => $disk, partition => $part});
    }
    $partitioner->accept_changes_and_press_next();
}

1;
