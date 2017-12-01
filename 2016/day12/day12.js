function processInput(evt) {
	var files = evt.target.files;
	var fr = new FileReader();
	fr.readAsText(files['0']);
	fr.onload = function(evt) {
		var input = JSON.parse(evt.target.result);
		done(input);
	}
}

function done(input) {
	var sum = findSumNumbers(input)
	console.log(sum);
}

function findSumNumbers(obj) {
	if (_.isNumber(obj)) {
		return obj;
	}

	if (_.isString(obj)) {
		return 0;
	}

	if (_.isArray(obj)) {
		var totalSum = 0;
		_.each(obj, function(item) {
			totalSum += findSumNumbers(item);
		});
		return totalSum;
	}
	var keys = _.keys(obj);
	var totalSum = 0;
	var red = _.values(obj).indexOf('red') > -1;
	if (red) {
		return 0;
	}
	_.each(keys, function(key) {
		var item = obj[key];
		totalSum += findSumNumbers(item);
	});
	return totalSum;
}

document.getElementById('file').addEventListener('change', processInput, false);