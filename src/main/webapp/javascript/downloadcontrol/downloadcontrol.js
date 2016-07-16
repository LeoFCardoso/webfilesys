var fileDownloadCheckTimer;
function blockUIForDownload(token) {
	$.blockUI({
		message : '<h1><img src="<%=request.getContextPath()%>/images/busy.gif" /> Aguarde...</h1>'
	});
	$('.blockOverlay').attr('title','Clique para fechar').click(finishDownload); 
	fileDownloadCheckTimer = window.setInterval(function() {
		var cookieValue = $.cookie('fileDownloadToken');
		if (cookieValue == token) {
			finishDownload();
		}
	}, 1000);
}
function finishDownload() {
	window.clearInterval(fileDownloadCheckTimer);
	$.removeCookie('fileDownloadToken');
	$.unblockUI();
}
