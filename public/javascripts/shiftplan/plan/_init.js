$(document).ready(function() {
	Plan.init();
	$.each(Resource.types, function() {
		this.init();
	})
});
