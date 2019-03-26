
NR<6 {
	print $0
}
NR==6 {
	print "filename = \'"fn"\';"
}
NR==7 {
	print "pl = "pl";"
}
NR==8 {
	print "frame = "fm";"
}
NR==9 {
	print "max_deriv = "md";"
}
NR>9 {
	print $0
}
