
NR<15 {
	print $0
}
NR==15 {
	print "filename = \'"fn"\';"
}
NR==16 {
	print "frame = "fm";"
}
NR==17 {
	print "max_deriv = "md";"
}
NR>17 {
	print $0
}
