# pingSequence
This is a perl utility to show ping sequence numbers with histogram for round trip times.
When you are testing a network for connectivity where the networks is not very stable, and
you need to use the ping command, you want to be able to see that there are no missed pings.
Plus, you might want to get a visual idea of the round trip times.

If you just run a fast ping like "ping 8.8.8.8 -i .1", if there are missed pings, the sequence
numbers will skip a few counts -- but because the pings are fast, you will miss it if you just
watch it visually.  This script keeps track of the sequence numbers to let you know there were
missed packets.

Here's an example:

```
$ ping -i .2 8.8.8.8 | perl pingSequence.pl  0 0
nothing, PING 8.8.8.8 (8.8.8.8): 56 data bytes

Missed packets = 0
**************************************************************************************************** 34.953/34.953
*********************************************************************** 24.986/34.953
****************************************************************** 23.248/34.953
****************************************************************** 23.165/34.953
*********************************************************** 20.644/34.953
************************************************************************** 25.979/34.953
*********************************************************** 20.962/34.953
*********************************************************** 20.851/34.953
```

Note the histogram indicates a blip at first them smooths out. 
more stuff
even more stuff
