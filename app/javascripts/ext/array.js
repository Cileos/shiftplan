Array.prototype.toSentence = function() {
  return this.join(', ');
};

Array.prototype.contains = function(object){
  for(var i = 0; i < this.length; i++) {
    if(this[i] === object) {
      return true;
    }
  }
  return false;
};

Array.prototype.intersect = function(other) {
	var result = [];
	for (var i = 0; i < this.length; i++) {
		if(other.contains(this[i])) {
			result.push(this[i]);
		}
  }
	return result;
}
