#!/usr/bin/awk -f
function pr(str) {
	if(lastc !~ "[{(]")
		gsub(/'/, "''", str)
	printf "%s", str
}
function trans(c) {
	printf "%s", end

	lastc = c
	end = "\n"
	if(c == "%")
		end = ""
	else if(c == "(")
		printf "echo -n "
	else if(c ~ "[})]") {
		end = "'\n"
		printf "echo -n '"
	}
}

BEGIN {
	lastc = "{"
	trans("}")
}
END {
	print end
}

/^%/ && $0 !~ /^%[{()}%]/ && lastc !~ /[({]/ {
	trans("%")
	print substr($0, 2)
	next
}
{
	if(lastc == "%")
		trans("}")
	n = split($0, a, "%")
	pr(a[1])
	for(i=2; i<=n; i++) {
		c = substr(a[i], 1, 1)
		rest = substr(a[i], 2)

		if((lastc !~ "[({]" && c ~ "[({]") ||
		   (lastc == "{" && c == "}") ||
		   (lastc == "(" && c == ")"))
			trans(c)
		else if(c == "%")
			pr("%")
		else
			pr("%" c)
		pr(rest)
	}
	pr("\n")
}
