reindeer = dict()
distance = dict()
points = dict()

def parse(r):
	r = r.split(' ')
	rd, dist, dur, rest_dur = r[0], int(r[3]), int(r[6]), int(r[13])
	reindeer[rd] = (dist, dur, rest_dur)

def distance_after_seconds(r, t):
	dist, dur, rest_dur = reindeer.get(r)
	cycles = t // (dur + rest_dur) 
	distance[r] = cycles * (dist * dur)
	if t % (dur + rest_dur) < dur:
		distance[r] += (dist * (t % (dur + rest_dur)))
		return
	distance[r] += (dist * dur)

def distance_increment(r, t):
	dist, dur, rest_dur = reindeer.get(r)
	one_cycle = dur + rest_dur
	point_in_cycle = t % one_cycle
	if point_in_cycle < dur:
		distance.setdefault(r, 0)
		distance[r] += dist


def points_after_second():
	max_dist = max([distance.get(r) for r in distance])
	leaders = [r for r in distance if distance.get(r) == max_dist]
	for l in leaders:
		points.setdefault(l, 0)
		points[l] += 1

with open('input.txt') as f:
	f = f.readlines()
	for r in f:
		parse(r)
	# for r in reindeer:
	# 	distance_after_seconds(r, 2503)
	# print max([(r, distance.get(r)) for r in distance], key=lambda x: x[1])
	for t in range(2503):
		for r in reindeer:
			distance_increment(r, t)
		points_after_second()
	print max([points.get(r) for r in points])
