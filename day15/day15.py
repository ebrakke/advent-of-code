ingredients = dict()
max_combination = [0, []]
def parse(ingredient):
	i = ingredient.split(' ')
	name = i[0].strip(':')
	capacity, dura, flav, tex, cal = map(lambda x: int(x.strip(',\n')), [i[2], i[4], i[6], i[8], i[10]])
	ingredients[name] = {'capacity': capacity, 'durability': dura, 'flavor': flav, 'texture': tex, 'calories': cal}

# Taken from stack overflow 
# http://stackoverflow.com/questions/7748442/generate-all-possible-lists-of-length-n-that-sum-to-s-in-python
def combinations(n, s):
	if n == 1:
		yield (s,)
	else:
		for i in xrange(s + 1):
			for j in combinations(n-1, s-i):
				yield (i,) + j

def find_max():
	global max_combination
	combs = combinations(len(ingredients), 100)
	while True:
		try:
			c = next(combs)
			score = get_score(c)
			if max_combination[0] < score:
				print score, c
				max_combination = [score, c]
		except StopIteration:
			break 

def get_score(combination):
	capacity, durability, flavor, texture, calories = 0,0,0,0,0
	for (amt, key) in zip(combination, ingredients.keys()):
		ingr = ingredients.get(key)
		capacity += ingr['capacity'] * amt
		durability += ingr['durability'] * amt
		flavor += ingr['flavor'] * amt
		texture += ingr['texture'] * amt
		calories += ingr['calories'] * amt
	if len([x for x in [flavor, capacity, durability, texture] if x < 0]) > 0:
		return 0
	total = capacity * durability * flavor * texture
	return total if calories == 500 else 0

with open('input.txt') as f:
	f = f.readlines()
	for i in f:
		parse(i)
	find_max()