mapping = dict()
parsed_instructions = list()

def parse_instruction(instr):
	instr = instr.split(' ')
	if instr[0] == 'NOT':
		left = parse_var_or_number(instr[1])
		assignee = parse_var_or_number(instr[3])
		return {'ASSIGN': [{'NOT': left}, assignee]}
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
		return {'NUMBER': int(v)}
	return {'VARIABLE': v}

def parse_input(instr):
	for i in instr:
		i = parse_instruction(i)
		parsed_instructions.append(i)

def build_mapping(pi):
	for i in pi:
		e, a = i['ASSIGN']
		a = a['VARIABLE']
		mapping.setdefault(a, [])
		mapping[a].append(e)

def interpret(instr):
	for i in instr:
		if i == 'NOT':
			return 
	

with open('input.txt') as f:
	instr = f.readlines()
	parse_input(instr)
	build_mapping(parsed_instructions)

