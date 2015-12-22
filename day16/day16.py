sue_mapping = dict()
ticker_output = {'children': 3, 'cats': 7, 'samoyeds': 2, 'pomeranians': 3, 'aktias': 0, 'vizslas': 0, 'goldfish': 5, 'trees': 3, 'cars': 2, 'perfumes': 1}
def parse(sue):
	num = int(sue.split(' ')[1].strip(':'))
	vals = {}
	attrs = sue.split(': ')
	attrs = attrs [1:]
	for i in range(len(attrs)):
		if i == 0:
			key = attrs[0]
			value = int(attrs[1].split(',')[0].strip('\n'))
		elif i == len(attrs) - 1:
			break
		else:
			key = attrs[i].split(', ')[1]
			value = int(attrs[i+1].split(',')[0].strip('\n'))
		vals[key] = value
	sue_mapping[num] = vals	

def find_sue():
	for s in sue_mapping:
		attrs = sue_mapping.get(s)
		match = set(ticker_output.keys()).intersection(set(attrs.keys()))
		possible_match = True
		for a in match:
			if a == 'cats' or a == 'trees':
				if attrs.get(a) <= ticker_output.get(a):
					possible_match = False
					break
				continue
			if a == 'pomeranians' or a == 'goldfish':
				if attrs.get(a) >= ticker_output.get(a):
					possible_match = False
					break
				continue
			if ticker_output.get(a) == attrs.get(a):
				continue
			possible_match = False
			break
		if possible_match:
			print s, attrs

with open('input.txt') as f:
	f = f.readlines()
	for s in f:
		parse(s)
find_sue()
