var Util = {
	fix_droppable_proportions: function(offset) {
		// jumping through hoops because jquery.ui's force us
		var list = $.ui.ddmanager.droppables['default'];
		for (var i = 0; i < list.length; i++) {
			list[i].proportions.height += offset;
		}
	}
}
