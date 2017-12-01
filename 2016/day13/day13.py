import itertools

happiness_map = dict()
people = dict()
arrangements = list()
costs = list()

def parse_and_map(seating):
	seating = seating.split(' ')
	person, sign, amount, neighbor = seating[0], seating[2], seating[3], seating[10].strip('\n.')
	if sign == 'gain':
		amount = int(amount)
	else:
		amount = -1 * int(amount)
	people.setdefault(person, 0)
	happiness_map[(person, neighbor)] = amount

def find_cost(a):
	cost = 0
	for (i,p) in enumerate(a):
		left = (i - 1) % len(a)
		right = (i + 1) % len(a)
		cost += happiness_map[(p, a[left])]
		cost += happiness_map[(p, a[right])]
	costs.append([a, cost])

def add_self():
	for p in people:
		happiness_map[('Me', p)] = 0
		happiness_map[(p, 'Me')] = 0
	people.setdefault('Me', 0)


with open('input.txt') as f:
	f = f.readlines()
	for s in f:
		parse_and_map(s)
	add_self()
	arrangements = list(itertools.permutations(people))
	for a in arrangements:
		find_cost(a)
	print max(costs, key=lambda x: x[1])
	