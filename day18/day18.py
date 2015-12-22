light_state = dict()
corners = [(0,0), (0,99), (99,0), (99,99)]

def init(state):
	state = state.replace('\n', '')
	for (i,s) in enumerate(state):
		light_state[(i//100, i % 100)] = s
		if (i//100, i % 100) in corners:
			light_state[(i//100, i % 100)] = '#'

def update():
	new_state = dict()
	for pos in light_state:
		surrounding_on = get_surrounding_state(pos)
		if pos in corners:
			new_state[pos] = '#'
			continue
		if light_state[pos] == '#' and surrounding_on in [2,3]:
			new_state[pos] = '#'
			continue
		if light_state[pos] == '.' and surrounding_on == 3:
			new_state[pos] = '#'
			continue
		new_state[pos] = '.'
	return new_state

def get_surrounding_state(pos):
	on = 0
	x, y = pos
	for i in range(x-1, x+2):
		if i < 0 or i > 99:
			continue
		for j in range(y-1, y+2):
			if j < 0 or j > 99:
				continue
			if (i,j) == pos:
				continue
			s = light_state[(i,j)]
			if s == '#':
				on += 1
	return on


with open('input.txt') as f:
	f = f.read()
	init(f)

for i in range(100):
	light_state = update()

on = 0
for k in light_state:
	if light_state[k] == '#':
		on += 1
print on