all_paths = dict()

def parse_path(path):
	path = path.split(' ')
	all_paths.setdefault(path[0], [])
	all_paths.setdefault(path[2], [])
	all_paths[path[0]].append([path[2], int(path[4].strip('\n'))])
	all_paths[path[2]].append([path[0], int(path[4].strip('\n'))])

def build_path(start, visited):
	visited = visited + [start[0]]
	possible_nxt = [x for x in all_paths.get(start[0]) if x[0] not in visited]
	paths = []
	if possible_nxt == []:
		return [[start]]
	for nxt in possible_nxt:
		children = build_path(nxt, visited)
		path = [start]
		if children == []:
			paths.append(path)
		for c in children:
			paths.append(path + c)
	return paths

def find_cost(path):
	cost = 0
	for (dest, c) in path:
		cost += c
	return cost, path

	
with open('input.txt') as f:
	f = f.readlines()
	for d in f:
		parse_path(d)
	paths = []
	for city in all_paths:
		p = build_path([city, 0], [])
		paths = paths + p
	costs = [find_cost(p) for p in paths]
	print max(costs, key=lambda x: x[0])
	

