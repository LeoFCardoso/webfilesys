<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
<xsl:output method="html" indent="yes" omit-xml-declaration="yes" encoding="UTF-8" />

<xsl:strip-space elements="menubar" />

<!-- root node -->
<xsl:template match="menubar">

<html>
<head>

<meta http-equiv="expires" content="0" />

<link rel="stylesheet" type="text/css">
  <xsl:attribute name="href">/webfilesys/css/<xsl:value-of select="/menubar/css" />.css</xsl:attribute>
</link>

<script src="/webfilesys/javascript/browserCheck.js" type="text/javascript"></script>
<script src="/webfilesys/javascript/ajaxCommon.js" type="text/javascript"></script>
<script src="/webfilesys/javascript/resourceBundle.js" type="text/javascript"></script>
<script type="text/javascript">
  <xsl:attribute name="src">/webfilesys/servlet?command=getResourceBundle&amp;lang=<xsl:value-of select="/menubar/language" /></xsl:attribute>
</script>


<script language="javascript">
  function fastpath() 
  {
      parent.DirectoryPath.location.href = '/webfilesys/servlet?command=fastpath';
  }

  function bookmarks() 
  {
      parent.DirectoryPath.location.href = '/webfilesys/servlet?command=bookmarks';
  }
  
  function publishList()
  {
      window.open('/webfilesys/servlet?command=publishList&amp;random=' + new Date().getTime(),'PublishList','scrollbars=yes,resizable=yes,width=740,height=300,left=20,top=100,screenX=50,screenY=100');
  }
  
  function diskQuota() 
  {
      window.open('/webfilesys/servlet?command=diskQuota&amp;random=' + new Date().getTime(),'quotaWin','scrollbars=no,resizable=no,width=400,height=230,left=100,top=100,screenX=100,screenY=100');
  }

  function pictureStory()
  {
      thumbwin=open('/webfilesys/servlet?command=pictureStory&amp;random=' + new Date().getTime() + '&amp;screenWidth=' + screen.width + '&amp;screenHeight=' + screen.height,'thumbwin','status=no,toolbar=no,menu=no,width=' + (screen.width-20) + ',height=' + (screen.height-80) + ',resizable=yes,scrollbars=yes,left=5,top=1,screenX=5,screenY=1');
  }
 
  function slideshow()
  {
      parent.frames[2].location.href = '/webfilesys/servlet?command=slideShowParms&amp;cmd=getParms&amp;screenWidth=' + screen.width + '&amp;screenHeight=' + screen.height;
  }
  
  function ftpBackup()
  {
      ftpwin=open('/webfilesys/servlet?command=ftpBackup','ftpwin','status=no,toolbar=no,menu=no,width=520,height=300,resizable=no,scrollbars=yes,left=150,top=60,screenX=150,screenY=60');ftpwin.focus();
  }

  function searchParms()
  {
      searchWin=open('/webfilesys/servlet?command=search','searchWin','scrollbars=yes,resizable=yes,width=500,height=480,left=100,top=60,screenX=100,screenY=60');
      searchWin.focus();
  }

  function openCalendar()
  {
      var windowWidth = screen.availWidth - 10;
      var windowHeight = screen.availHeight - 20;
    
      if (browserChrome) 
      {
          windowHeight = windowHeight - 40;
      }
    
      if (windowHeight > windowWidth - 200)
      {
          windowHeight = windowWidth - 200;
      }
      else if (windowWidth > windowHeight + 250)
      {
          windowWidth = windowHeight + 250;
      }
  
      calWin = window.open('/webfilesys/servlet?command=calendar','calWin','scrollbars=yes,resizable=yes,width=' + windowWidth + ',height=' + windowHeight);
      calWin.focus();
  }
  
  function fileSysStats()
  {
      statWin = window.open('/webfilesys/servlet?command=fileSysUsage','statWin','scrollbars=yes,resizable=yes,width=700,height=480,left=20,top=20,screenX=20,screenY=20');
      statWin.focus();
  }
  
  function mobileVersion()
  {
      parent.location.href = '/webfilesys/servlet?command=mobile&amp;cmd=folderFileList&amp;initial=true&amp;relPath=/';
  }
  
  function returnToPrevDir()
  {
      parent.location.href = '/webfilesys/servlet?command=returnToPrevDir';
  }
  
  <xsl:if test="/menubar/unixAdmin">
    function unixCmdWin()
    {
        var unixCmdWin = window.open('/webfilesys/servlet?command=unixCmdLine','cmdPrompt','status=no,toolbar=no,menu=no,width=600,height=600,resizable=yes,scrollbars=yes,left=10,top=10,screenX=10,screenY=10');
        unixCmdWin.focus();
    }
  </xsl:if>
  
  <xsl:if test="/menubar/queryDrives">
    function refreshDriveList()
    {
        ajaxRPC("refreshDriveList", "");
        parent.location.href = '/webfilesys/servlet';    
    }
  </xsl:if>
  
  function setScreenSize()
  {
      var url = '/webfilesys/servlet?command=setScreenSize&amp;screenWidth=' + screen.width + '&amp;screenHeight=' + screen.height;
      xmlRequest(url, dummyCallback);
  }
  
  function dummyCallback()
  {
  }
</script>

</head>

<body class="menubar" onload="setBundleResources();setScreenSize()">

  <table border="0" width="100%" cellpadding="0" cellspacing="0">
    <tr>
      <td>

        <table border="0" cellpadding="0" cellspacing="0">
          <tr>
            <th>
              <a href="javascript:fastpath()">
                <img src="/webfilesys/images/menubar/fastpath.gif" border="0" width="32" height="32">
                  <xsl:attribute name="titleResource">label.fastpath</xsl:attribute>
                </img>
              </a>
            </th>

            <th>
              <a href="javascript:bookmarks()">
                <img src="/webfilesys/images/menubar/bookmarks.gif" border="0" width="32" height="32">
                  <xsl:attribute name="titleResource">label.bookmarks</xsl:attribute>
                </img>
              </a>
            </th>
            
            <th>
              <a href="javascript:returnToPrevDir()">
                <img src="/webfilesys/images/menubar/returnDir.gif" border="0" width="32" height="32">
                  <xsl:attribute name="titleResource">label.returnToPrevDir</xsl:attribute>
                </img>
              </a>
            </th>

            <xsl:if test="/menubar/unixAdmin">
              <th>
                <a href="/webfilesys/servlet?command=processList" target="_blank">
                  <img src="/webfilesys/images/menubar/process.gif" border="0" width="32" height="32">
                    <xsl:attribute name="titleResource">label.processes</xsl:attribute>
                  </img>
                </a>
              </th>
              
              <th>
                <a href="javascript:fileSysStats()">
                  <img src="/webfilesys/images/menubar/bargraph.gif" border="0" width="32" height="32">
                    <xsl:attribute name="titleResource">label.fsstat</xsl:attribute>
                  </img>
                </a>
              </th>

              <th>
                <a href="#" onclick="unixCmdWin()">
                  <img src="/webfilesys/images/menubar/cmdline.gif" border="0" width="32" height="32">
                    <xsl:attribute name="titleResource">label.oscmd</xsl:attribute>
                  </img>
                </a>
              </th>
            </xsl:if>

            <xsl:if test="/menubar/role='admin'">
              <th>
                <a href="/webfilesys/servlet?command=admin&amp;cmd=menu" target="_parent">
                  <img src="/webfilesys/images/menubar/admin.gif" border="0" width="32" height="32">
                    <xsl:attribute name="titleResource">label.admin</xsl:attribute>
                  </img>
                </a>
              </th>
            </xsl:if>

            <xsl:if test="not(role='admin')">
              <xsl:if test="not(readonly) or (readonly='false')">
                <xsl:if test="registrationType='open'">
                  <th>
                    <a href="/webfilesys/servlet?command=selfEditUser" target="FileList">
                      <img src="/webfilesys/images/menubar/user.gif" border="0" width="32" height="32">
                        <xsl:attribute name="titleResource">label.editregistration</xsl:attribute>
                      </img>
                    </a>
                  </th>
                </xsl:if>

                <xsl:if test="not(registrationType='open')">
                  <th>
                    <a href="/webfilesys/servlet?command=editPw" target="FileList">
                      <img src="/webfilesys/images/menubar/key.gif" border="0" width="32" height="32">
                        <xsl:attribute name="titleResource">label.settings</xsl:attribute>
                      </img>
                    </a>
                  </th>
                </xsl:if>
              </xsl:if>
            </xsl:if>

            <xsl:if test="not(readonly) or (readonly='false')">
              <th>
                <a href="javascript:publishList()">
                  <img src="/webfilesys/images/menubar/published.gif" border="0" width="32" height="32">
                    <xsl:attribute name="titleResource">label.publishList</xsl:attribute>
                  </img>
                </a>
              </th>
            </xsl:if>
            
            <xsl:if test="not(role='admin')">
              <xsl:if test="not(readonly) or (readonly='false')">
                <xsl:if test="diskQuota='true'">
                  <th>
                    <a href="javascript:diskQuota()">
                      <img src="/webfilesys/images/menubar/diskQuota.gif" border="0" width="32" height="32">
                        <xsl:attribute name="titleResource">label.diskQuotaUsage</xsl:attribute>
                      </img>
                    </a>
                  </th>
                </xsl:if>
              </xsl:if>
            </xsl:if>

            <xsl:if test="/menubar/queryDrives">
              <th>
                <a href="javascript:refreshDriveList()">
                  <img src="/webfilesys/images/menubar/drive.gif" border="0" width="32" height="32">
                    <xsl:attribute name="titleResource">label.refreshDrives</xsl:attribute>
                  </img>
                </a>
              </th>
            </xsl:if>

          </tr>
        </table>
 
      </td>
      
      <td class="plaintext" align="center">
      
      	<!-- Leonardo - hide hostname for security <xsl:value-of select="hostname" /> -->
        <xsl:value-of select="userid" /> @ WEBFILESYS

        <xsl:if test="readonly and (readonly='true')"> (read-only)</xsl:if>

        <xsl:if test="maintananceMode"> (maintanance mode)</xsl:if>
      </td>

      <td align="right">
        <table border="0" cellpadding="0" cellspacing="0">
          <tr>

            <xsl:if test="not(readonly) or (readonly='false')">
	            <th>
	              <a href="javascript:searchParms()">
	                <img src="/webfilesys/images/menubar/search.gif" border="0" width="32" height="32">
	                  <xsl:attribute name="titleResource">label.search</xsl:attribute>
	                </img>
	              </a>
	            </th>

	            <th>
	              <a href="javascript:slideshow()">
	                <img src="/webfilesys/images/menubar/slideshow.gif" border="0" width="32" height="32">
	                  <xsl:attribute name="titleResource">label.slideshow</xsl:attribute>
	                </img>
	              </a>
	            </th>

	            <th>
	              <a href="javascript:javascript:pictureStory()">
	                <img src="/webfilesys/images/menubar/film.gif" border="0" width="32" height="32">
	                  <xsl:attribute name="titleResource">label.story</xsl:attribute>
	                </img>
	              </a>
	            </th>
            </xsl:if>


            <xsl:if test="not(readonly) or (readonly='false')">
              <th>
                <a href="javascript:ftpBackup()">
                  <img src="/webfilesys/images/menubar/ftp.gif" border="0" width="32" height="32">
                    <xsl:attribute name="titleResource">label.ftpBackup</xsl:attribute>
                  </img>
                </a>
              </th>
            </xsl:if>

            <xsl:if test="calendarEnabled">
              <th>
                <a href="javascript:openCalendar()">
                  <img src="/webfilesys/images/menubar/calendar.gif" border="0" width="32" height="32">
                    <xsl:attribute name="titleResource">label.calendar</xsl:attribute>
                  </img>
                </a>
              </th>
            </xsl:if>

            <xsl:if test="not(readonly) or (readonly='false')">
	            <th>
	              <a href="javascript:mobileVersion()">
	                <img src="/webfilesys/images/menubar/mobilePhone.gif" border="0" width="32" height="32">
	                  <xsl:attribute name="titleResource">label.mobileVersion</xsl:attribute>
	                </img>
	              </a>
	            </th>
            </xsl:if>

            <th>
              <a target="_blank">
                <xsl:attribute name="href">/webfilesys/help/<xsl:value-of select="helpLanguage" />/help.html</xsl:attribute>
                <img src="/webfilesys/images/menubar/help.gif" border="0" width="32" height="32">
                  <xsl:attribute name="titleResource">label.help</xsl:attribute>
                </img>
              </a>
            </th>

            <th>
              <a href="#" onclick="window.open('/webfilesys/servlet?command=versionInfo','infowindow','status=no,toolbar=no,location=no,menu=no,width=300,height=220,resizable=no,left=250,top=150,screenX=250,screenY=150')">
                <img src="/webfilesys/images/menubar/info.gif" border="0" width="32" height="32">
                  <xsl:attribute name="titleResource">label.about</xsl:attribute>
                </img>
              </a>
            </th>
            
            <th>&#160;&#160;&#160;&#160;</th>

            <th>
              <a class="active" href="/webfilesys/servlet?command=logout" target="_parent">
                <img src="/webfilesys/images/menubar/exit.gif" border="0" width="32" height="32">
                  <xsl:attribute name="titleResource">label.logout</xsl:attribute>
                </img>
              </a>
            </th>

          </tr>
        </table>
      
      </td>
    </tr>
  </table>
  
</body>
</html>

</xsl:template>

</xsl:stylesheet>
