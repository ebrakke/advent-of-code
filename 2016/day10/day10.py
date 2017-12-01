start = '3113322113'

def play_game(inpt, n):
	if n == 0:
		return inpt
	parsed = []
	count = 1
	prev = ''
	for (i,s) in enumerate(inpt):
		if i == 0:
			num = s
			prev = s
			continue
		if s == prev:
			count += 1
			continue
		parsed.append([count, prev])
		count = 1
		prev = s
	parsed.append([count, prev])
	new_inpt = ''.join([str(x[0]) + x[1] for x in parsed])
	return play_game(new_inpt, n-1)

output = play_game(start, 50)
print len(output)
with open('output.txt', 'w') as f:
	f.write(output)
	f.close()