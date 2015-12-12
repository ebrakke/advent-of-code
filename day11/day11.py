import string
alphabet = string.ascii_lowercase
start = 'hxbxxyzz'

def increment_password(previous_pwd):
	l = [x for x in previous_pwd]
	carry = True
	index = -1
	while carry:
		new_letter, carry = increment_letter(l[index])
		l[index] = new_letter
		index = index - 1
	return ''.join(l)

def increment_letter(l):
	carry = False
	indx = alphabet.index(l)
	nxt = (indx + 1) % 26
	if nxt < indx:
		carry = True
	return alphabet[nxt], carry

def valid_pwd(pwd):
	banned_letters = 'i' not in pwd and 'o' not in pwd and 'l' not in pwd
	increase = False
	doubles = []
	for (i,s) in enumerate(pwd):
		if i < len(pwd) - 2:
			if alphabet.index(pwd[i+2]) - alphabet.index(pwd[i+1]) == 1 and alphabet.index(pwd[i+1]) - alphabet.index(s) == 1:
				increase = True
		if i < len(pwd) - 1:
			if s == pwd[i + 1] and s + pwd[i+1] not in doubles:
				doubles.append(s + pwd[i+1])
	return banned_letters and increase and len(doubles) >= 2

pwd = increment_password(start)

while not valid_pwd(pwd):
	pwd = increment_password(pwd)

print pwd