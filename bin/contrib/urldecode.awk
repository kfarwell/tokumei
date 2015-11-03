#!/usr/bin/awk -f
BEGIN {
	hextab ["0"] = 0; hextab ["8"] = 8;
	hextab ["1"] = 1; hextab ["9"] = 9;
	hextab ["2"] = 2; hextab ["A"] = hextab ["a"] = 10
	hextab ["3"] = 3; hextab ["B"] = hextab ["b"] = 11;
	hextab ["4"] = 4; hextab ["C"] = hextab ["c"] = 12;
	hextab ["5"] = 5; hextab ["D"] = hextab ["d"] = 13;
	hextab ["6"] = 6; hextab ["E"] = hextab ["e"] = 14;
	hextab ["7"] = 7; hextab ["F"] = hextab ["f"] = 15;
}
{
	decoded = ""
	i   = 1
	len = length ($0)
	while ( i <= len ) {
		c = substr ($0, i, 1)
		if ( c == "%" ) {
			if ( i+2 <= len ) {
				c1 = substr ($0, i+1, 1)
				c2 = substr ($0, i+2, 1)
				if ( hextab [c1] == "" || hextab [c2] == "" ) {
					print "WARNING: invalid hex encoding: %" c1 c2 | "cat >&2"
				} else {
					code = 0 + hextab [c1] * 16 + hextab [c2] + 0
					c = sprintf ("%c", code)
					i = i + 2
				}
			} else {
				print "WARNING: invalid % encoding: " substr ($0, i, len - i)
			}
		} else if ( c == "+" ) {
			c = " "
		}
		decoded = decoded c
		++i
	}
	print decoded
}
