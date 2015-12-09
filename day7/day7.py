env = dict()
parsed_instructions = list()

def parse_instruction(instr):
	instr = instr.split(' ')
	if instr[0] == 'NOT':
		left = parse_var_or_number(instr[1])
		assignee = parse_var_or_number(instr[3])
		return {'ASSIGN': [{'NOT': [left]}, assignee]}
	if instr[1] in ['AND', 'OR', 'LSHIFT', 'RSHIFT']:
		left = parse_var_or_number(instr[0])
		right = parse_var_or_number(instr[2])
		assignee = parse_var_or_number(instr[4])
		op = instr[1]
		return {'ASSIGN': [{op: [left, right]}, assignee]}
	if instr[1] == '->':
		left = parse_var_or_number(instr[0])
		assignee = parse_var_or_number(instr[2])
		return {'ASSIGN': [left, assignee]}

def parse_var_or_number(v):
	v = v.strip('\n')
	if v.isdigit():
		return {'NUMBER': [int(v)]}
	return {'VARIABLE': [v]}

def parse_input(instr):
	for i in instr:
		i = parse_instruction(i)
		parsed_instructions.append(i)

def build_mapping(pi):
	for i in pi:
		e, a = i['ASSIGN']
		a = a['VARIABLE'][0]
		env.setdefault(a, None)
		env[a] = e

def interpret(instr):
	for i in instr:
		if i == 'NUMBER':
			return instr['NUMBER'][0]
		if i == 'ASSIGN':
			exp, v = instr['ASSIGN']
			env[v].append(exp)
		if i == 'VARIABLE':
			v = instr['VARIABLE'][0]
			eval(v)
			return interpret(env.get(v))
		if i == 'NOT':
			v = interpret(instr['NOT'][0])
			return ~v
		if i == 'AND':
			v1, v2 = instr['AND']
			v1, v2 = interpret(v1), interpret(v2)
			return v1 & v2
		if i == 'OR':
			e1, e2 = instr['OR']
			n1, n2 = interpret(e1), interpret(e2)
			return n1 | n2
		if i == 'LSHIFT':
			e1, e2 = instr['LSHIFT']
			n1, n2 = interpret(e1), interpret(e2)
			return n1 << n2
		if i == 'RSHIFT':
			e1, e2 = instr['RSHIFT']
			n1, n2 = interpret(e1), interpret(e2)
			return n1 >> n2
			
def eval(v):
	e = env.get(v)
	n = interpret(e)
	env[v] = {'NUMBER': [n]}


def tests():
	assert interpret({'NUMBER': [1]}) == 1
	assert interpret({'NOT':[{'NUMBER': [1]}]}) == -2
	assert interpret({'AND':[{'NUMBER': [1]}, {'NUMBER': [0]}]}) == 0
	assert interpret({'AND':[{'NUMBER': [1]}, {'NOT':[{'NUMBER': [0]}]}]}) == 1
	assert interpret({'OR': [{'NUMBER': [0]}, {'NUMBER':[1]}]}) == 1

#tests()	

with open('input.txt') as f:
	instr = f.readlines()
	instr.append('3176 -> b')
	parse_input(instr)
	build_mapping(parsed_instructions)
	eval('a')
	print env.get('a')
	
