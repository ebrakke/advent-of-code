import re
regex = r'(\\\\|\\\"|\\x([a-f0-9]).|[a-zA-Z0-9])'
def in_memory_size(s):
	s = s.strip('\n')
	return len(re.findall(regex, s))

def new_encoding(s):
	s = re.sub(r'\\', r'\\\\', s)
	s = re.sub(r'\"', '\\\"', s)
	return '"' + s + '"'
	
with open('input.txt') as f:
	f = f.readlines()
	new_count = 0
	code_count = 0
	for i in f:
		new_count += len(new_encoding(i.strip('\n')))
		code_count += len(i.strip('\n'))
	print new_count - code_count