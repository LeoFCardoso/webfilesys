<html>
  <head>
    <script language="JavaScript" src="<%=request.getContextPath()%>/javascript/browserCheck.js" type="text/javascript"></script>
    <script language="JavaScript" src="<%=request.getContextPath()%>/javascript/ajaxCommon.js" type="text/javascript"></script>
    <script language="JavaScript" src="<%=request.getContextPath()%>/javascript/ajaxFolder.js" type="text/javascript"></script>

    <script type="text/javascript">
      function callStats()
      {
          var xmlUrl = "<%=request.getContextPath()%>/servlet" + window.location.search
          var xslUrl = "<%=request.getContextPath()%>/xsl/fileTypeTreeStats.xsl";
          
          var statsHTML = browserXslt(xmlUrl, xslUrl);
          
          document.write(statsHTML);
      }   
      
    </script>
  </head>
  <body onload="setTimeout('showHourGlass()',100);setTimeout('callStats()', 1000);">
    <div style="width:100%;height:100%" />
  </body>
</html>