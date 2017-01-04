#!/usr/bin/perl

# Author: Dennis Periquet
# May 3, 2015
#
# Used to show if we missed a packet in ping.  It will look at the sequence
# numbers and compare that they are in order.  It will also depict relative
# round trip times using a asterisk based histogram.
#
# This is only useful in situations where network connectivity is not so
# great especially in test networks.  Stable networks will yield quite boring
# results
#
# Usage (using default values):
#   ping 8.8.8.8 | ./pingSequence.pl 0 0
#

my $numArgs = $#ARGV + 1;
if ($numArgs != 2) {
  print "\n  Usage:\n";
  print "  ./pingSequence.pl <maxRoundTrip> <verbose>";
  print "\n\n";
  exit;
}


# Your custom max round trip time.
# Set to 0 if you want to use current max.
#
my $customRoundTrip = $ARGV[0];

# If you want to see the actual ping, set this to 1.
#
my $displayPing = $ARGV[1];

my $count = 1;
my $missedIt = 0;
my $mCount;
my $roundTrip;
my $maxRound = 0;

while (my $t = <STDIN>) {
  # Extract out the sequence number and round trip time.
  #
  if ($t =~ /icmp_[rs]eq=([0-9]*).*time=([0-9.]*)\ ms/) {
    my $roundTrip = $2;
    if ($roundTrip > $maxRound) {
      # Each time we get a larger round trip time, we will use that
      # as our new benchmark.
      #
      $maxRound = $roundTrip;
    }

    # Customize the max round trip time if the user gave a value
    # greater than 0.
    #
    if ($customRoundTrip > 0) {
      $maxRound = $customRoundTrip;
    }

    # We track the sequence number so that we can tell you if some
    # packets were missed.
    #
    my $seqNum = $1;
    if ($missedIt) {
      # If we missed a packet (known by a number out of sequence), show
      # the missed pings as single asterisk and tell how many were missed.
      #
      $mCount = $1 - $count;
      foreach my $j (0..($mCount-1) ) {
        my $k = $j + $count;
        print "* $k\n";
      }
      print "Missed packets = $mCount\n";

      # Reset the count to the last received packet sequence number.
      #
      $count = $1;
      $missedIt = 0;
    }
    if ($seqNum == $count) {
      # On a successful ping, display the full ping line.
      # For cleaner output, don't display it by commenting the line out.
      #
      $count++;
      if ($displayPing) {
        print $t;
      }

      # Also, display up to 100 asterisks showing percent relative to the
      # largest round trip time.
      #
      my $pp = int(($roundTrip / $maxRound) * 100);

      # Print up to 100 asterisks and then show real numbers at the end
      # of the line.
      #
      if ($pp > 100) {
        $pp = 100;
      }
      foreach my $j (1..$pp) {
        print "*";
      }
      print " $roundTrip/$maxRound\n";
    } else {
      $missedIt = 1;
    }
  } else {
    # For debugging only -- to show we did not match a ping line.
    #
    print "nothing, $t\n";
  }
}
