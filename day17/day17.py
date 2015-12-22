import itertools

containers = [33, 14, 18, 20, 45, 35, 16, 35, 1, 13, 18, 13, 50, 44, 48, 6, 24, 41, 30, 42]
matches = []

for i in range(2, len(containers) + 1):
	combs = itertools.combinations(containers, i)
	combs = list(combs)
	for c in combs:
		if sum(c) == 150:
			matches.append(c)
	# Part 2
	if len(matches) > 0:
		print i
		break

print len(matches)