# pingSequence
This is a perl utility to show ping sequence numbers with histogram for round trip times.
When you are testing a network for connectivity where the networks is not very stable, and
you need to use the ping command, you want to be able to see that there are no missed pings.
Plus, you might want to get a visual idea of the round trip times.

If you just run a fast ping like "ping 8.8.8.8 -i .1", if there are missed pings, the sequence
numbers will skip a few counts -- but because the pings are fast, you will miss it if you just
watch it visually.  This script keeps track of the sequence numbers to let you know there were
missed packets.
