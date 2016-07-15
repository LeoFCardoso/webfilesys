function hideMenu() {
	document.getElementById('contextMenu').style.visibility = 'hidden';
}

function getFileNameExt(fileName) {
	fileExt = "";

	extStart = fileName.lastIndexOf('.');

	if (extStart > 0) {
		fileExt = fileName.substring(extStart).toUpperCase();
	}

	return (fileExt);
}

function insertDoubleBackslash(source) {
	return (source.replace(/\\/g, "\\\\"));
}

function menuEntry(href, label, target) {
	targetText = "";
	if (target != null) {
		targetText = 'target="' + target + '"';
	}
	return ('<tr>' + '<td class="jsmenu">' + '<a class="menuitem" href="' + href + '" ' + targetText + '>' + label
			+ '</a>' + '</td>' + '</tr>');
}

function menuEntryBlockUi(href, label, target) {
	targetText = "";
	if (target != null) {
		targetText = 'target="' + target + '"';
	}
	var token = new Date().getTime(); // Download token cookie
	href = href + '&token=' + token;
	return ('<tr>' + '<td class="jsmenu">' + '<a onclick="blockUIForDownload(' + token + ');" class="menuitem" href="'
			+ href + '" ' + targetText + '>' + label + '</a>' + '</td>' + '</tr>');
}