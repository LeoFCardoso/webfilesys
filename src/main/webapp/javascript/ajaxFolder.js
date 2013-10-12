// Comment to prevent Eclipse Validation
// <%@ page language="java" contentType="text/javascript" %>

// var browserIsFirefox = /a/[-1]=='a';
var browserIsFirefox = navigator.userAgent.toLowerCase().indexOf('firefox') > -1;

var browserIsChrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;

var req;

function xmlRequest(url, callBackFunction) {
	req = false;

	if (window.XMLHttpRequest) {
		try {
			req = new XMLHttpRequest();
		} catch (e) {
			req = false;
		}
	} else {
		// branch for IE/Windows ActiveX version
		if (window.ActiveXObject) {
			try {
				req = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try {
					req = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e) {
					req = false;
				}
			}
		}
	}

	if (req) {
		req.onreadystatechange = callBackFunction;
		req.open("GET", url, true);
		req.send("");
	} else {
		alert('Your browser does not support the XMLHttpRequest');
	}
}

function xmlRequestSynchron(url, handleAsText) {
	req = false;

	if (window.XMLHttpRequest) {
		try {
			req = new XMLHttpRequest();
		} catch (e) {
			req = false;
		}
	} else {
		// branch for IE/Windows ActiveX version
		if (window.ActiveXObject) {
			try {
				req = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try {
					req = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e) {
					req = false;
				}
			}
		}
	}

	if (req) {
		req.open("GET", url, false);
		req.send(null);
	} else {
		alert('Your browser does not support the XMLHttpRequest');
	}

	if (req.status != 200) {
		alert('error code from XMLHttpRequest: ' + req.status);
		return;
	}

	if (handleAsText) {
		return (req.responseText);
	}

	return (req.responseXML);
}

function copyDirToClip(path) {
	url = "<%=request.getContextPath()%>/servlet?command=copyDir&path="
			+ encodeURIComponent(path);

	xmlRequest(url, showXmlResult);
}

function moveDirToClip(path) {
	url = "<%=request.getContextPath()%>/servlet?command=moveDir&path="
			+ encodeURIComponent(path);

	xmlRequest(url, showXmlResult);
}

function removeDir(path) {
	url = "<%=request.getContextPath()%>/servlet?command=removeDir&path="
			+ path;
	delDirStarted = true;
	xmlRequest(url, handleDirRemoved);
	setTimeout("checkLongRunningDelDir()", 3000);
}

function checkLongRunningDelDir() {
	if (delDirStarted) {
		showMessage(parent.resourceDelDirStarted);
	}
}

function handleDirRemoved() {
	if (req.readyState == 4) {
		if (req.status == 200) {
			delDirStarted = false;

			var successItem = req.responseXML.getElementsByTagName("success")[0];
			var success = successItem.firstChild.nodeValue;

			var messageItem = req.responseXML.getElementsByTagName("message")[0];
			var message = "";

			if (messageItem.firstChild) {
				message = messageItem.firstChild.nodeValue;
			}

			if (success == "deleted") {
				var pathItem = req.responseXML
						.getElementsByTagName("parentPath")[0];
				var parentPath = pathItem.firstChild.nodeValue;

				window.location.href = "<%=request.getContextPath()%>/servlet?command=exp&actPath="
						+ parentPath
						+ "&expand="
						+ parentPath
						+ "&fastPath=true";
			} else {
				alert(message);
				var pathItem = req.responseXML.getElementsByTagName("path")[0];
				if (pathItem) {
					var path = pathItem.firstChild.nodeValue;
					window.location.href = "<%=request.getContextPath()%>/servlet?command=exp&actPath="
							+ path + "&expand=" + path + "&fastPath=true";
				}
			}
		}
	}
}

function cancelSearch() {
	url = "<%=request.getContextPath()%>/servlet?command=cancelSearch";

	xmlRequest(url, handleSearchCanceled);
}

function clearThumbs(path) {
	url = "<%=request.getContextPath()%>/servlet?command=clearThumbs&path="
			+ encodeURIComponent(path);

	xmlRequest(url, showXmlResult);
}

function createThumbs(path) {
	url = "<%=request.getContextPath()%>/servlet?command=createThumbs&path="
			+ encodeURIComponent(path);

	xmlRequest(url, showXmlResult);
}

function winCmdLine(path) {
	url = "<%=request.getContextPath()%>/servlet?command=winCmdLine&path="
			+ encodeURIComponent(path);

	xmlRequest(url, handleCmdLineResult);
}

function showXmlResult() {
	if (req.readyState == 4) {
		if (req.status == 200) {
			var item = req.responseXML.getElementsByTagName("message")[0];
			var message = item.firstChild.nodeValue;

			hideMenu();

			msgBox1 = document.getElementById("msg1");

			if (window.ActiveXObject) {
				windowWidth = document.body.clientWidth;
				windowHeight = document.body.clientHeight;
				yScrolled = document.body.scrollTop;
				xScrolled = document.body.scrollLeft;
			} else {
				windowWidth = window.innerWidth;
				windowHeight = window.innerHeight;
				yScrolled = window.pageYOffset;
				xScrolled = window.pageXOffset;
			}

			msgXpos = 10 + xScrolled;

			msgBox1.style.left = msgXpos + 'px';

			msgYpos = (windowHeight - 100) / 2 + yScrolled;
			if (msgYpos < 10) {
				msgYpos = 10;
			}

			msgBox1.style.top = msgYpos + 'px';

			msgBox1.style.visibility = "visible";

			msgBox1.innerHTML = message;

			clipboardEmpty = false;

			setTimeout("hideMsg()", 2000);
		}
	}
}

function hideMsg() {
	msgBox1 = document.getElementById("msg1");
	msgBox1.style.visibility = "hidden";
}

function handleSearchCanceled() {
	if (req.readyState == 4) {
		if (req.status == 200) {
			// alert('search canceled');
		}
	}
}

function handleCmdLineResult() {
	if (req.readyState == 4) {
		if (req.status == 200) {
			var successItem = req.responseXML.getElementsByTagName("success")[0];
			var success = successItem.firstChild.nodeValue;

			if (success != 'true') {
				alert("Windows Command Line could not be started");
			}
		}
	}
}

function col(domId) {
	var urlEncodedPath;

	parentDiv = document.getElementById(domId);

	if (!parentDiv) {
		alert('Element with id ' + domId + ' not found');
	} else {
		urlEncodedPath = parentDiv.getAttribute("path");

		deselectCurrentDir();

		// first change minus sign into plus sign

		children = parentDiv.childNodes;

		for (i = 0; i < children.length; i++) {
			if (children[i].nodeName.toLowerCase() == 'a') {
				subChildren = children[i].childNodes;

				for (k = 0; k < subChildren.length; k++) {
					if (subChildren[k].nodeName.toLowerCase() == 'img') {
						if (subChildren[k].src.indexOf('minus') > 0) {
							subChildren[k].src = subChildren[k].src.replace(
									'minus', 'plus');

							children[i].href = children[i].href.replace('col',
									'exp');
						} else {
							if (subChildren[k].src.indexOf('folder.gif') > 0) {
								subChildren[k].src = subChildren[k].src
										.replace('folder.gif', 'folder1.gif');
							}
						}
					}
				}
			}
		}

		currentDirId = domId;

		// and now remove the divs of the subfolders

		children = parentDiv.childNodes;

		for (i = children.length - 1; i >= 0; i--) {
			if (children[i].nodeName.toLowerCase() == 'div') {
				parentDiv.removeChild(children[i]);
			}
		}
	}

	url = "<%=request.getContextPath()%>/servlet?command=ajaxCollapse&path="
			+ urlEncodedPath;

	xmlRequest(url, dummy);
}

function dummy() {
}

function deselectCurrentDir() {
	if (currentDirId != '') {
		oldCurrentDirDiv = document.getElementById(currentDirId);

		if (oldCurrentDirDiv) {
			children = oldCurrentDirDiv.childNodes;

			for (i = 0; i < children.length; i++) {
				if (children[i].nodeName.toLowerCase() == 'a') {
					subChildren = children[i].childNodes;

					for (k = 0; k < subChildren.length; k++) {
						if (subChildren[k].nodeName.toLowerCase() == 'img') {
							if (subChildren[k].src.indexOf('folder1.gif') > 0) {
								subChildren[k].src = subChildren[k].src
										.replace('folder1.gif', 'folder.gif');
							} else {
								if (subChildren[k].src.indexOf('miniDisk') > 0) {
									subChildren[k].src = subChildren[k].src
											.replace('miniDisk2.gif',
													'miniDisk.gif');
								}
							}
						}
					}
				}
			}
		}
	}
}

function selectCurrentDir(parentDiv) {
	children = parentDiv.childNodes;

	for (i = 0; i < children.length; i++) {
		if (children[i].nodeName.toLowerCase() == 'a') {
			subChildren = children[i].childNodes;

			for (k = 0; k < subChildren.length; k++) {
				if (subChildren[k].nodeName.toLowerCase() == 'img') {
					if (subChildren[k].src.indexOf('folder.gif') > 0) {
						subChildren[k].src = subChildren[k].src.replace(
								'folder.gif', 'folder1.gif');
					}
				}
			}
		}
	}
}

function listFiles(id) {
	parentDiv = document.getElementById(id);

	if (!parentDiv) {
		alert('Element with id ' + id + ' not found');

		return;
	}

	var urlEncodedPath = parentDiv.getAttribute("path");

	window.parent.frames[2].location.href = '<%=request.getContextPath()%>/servlet?command=listFiles&actpath='
			+ urlEncodedPath + '&mask=*';

	deselectCurrentDir();

	currentDirId = id;

	selectCurrentDir(parentDiv);
}

function exp(parentDivId, lastInLevel) {
	parentDiv = document.getElementById(parentDivId);

	if (!parentDiv) {
		alert('Element with id ' + parentDivId + ' not found');

		return;
	}

	if (parentDivId != currentDirId) {
		deselectCurrentDir();
	}

	var urlEncodedPath = parentDiv.getAttribute("path");

	var xmlUrl = "<%=request.getContextPath()%>/servlet?command=ajaxExp&path="
			+ urlEncodedPath + "&lastInLevel=" + lastInLevel;

	var xslUrl;

	if (window.ActiveXObject) {
		// MSIE

		xslUrl = "<%=request.getContextPath()%>/xsl/subFolder.xsl";

		expMSIE(parentDiv, xmlUrl, xslUrl);
	} else {
		if (browserIsFirefox || browserIsChrome) {
			// Firefox & Chrome

			xslUrl = "<%=request.getContextPath()%>/xsl/subFolder.xsl";

			expMozilla(parentDiv, xmlUrl, xslUrl);
		} else {
			// XSLT with Javascript (google ajaxslt)

			xslUrl = "<%=request.getContextPath()%>/xsl/subFolder.xsl";

			expJavascriptXslt(parentDiv, xmlUrl, xslUrl)
		}
	}

	setTimeout('setTooltips()', 500);
}

function expMozilla(parentDiv, xmlUrl, xslUrl) {
	var xslStyleSheet = xmlRequestSynchron(xslUrl);

	if (!xslStyleSheet) {
		window.parent.parent.location.href = '<%=request.getContextPath()%>/servlet?command=loginForm';

		return;
	}

	var xmlDoc = xmlRequestSynchron(xmlUrl);

	if (!xmlDoc) {
		window.parent.parent.location.href = '<%=request.getContextPath()%>/servlet?command=loginForm';

		return;
	}

	var html;

	var xsltProcessor = new XSLTProcessor();

	xsltProcessor.importStylesheet(xslStyleSheet);

	// Leonardo - add parameter context path
	xsltProcessor.setParameter(null, "contextPath",
			"<%=request.getContextPath()%>");

	fragment = xsltProcessor.transformToFragment(xmlDoc, document);

	parentDiv.innerHTML = '';

	currentDirId = fragment.childNodes[0].id;

	parentDiv.parentNode.replaceChild(fragment, parentDiv);
}

function expMSIE(parentDiv, xmlUrl, xslUrl) {
	xml = new ActiveXObject("Msxml2.DOMDocument.3.0");
	xml.async = false;
	if (!xml.load(xmlUrl)) {
		window.parent.parent.location.href = '<%=request.getContextPath()%>/servlet?command=loginForm';

		return;
	}

	var newId = xml.documentElement.getAttribute('id');

	var xslProcessor = xslTemplate.createProcessor();

	xslProcessor.input = xml;

	// Leonardo - add parameter context path
	xslProcessor.addParameter("contextPath", "<%=request.getContextPath()%>");

	xslProcessor.transform();

	parentDiv.outerHTML = xslProcessor.output;

	currentDirId = newId;
}

function expJavascriptXslt(parentDiv, xmlUrl, xslUrl) {
	var xslStyleSheet = xmlRequestSynchron(xslUrl);

	if (!xslStyleSheet) {
		window.parent.parent.location.href = '<%=request.getContextPath()%>/servlet?command=loginForm';

		return;
	}

	var xmlDoc = xmlRequestSynchron(xmlUrl);

	if (!xmlDoc) {
		window.parent.parent.location.href = '<%=request.getContextPath()%>/servlet?command=loginForm';

		return;
	}

	var newId = xmlDoc.documentElement.getAttribute('id');

	// browser-independend client-side XSL transformation with google ajaxslt

	var html = xsltProcess(xmlDoc, xslStyleSheet);

	parentDiv.outerHTML = html;

	currentDirId = newId;
}

function synchronize(path) {
	parent.syncStarted = !parent.syncStarted;

	url = "<%=request.getContextPath()%>/servlet?command=selectSyncFolder&path="
			+ encodeURIComponent(path);

	xmlRequest(url, selectSyncFolderResult);
}

function selectSyncFolderResult() {
	if (req.readyState == 4) {
		if (req.status == 200) {
			var item = req.responseXML.getElementsByTagName("success")[0];
			var result = item.firstChild.nodeValue;

			hideMenu();

			if (result == 'targetSelected') {
				openSyncWindow();
				return;
			}

			item = req.responseXML.getElementsByTagName("message")[0];
			var message = item.firstChild.nodeValue;

			showMessage(message);
		}
	}
}

function showMessage(message) {
	msgBox1 = document.getElementById("msg1");

	if (window.ActiveXObject) {
		windowWidth = document.body.clientWidth;
		windowHeight = document.body.clientHeight;
		yScrolled = document.body.scrollTop;
		xScrolled = document.body.scrollLeft;
	} else {
		windowWidth = window.innerWidth;
		windowHeight = window.innerHeight;
		yScrolled = window.pageYOffset;
		xScrolled = window.pageXOffset;
	}

	msgXpos = 10 + xScrolled;

	msgBox1.style.left = msgXpos + 'px';

	msgYpos = (windowHeight - 100) / 2 + yScrolled;
	if (msgYpos < 10) {
		msgYpos = 10;
	}

	msgBox1.style.top = msgYpos + 'px';

	msgBox1.style.visibility = "visible";

	msgBox1.innerHTML = message;

	setTimeout("hideMsg()", 4000);
}

function openSyncWindow() {
	syncWin = window
			.open(
					"<%=request.getContextPath()%>/servlet?command=syncCompare",
					"syncWin",
					"status=no,toolbar=no,location=no,menu=no,scrollbars=yes,width=700,height=500,resizable=yes,left=10,top=10,screenX=10,screenY=10");

	if (!syncWin) {
		alert(resourceBundle["alert.enablePopups"]);
		cancelSynchronize();
		return;
	}

	syncWin.focus();
}

function deselectSyncFolders() {
	url = "<%=request.getContextPath()%>/servlet?command=selectSyncFolder&cmd=deselect";

	xmlRequest(url, deselectSyncFolderResult);
}

function deselectSyncFolderResult() {
	if (req.readyState == 4) {
		if (req.status == 200) {
			setTimeout("self.close()", 100);
		}
	}
}

function cancelSynchronize() {
	url = "<%=request.getContextPath()%>/servlet?command=selectSyncFolder&cmd=deselect";

	xmlRequestSynchron(url);

	parent.syncStarted = false;

	hideMenu();

	stopMenuClose = true;
}

function compareFolders(path) {
	parent.compStarted = !parent.compStarted;

	url = "<%=request.getContextPath()%>/servlet?command=selectCompFolder&path="
			+ encodeURIComponent(path);

	xmlRequest(url, selectCompFolderResult);
}

function cancelCompare() {
	url = "<%=request.getContextPath()%>/servlet?command=selectCompFolder&cmd=deselect";

	xmlRequestSynchron(url);

	parent.compStarted = false;

	hideMenu();

	stopMenuClose = true;
}

function deselectCompFolders() {
	url = "<%=request.getContextPath()%>/servlet?command=selectCompFolder&cmd=deselect";

	xmlRequest(url, deselectCompFolderResult);
}

function deselectCompFolderResult() {
	if (req.readyState == 4) {
		if (req.status == 200) {
			setTimeout("self.close()", 100);
		}
	}
}

function compFolderParms() {
	showPrompt('<%=request.getContextPath()%>/servlet?command=compFolderParms',
			'<%=request.getContextPath()%>/xsl/compFolderParms.xsl', 340, 325);
}

function openCompWindow() {
	compWin = window
			.open(
					"<%=request.getContextPath()%>/servlet?command=blank",
					"compWin",
					"status=no,toolbar=no,location=no,menu=no,scrollbars=yes,width=700,height=500,resizable=yes,left=10,top=10,screenX=10,screenY=10");
	document.compParmsForm.target = 'compWin';
	if (document.compParmsForm.treeView.checked) {
		document.compParmsForm.command.value = 'folderDiffTree';
	}
	document.compParmsForm.submit();
	compWin.focus();
}

function selectCompFolderResult() {
	if (req.readyState == 4) {
		if (req.status == 200) {
			var item = req.responseXML.getElementsByTagName("success")[0];
			var result = item.firstChild.nodeValue;

			hideMenu();

			if (result == 'targetSelected') {
				compFolderParms();
				return;
			}

			item = req.responseXML.getElementsByTagName("message")[0];
			var message = item.firstChild.nodeValue;

			showMessage(message);
		}
	}
}

function getPageYScrolled() {
	if (!browserIsFirefox) {
		return document.body.scrollTop;
	}

	return window.pageYOffset;
}

function getPageXScrolled() {
	if (!browserIsFirefox) {
		return document.body.scrollLeft;
	}

	return window.pageXOffset;
}
