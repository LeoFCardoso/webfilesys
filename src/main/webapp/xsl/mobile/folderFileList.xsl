<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
<xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="UTF-8" />

<xsl:param name="contextPath"/>

<xsl:strip-space elements="folderFileList" />

<xsl:include href="../util.xsl" />

<!-- root node-->
<xsl:template match="/">

<html>
<head>

  <meta http-equiv="expires" content="0" />

  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes" />

  <link rel="stylesheet" type="text/css">
    <xsl:attribute name="href"><xsl:value-of select="$contextPath"/>/css/<xsl:value-of select="/folderFileList/css" />.css</xsl:attribute>
  </link>

  <title><xsl:value-of select="folderFileList/resources/msg[@key='label.mobileWindowTitle']/@value" /></title>

  <script src="{$contextPath}/javascript/browserCheck.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/fmweb.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/ajaxCommon.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/ajax.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/ajaxFolder.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/util.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/mobile/mobileCommon.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/mobile/contextMenuCommon.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/mobile/fileContextMenu.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/mobile/linkContextMenu.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/contextMenuMouse.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/mobile/jsFileMenu.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/mobile/dirContextMenu.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/mobile/jsDirMenu.js" type="text/javascript"></script>
  
  <script src="{$contextPath}/javascript/ajaxslt/util.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/ajaxslt/xmltoken.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/ajaxslt/dom.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/ajaxslt/xpath.js" type="text/javascript"></script>
  <script src="{$contextPath}/javascript/ajaxslt/xslt.js" type="text/javascript"></script>

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
	//Handle back button and cache
	// http://stackoverflow.com/questions/8788802/prevent-safari-loading-from-cache-when-back-button-is-clicked
	$(window).bind("pageshow", function(event) {
    	if (event.originalEvent.persisted) {
        	window.location.reload() 
    	}
	});
</script>
<!-- end download control LCARD -->

  <script src="{$contextPath}/javascript/resourceBundle.js" type="text/javascript"></script>
  <script type="text/javascript">
    <xsl:attribute name="src"><xsl:value-of select="$contextPath"/>/servlet?command=getResourceBundle&amp;lang=<xsl:value-of select="/folderFileList/language" /></xsl:attribute>
  </script>

  <script type="text/javascript">
  
    var noFileSelected = '<xsl:value-of select="folderFileList/resources/msg[@key='alert.nofileselected']/@value" />';
  
    var path = '<xsl:value-of select="/folderFileList/menuPath" />';
    
    var serverOS = '<xsl:value-of select="/folderFileList/serverOS" />';
    
    var mailEnabled = '<xsl:value-of select="/folderFileList/mailEnabled" />';
    
    var readonly = '<xsl:value-of select="/folderFileList/readonly" />';
    
    var clipboardEmpty = '<xsl:value-of select="/folderFileList/clipboardEmpty" />';

    <xsl:for-each select="/folderFileList/fileList/file">
      <xsl:if test="@link">
        function lm<xsl:value-of select="position()" />()
        {
            jsLinkMenu('<xsl:value-of select="@name" />','<xsl:value-of select="@linkMenuPath" />');     
        }
      </xsl:if>
      <xsl:if test="not(@link)">
        function cm<xsl:value-of select="position()" />()
        {
            contextMenu('<xsl:value-of select="@name" />');     
        }
      </xsl:if>
    </xsl:for-each>  
    
    var browserIsMSIE = '\v'=='v';
 
    function sendOnEnter()
    {
        if (!browserIsMSIE)
        {
            return false;
        }
   
        if (event.keyCode == 13)
        {
            document.sortform.submit();
        }
    }  
    
  </script>

</head>

<body id="fileListBody" class="mobile" onclick="mouseClickHandler()" onload="setBundleResources()">

  <xsl:for-each select="folderFileList/currentPath">
    <xsl:call-template name="currentPath" />
  </xsl:for-each>
  
  <xsl:if test="folderFileList/description">
    <table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <xsl:if test="folderFileList/description">
          <td class="folderDesc">
            <xsl:value-of select="folderFileList/description" disable-output-escaping="yes" />
          </td>
        </xsl:if>
      </tr>
    </table>
  </xsl:if>
  
  <xsl:for-each select="folderFileList">
    <xsl:call-template name="sortAndPaging" />
  </xsl:for-each>
  
  <table class="topLess" border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
      <xsl:if test="folderFileList/folders/folder">
        <td class="subFolderList" style="vertical-align:top">
          <xsl:for-each select="folderFileList/folders">
            <xsl:call-template name="folders" />
          </xsl:for-each>
        </td>
      </xsl:if>
      <td class="fileListFunct" style="padding:0;vertical-align:top;">
        <xsl:for-each select="folderFileList">
          <xsl:call-template name="fileList" />
        </xsl:for-each>
      </td>
    </tr>
  </table>

</body>

</html>

<div id="contextMenu" style="position:absolute;top:300px;left:250px;width=180px;height=40px;background-color:#c0c0c0;border-style:ridge;border-width:3;border-color:#c0c0c0;visibility:hidden" onclick="menuClicked()">&#160;</div>

<div id="msg1" class="msgBox" style="visibility:hidden" />

<div id="prompt" class="promptBox" style="visibility:hidden" />

</xsl:template>
<!-- end root node-->

<!-- ############################## path ################################ -->

<xsl:template name="currentPath">

  <table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
      <td>
      
        <div class="albumPath">
          <xsl:for-each select="pathElem">
            <a class="currentPath">
              <xsl:attribute name="href"><xsl:value-of select="$contextPath"/>/servlet?command=mobile&amp;cmd=folderFileList&amp;relPath=<xsl:value-of select="@path"/></xsl:attribute>
              <xsl:value-of select="@name"/> 
            </a>
            <xsl:if test="not(position()=last())"><font class="currentPathSep"><b> / </b></font></xsl:if>
          </xsl:for-each>
        </div>
        
      </td>

      <td style="text-align:right;vertical-align:bottom;padding-bottom:1px;">
        <select id="functionSelect" onchange="mobileFunctionSelected()">
          <option value="0" selected="selected"><xsl:value-of select="/folderFileList/resources/msg[@key='label.selectFunction']/@value" /></option>
	      <xsl:if test="not(/folderFileList/readonly) or (/folderFileList/readonly != 'true')">
	          <option value="1"><xsl:value-of select="/folderFileList/resources/msg[@key='label.bookmarksMobile']/@value" /></option>
	          <option value="2"><xsl:value-of select="/folderFileList/resources/msg[@key='label.about']/@value" /></option>
	      </xsl:if>
          <option value="3"><xsl:value-of select="/folderFileList/resources/msg[@key='classicView']/@value" /></option>
          <option value="4"><xsl:value-of select="/folderFileList/resources/msg[@key='label.logout']/@value" /></option>
        </select>
      </td>
      
    </tr>
  </table>
  
</xsl:template>

<!-- ############################## sorting and paging ################################ -->

<xsl:template name="sortAndPaging">
  <form accept-charset="utf-8" name="sortform" method="get" action="{$contextPath}/servlet" style="padding:0px;margin:0px;">
    <input type="hidden" name="command" value="mobile" />
    <input type="hidden" name="cmd" value="folderFileList" />
    
    <table class="folderFileList" border="0" cellpadding="0" cellspacing="0">

      <tr>
        <td class="fileListFunct2">
          <xsl:if test="folders/folder and (not(fileList/file))">
            <xsl:attribute name="class">fileListFunct2 sepBottom</xsl:attribute>
          </xsl:if>

          <xsl:if test="fileList/file">
            <xsl:attribute name="class">fileListFunct2</xsl:attribute>
          </xsl:if>
            
          <table border="0" width="100%">
            <tr>
              <td class="fileListFunct" nowrap="nowrap">
                <xsl:value-of select="resources/msg[@key='label.mask']/@value" />:
                <input type="text" name="mask" maxlength="256" style="width:40px;" onkeyup="sendOnEnter()">
                  <xsl:attribute name="value">
                    <xsl:value-of select="filter" />
                  </xsl:attribute>
                  <xsl:attribute name="onchange">document.sortform.submit()</xsl:attribute>
                </input>

              </td>
                
              <xsl:if test="fileList/file">
                <td class="fileListFunct" align="right" nowrap="nowrap">
                  <xsl:value-of select="resources/msg[@key='label.listPageSize']/@value" />:
                  
                  <input type="text" name="pageSize" maxlength="4" style="width:35px;" onkeyup="sendOnEnter()">
                    <xsl:attribute name="value">
                      <xsl:value-of select="paging/pageSize" />
                    </xsl:attribute>
                    <xsl:attribute name="onchange">document.sortform.submit()</xsl:attribute>
                  </input>
                </td>
              </xsl:if>

              <xsl:if test="fileList/file">

                <td class="fileListFunct" align="right" nowrap="nowrap">
                  <select id="sortBy" name="sortBy" size="1" onChange="document.sortform.submit();">
                    <option value="1">
                      <xsl:if test="sortBy='1'">
                        <xsl:attribute name="selected">true</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="resources/msg[@key='sort.name']/@value" />
                    </option>
                  
                    <option value="3">
                      <xsl:if test="sortBy='3'">
                        <xsl:attribute name="selected">true</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="resources/msg[@key='sort.extension']/@value" />
                    </option>
                  
                    <option value="4">
                      <xsl:if test="sortBy='4'">
                        <xsl:attribute name="selected">true</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="resources/msg[@key='sort.size']/@value" />
                    </option>
                  
                    <option value="5">
                      <xsl:if test="sortBy='5'">
                        <xsl:attribute name="selected">true</xsl:attribute>
                      </xsl:if>
                      <xsl:value-of select="resources/msg[@key='sort.date']/@value" />
                    </option>
                  </select>
                </td>

              </xsl:if>
              
            </tr>
          </table>
        </td>
      </tr>
      
      <!-- paging -->
      
      <xsl:if test="fileList/file">
 
        <tr>
          <td class="fileListFunct2 sepBottom">

            <table border="0" cellpadding="2" width="100%">
              <tr>
            
                <xsl:if test="paging/currentPage &gt; 1">
                  <td class="fileListFunct" valign="center" nowrap="true">
                    <a href="{$contextPath}/servlet?command=mobile&amp;cmd=folderFileList&amp;startIdx=0">
                      <img src="{$contextPath}/images/first.gif" border="0" />
                    </a>
                    &#160;
                    <a>
                      <xsl:attribute name="href"><xsl:value-of select="$contextPath"/>/servlet?command=mobile&amp;cmd=folderFileList&amp;startIdx=<xsl:value-of select="paging/prevStartIdx"/></xsl:attribute>
                      <img src="{$contextPath}/images/previous.gif" border="0" />
                    </a>
                  </td>
                </xsl:if>
            
                <td class="fileListFunct" valign="center" nowrap="true">
                  <xsl:value-of select="paging/firstOnPage" />
                  ...
                  <xsl:value-of select="paging/lastOnPage" />
                  /
                  <xsl:value-of select="fileNumber" />
                </td>
              
                <xsl:if test="fileNumber &gt; paging/pageSize">
              
                  <td class="fileListFunct" valign="center" nowrap="true">
                    <xsl:value-of select="resources/msg[@key='label.page']/@value" /> 

                    <xsl:for-each select="paging/page">
                      <img src="images/space.gif" border="0" width="5" />
                      <xsl:if test="@num=../currentPage">
                        <span class="pageNum"><xsl:value-of select="@num" /></span>
                      </xsl:if>
                      <xsl:if test="not(@num=../currentPage)">
                        <span class="pageNum">
                          <a class="pageNum">
                            <xsl:attribute name="href"><xsl:value-of select="$contextPath"/>/servlet?command=mobile&amp;cmd=folderFileList&amp;startIdx=<xsl:value-of select="@startIdx"/></xsl:attribute>
                            <xsl:value-of select="@num" />
                          </a>
                        </span>
                      </xsl:if>
                    </xsl:for-each>
                  </td>

                  <xsl:if test="paging/nextStartIdx">
                    <td class="fileListFunct">
                      <img src="images/space.gif" border="0" width="16" />
                    </td>
              
                    <td class="fileListFunct" align="right" valign="center" nowrap="true">
                      <a>
                        <xsl:attribute name="href"><xsl:value-of select="$contextPath"/>/servlet?command=mobile&amp;cmd=folderFileList&amp;startIdx=<xsl:value-of select="paging/nextStartIdx"/></xsl:attribute>
                        <img src="{$contextPath}/images/next.gif" border="0" />
                      </a>
                      &#160;
                      <a>
                        <xsl:attribute name="href"><xsl:value-of select="$contextPath"/>/servlet?command=mobile&amp;cmd=folderFileList&amp;startIdx=<xsl:value-of select="paging/lastStartIdx"/></xsl:attribute>
                        <img src="{$contextPath}/images/last.gif" border="0" />
                      </a>
                    </td>
                  </xsl:if>
                
                </xsl:if>
              </tr>
            </table>
          </td>
        </tr>
      
      </xsl:if>
      
    </table>    
  </form>
</xsl:template>

<!-- ############################## subfolders ################################ -->

<xsl:template name="folders">

  <table border="0">
  
    <xsl:for-each select="folder">

      <xsl:variable name="pathForScript"><xsl:call-template name="insDoubleBackslash"><xsl:with-param name="string"><xsl:value-of select="@path" /></xsl:with-param></xsl:call-template></xsl:variable>

      <tr>
        <td nowrap="nowrap">
          <img src="{$contextPath}/images/folder.gif" border="0" style="vertical-align:middle"/>
          <img src="{$contextPath}/images/space.gif" border="0" width="3" height="1" />
          
          <a class="subFolder">
            <xsl:attribute name="href"><xsl:value-of select="$contextPath"/>/servlet?command=mobile&amp;cmd=folderFileList&amp;relPath=<xsl:value-of select="@path"/>&amp;initial=true</xsl:attribute>
            <xsl:attribute name="title"><xsl:value-of select="@name" /></xsl:attribute>
            <xsl:value-of select="@displayName"/> 
          </a>
          &#160;
          <a>
            <xsl:attribute name="href">javascript:folderContextMenu(decodeURIComponent('<xsl:value-of select="$pathForScript" />'), '<xsl:value-of select="@name" />', '<xsl:value-of select="/folderFileList/menuPath" />')</xsl:attribute>
            <img src="{$contextPath}/images/next.png" border="0" width="20" height="18" style="vertical-align:middle"/>
          </a>
        </td>
      </tr>
    </xsl:for-each>
    
  </table>

</xsl:template>

<!-- ############################## file list ################################ -->

<xsl:template name="fileList">

  <form accept-charset="utf-8" name="form1" action="{$contextPath}/servlet" method="post" style="padding:0px;margin:0px;">
  
    <input type="hidden" name="command" value="mobileMultiFile" />

    <input type="hidden" name="actpath">
      <xsl:attribute name="value">
        <xsl:value-of select="/folderFileList/currentPath/@path" />
      </xsl:attribute>
    </input>

    <table border="0" cellpadding="0" cellspacing="0" width="100%">

      <xsl:if test="not(fileList/file)">
        <xsl:if test="not(/folderFileList/folders/folder)">
          <tr>
            <td colspan="3" class="fileListFunct">
              <xsl:value-of select="/folderFileList/resources/msg[@key='folderIsEmpty']/@value" />
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
      
      <xsl:if test="fileList/file">

        <xsl:for-each select="fileList/file">
 
          <tr>
            <td class="fileListData">
              <input type="checkbox" class="cb2">
                <xsl:attribute name="name">
                  <xsl:value-of select="@name" />
                </xsl:attribute>
                <xsl:if test="@link">
                  <xsl:attribute name="disabled">true</xsl:attribute>
                </xsl:if>
              </input>
            </td>
  
            <td class="fileListData" style="padding-right:5px">
              <img border="0" width="16" height="16">
                <xsl:attribute name="src"><xsl:value-of select="$contextPath"/>/icons/<xsl:value-of select="@icon" /></xsl:attribute>
              </img>
            </td>
            
            <td class="fileListData" style="padding-right:5px" width="95%">
              <xsl:if test="@link">
                <a class="link">
                  <xsl:if test="@outsideDocRoot">
                    <xsl:attribute name="href">#</xsl:attribute>
                    <xsl:attribute name="title">access forbidden</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not(@outsideDocRoot)">
                    <xsl:attribute name="href">javascript:lm<xsl:value-of select="position()" />()</xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="'--&gt; '"/>
                      <xsl:value-of select="realPath"/>
                    </xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="displayName" />
                </a>
              </xsl:if>
              <xsl:if test="not(@link)">
                <a class="fn">
                  <xsl:attribute name="href">javascript:cm<xsl:value-of select="position()" />()</xsl:attribute>
                  <xsl:if test="(displayName != @name)">
                    <xsl:attribute name="title"><xsl:value-of select="@name" /></xsl:attribute>
                  </xsl:if>                 
                  <xsl:if test="(displayName = @name) and (description)">
                    <xsl:attribute name="title"><xsl:value-of select="description" /></xsl:attribute>
                  </xsl:if>
                  <xsl:value-of select="displayName" />
                </a>
              </xsl:if>
            </td>
          
          </tr>
          
          <tr>  
          
            <td class="fileListData sepBottom">
              &#160;
            </td>

            <td class="fileListData sepBottom" colspan="2">
              <font class="fixed">
                <xsl:value-of select="@lastModified" />
              </font>
              &#160;&#160;
              <font class="fixed">
                <xsl:value-of select="@size" /> KB
              </font>
            </td>

          </tr>
      
        </xsl:for-each>

        <tr>
          <td colspan="3">
            <table border="0" style="width:100%">
              <tr>
                <td class="fileListFunct">
                  <input type="checkbox" class="cb3" name="cb-setAll" onClick="selectAll()" />
                  <xsl:value-of select="resources/msg[@key='checkbox.selectall']/@value" />
                </td>
                
                <td class="fileListFunct" align="right">
                  <select id="cmd" name="cmd" size="1" onchange="selectedFileFunction()">
                    <option value="">- <xsl:value-of select="resources/msg[@key='label.selectedFiles']/@value" /> -</option>
                    <xsl:if test="not(/folderFileList/readonly)">
                      <option value="delete"><xsl:value-of select="resources/msg[@key='button.delete']/@value" /></option>
                      <option value="copy"><xsl:value-of select="resources/msg[@key='label.copyToClip']/@value" /></option>
                      <option value="move"><xsl:value-of select="resources/msg[@key='label.cutToClip']/@value" /></option>
                      <option value="zip"><xsl:value-of select="resources/msg[@key='button.zip']/@value" /></option>
                    </xsl:if>
                    <option value="download"><xsl:value-of select="resources/msg[@key='button.downloadAsZip']/@value" /></option>
                  </select>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        
      </xsl:if> 
      
      <xsl:if test="not(/folderFileList/readonly) or (/folderFileList/readonly != 'true')">
        <tr>
          <td colspan="3" class="fileListFunct">
          
            <div class="buttonCont">
              <input type="button">
                <xsl:attribute name="value"><xsl:value-of select="resources/msg[@key='button.upload']/@value" /></xsl:attribute>
                <xsl:attribute name="onclick">window.location.href='<xsl:value-of select="$contextPath"/>/servlet?command=uploadParms';</xsl:attribute>
              </input>
            </div>

            <xsl:if test="not(/folderFileList/clipBoardEmpty)">
              <div class="buttonCont">
                <input type="button">
                  <xsl:attribute name="value"><xsl:value-of select="resources/msg[@key='button.paste']/@value" /></xsl:attribute>
                  <xsl:attribute name="onclick">window.location.href='<xsl:value-of select="$contextPath"/>/servlet?command=pasteFiles';</xsl:attribute>
                </input>
              </div>

              <xsl:if test="/folderFileList/copyOperation">
                <div class="buttonCont">
                  <input type="button">
                    <xsl:attribute name="value"><xsl:value-of select="resources/msg[@key='button.pasteLink']/@value" /></xsl:attribute>
                    <xsl:attribute name="onclick">window.location.href='<xsl:value-of select="$contextPath"/>/servlet?command=pasteLinks';</xsl:attribute>
                  </input>
                </div>
              </xsl:if>
            </xsl:if>

            <div class="buttonCont">
              <input type="button">
                <xsl:attribute name="value"><xsl:value-of select="resources/msg[@key='button.bookmark']/@value" /></xsl:attribute>
                <xsl:attribute name="onclick">bookmark('');</xsl:attribute>
                <xsl:attribute name="title"><xsl:value-of select="resources/msg[@key='title.bookmarkButton']/@value" /></xsl:attribute>
              </input>
            </div>

          </td>
        </tr>
      </xsl:if>
           

    </table>
  </form>

</xsl:template>

</xsl:stylesheet>
