<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
<xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="UTF-8" />

<xsl:param name="contextPath"/>

<xsl:strip-space elements="folderTree computer folder" />

<xsl:include href="util.xsl" />

<!-- root node-->
<xsl:template match="/">

<html>
<head>

<meta http-equiv="expires" content="0" />

<link rel="stylesheet" type="text/css">
  <xsl:attribute name="href"><xsl:value-of select="$contextPath"/>/css/<xsl:value-of select="/folderTree/css" />.css</xsl:attribute>
</link>

<xsl:if test="not(folderTree/browserXslEnabled)">
  <script language="JavaScript" src="{$contextPath}/javascript/ajaxslt/util.js" type="text/javascript"></script>
  <script language="JavaScript" src="{$contextPath}/javascript/ajaxslt/xmltoken.js" type="text/javascript"></script>
  <script language="JavaScript" src="{$contextPath}/javascript/ajaxslt/dom.js" type="text/javascript"></script>
  <script language="JavaScript" src="{$contextPath}/javascript/ajaxslt/xpath.js" type="text/javascript"></script>
  <script language="JavaScript" src="{$contextPath}/javascript/ajaxslt/xslt.js" type="text/javascript"></script>
</xsl:if>

<script language="JavaScript" src="{$contextPath}/javascript/browserCheck.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/tooltips.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/fmweb.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/ajaxCommon.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/ajaxFolder.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/dirContextMenu.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/contextMenuMouse.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/jsDirMenu.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/keyDirTree.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/util.js" type="text/javascript"></script>

<!-- jQuery LCARD -->
<script language="JavaScript" src="{$contextPath}/javascript/jquery/jquery-3.0.0.min.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/jquery/jquery.blockUI.js" type="text/javascript"></script>
<script language="JavaScript" src="{$contextPath}/javascript/jquery/jquery.cookie.js" type="text/javascript"></script>
<!-- end jQuery LCARD -->

<!-- download control LCARD -->
<script language="JavaScript">
	var fileDownloadCheckTimer;
  	function blockUIForDownload(token) {
		$.blockUI({ message: '<h1>Aguarde...</h1>' });
		fileDownloadCheckTimer = window.setInterval(function () {
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
</script>
<!-- end download control LCARD -->

<script src="{$contextPath}/javascript/resourceBundle.js" type="text/javascript"></script>
<script type="text/javascript">
  <xsl:attribute name="src"><xsl:value-of select="$contextPath"/>/servlet?command=getResourceBundle&amp;lang=<xsl:value-of select="/folderTree/language" /></xsl:attribute>
</script>

<script language="javascript">

  var folderTip = resourceBundle["tooltip.folder"];
  var listTip = resourceBundle["tooltip.listFiles"];
  
  var clipboardEmpty = <xsl:value-of select="/folderTree/clipBoardEmpty" />;
  
  <!-- Id of the div of the current folder -->
  var currentDirId = '';
  
  var delDirStarted = false;

  function scrollToCurrent()
  {
      scrollTo(0,<xsl:value-of select="/folderTree/scrollPos" />);
  }

  <xsl:if test="folderTree/loginEvent">
    function hideHint()
    {
        document.getElementById('hint').style.visibility = 'hidden';
    }
  </xsl:if>

  <!-- create Stylesheet-Processor for MSIE and precompile stylesheet -->  
  if (window.ActiveXObject) 
  {
      var xsl = new ActiveXObject('MSXML2.FreeThreadedDOMDocument.3.0');
      xsl.async = false;
      xsl.load("<xsl:value-of select="$contextPath"/>/xsl/subFolder.xsl");

      xslTemplate = new ActiveXObject("Msxml2.XSLTemplate.3.0");
      xslTemplate.stylesheet = xsl;
  }

  document.onkeypress = handleFolderTreeKey;

</script>

<style type="text/css">
  img {vertical-align:middle}
</style>

</head>

<body onclick="mouseClickHandler()">
<xsl:attribute name="class">dirTree</xsl:attribute>
<xsl:attribute name="onLoad">setBundleResources();setTimeout('scrollToCurrent()', 100);setTimeout('setTooltips()', 500);</xsl:attribute>

<xsl:apply-templates />

</body>
</html>

<div id="contextMenu" style="position:absolute;top:0px;left:0px;background-color:#c0c0c0;border-style:ridge;border-width:3;border-color:#c0c0c0;visibility:hidden" onclick="menuClicked()"></div>

<xsl:if test="folderTree/loginEvent">
  <div id="hint" class="hint" style="position:absolute;top:10px;left:50%;width:40%;">
    <xsl:attribute name="onClick">javascript:hideHint()</xsl:attribute>
    <img src="{$contextPath}/images/winClose.gif" border="0" style="float:right;" />
    <span resource="label.loginHint"></span>
  </div>
</xsl:if>

<div id="msg1" class="msgBox" style="visibility:hidden" />

<div id="prompt" class="promptBox" style="visibility:hidden" />

</xsl:template>
<!-- end root node-->

<xsl:template match="folderTree">

  <xsl:for-each select="computer">
    <xsl:call-template name="computer" />
  </xsl:for-each>

  <xsl:if test="fastPath">
    <script language="javascript">
      encodedPath = encodeURIComponent('<xsl:value-of select="fastPath" />');
      parent.frames[2].window.location.href = "<xsl:value-of select="$contextPath"/>/servlet?command=listFiles&amp;actpath=" + encodedPath + "&amp;mask=*";
    </script>
  </xsl:if>

</xsl:template>

<xsl:template name="computer" match="computer"> 

  <img src="{$contextPath}/images/space.gif" style="border-style:none;width:10px;height:17px;" />
  <img src="{$contextPath}/images/computer.gif" class="computer" />
  <a class="dirtree">
    <xsl:value-of select="@name" />
  </a>

  <xsl:apply-templates />
</xsl:template>

<xsl:template match="folder"> 

  <xsl:variable name="pathForScript"><xsl:call-template name="insDoubleBackslash"><xsl:with-param name="string"><xsl:value-of select="@path" /></xsl:with-param></xsl:call-template></xsl:variable>

  <div class="last">

     <xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>

     <xsl:attribute name="path"><xsl:value-of select="@path" /></xsl:attribute>

      <xsl:if test="folder">
        <a>
          <xsl:attribute name="href">javascript:col('<xsl:value-of select="@id" />')</xsl:attribute>

          <xsl:if test="position()=last()">
            <img src="{$contextPath}/images/minusLast.gif" class="expCol" />
          </xsl:if>
          <xsl:if test="position()!=last()">
            <img src="{$contextPath}/images/minusMore.gif" class="expCol" />
          </xsl:if>
        </a>
      </xsl:if>
      
      <xsl:if test="not(folder)">
        <xsl:if test="not(@leaf)">

          <a>
            <xsl:attribute name="href">javascript:exp('<xsl:value-of select="@id" />', '<xsl:value-of select="position()=last()" />')</xsl:attribute>

            <xsl:if test="position()=last()">
              <img src="{$contextPath}/images/plusLast.gif" class="expCol" />
            </xsl:if>
            <xsl:if test="position()!=last()">
              <img src="{$contextPath}/images/plusMore.gif" class="expCol" />
            </xsl:if>
          </a>

        </xsl:if>
        <xsl:if test="@leaf">
          <xsl:if test="position()=last()">
            <img src="{$contextPath}/images/branchLast.gif" class="expCol" />
          </xsl:if>
          <xsl:if test="position()!=last()">
            <img src="{$contextPath}/images/branch.gif" class="expCol" />
          </xsl:if>
        </xsl:if>
      </xsl:if>

    <a>

      <xsl:attribute name="href">javascript:dirContextMenu('<xsl:value-of select="@id" />')</xsl:attribute>
      
      <xsl:if test="@type='drive'">
        <img src="{$contextPath}/images/miniDisk.gif" border="0" width="17" height="14">
          <xsl:if test="@label">
            <xsl:attribute name="title"><xsl:value-of select="@label" /></xsl:attribute>
          </xsl:if>
        </img>
      </xsl:if>

      <xsl:if test="@type='floppy'">
        <img src="{$contextPath}/images/miniFloppy.gif" border="0" width="18" height="16">
          <xsl:if test="@label">
            <xsl:attribute name="title"><xsl:value-of select="@label" /></xsl:attribute>
          </xsl:if>
        </img>
      </xsl:if>

      <xsl:if test="not(@type)">
        <xsl:if test="@current">
          <xsl:if test="@icon">
            <img class="icon">
              <xsl:attribute name="src"><xsl:value-of select="$contextPath"/>/icons/<xsl:value-of select="@icon"/></xsl:attribute>
            </img>
          </xsl:if>
          <xsl:if test="not(@icon)">
            <img src="{$contextPath}/images/folder1.gif" class="folder" />
          </xsl:if>
          <script language="javascript">
            currentDirId = '<xsl:value-of select="@id" />';
          </script>
        </xsl:if>
        <xsl:if test="not(@current)">
          <xsl:if test="@icon">
            <img class="icon">
              <xsl:attribute name="src"><xsl:value-of select="$contextPath"/>/icons/<xsl:value-of select="@icon"/></xsl:attribute>
            </img>
          </xsl:if>
          <xsl:if test="not(@icon)">
            <img src="{$contextPath}/images/folder.gif" class="folder" />
          </xsl:if>
        </xsl:if>
      </xsl:if>
    </a>

    <a>
      <xsl:attribute name="href">javascript:listFiles('<xsl:value-of select="@id"/>')</xsl:attribute>
      <xsl:attribute name="oncontextmenu">dirContextMenu('<xsl:value-of select="@id" />');return false;</xsl:attribute>

      <xsl:if test="@link">
        <xsl:attribute name="class">link dirSpacer</xsl:attribute>

        <xsl:attribute name="title">
          <xsl:value-of select="'--&gt; '"/>
          <xsl:value-of select="@linkDir"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="not(@link)">
        <xsl:attribute name="class">dirtree dirSpacer</xsl:attribute>
        <xsl:if test="@textColor">
          <xsl:attribute name="style">color:<xsl:value-of select="@textColor" /></xsl:attribute>
        </xsl:if>
      </xsl:if>
    
      <xsl:value-of select="@name" />
    </a>

    <xsl:if test="folder">
      <xsl:if test="position()=last()">
        <div class="indent">
          <xsl:apply-templates />
        </div>
      </xsl:if>

      <xsl:if test="position()!=last()">
        <div class="indent">
          <div class="more">
            <xsl:apply-templates />
          </div>
        </div>
      </xsl:if>
    </xsl:if>

  </div>
  
</xsl:template>

</xsl:stylesheet>

