use strict;
use base "y2logsstep";
use testapi;

sub run() {

	if ( get_var("ADDONURL") ){
		if ( get_var("VIDEOMODE") && check_var("VIDEOMODE", "text") ) { $cmd{xnext} = "alt-x" }
		if ( !get_var("NET") && !get_var("DUD") ) {
			wait_still_screen();
			sleep 5;                 # try
			send_key $cmd{"next"};    # use network
			wait_still_screen(20);
			send_key "alt-o", 1;        # OK DHCP network
		}
		my $repo = 0;
		$repo++ if get_var("DUD");
		foreach my $url ( split( /\+/, get_var("ADDONURL") ) ) {
			if ( $repo++ ) { send_key "alt-a", 1; }    # Add another
			send_key $cmd{"xnext"}, 1;                 # Specify URL (default)
			type_string $url;
			send_key $cmd{"next"}, 1;
			if ( get_var("ADDONURL") !~ m{/update/} ) {    # update is already trusted, so would trigger "delete"
				send_key "alt-i";
				send_key "alt-t", 1;                     # confirm import (trust) key
			}
		}
		assert_screen 'test-addon_product-1', 3;
		send_key $cmd{"next"}, 1;                        # done
	}
	
#TODO Implment test that uses ISO_1 (SDK), _2 (HA), _3 (GEO) to add addons
}

1;
# vim: set sw=4 et:
