function hideMenu()
{
    document.getElementById('contextMenu').style.visibility = 'hidden';
}

function menuEntry(href, label, target)
{
    targetText = "";

    if (target != null)
    {
        targetText = 'target="' + target + '"'; 
    }

    return('<tr>'
             + '<td class="jsmenu">'
             + '<a class="menuitem" href="' + href + '" ' + targetText + '>' + label + '</a>'
             + '</td>'
             + '</tr>');
}

function linkGraphicsMenu(linkName, realPath, imgType)
{
    menuDiv = document.getElementById('contextMenu');    
        
    shortFileName = linkName;
    
    if (linkName.length > 24)
    {
        shortFileName = linkName.substring(0,7) + "..." + linkName.substring(linkName.length - 14, linkName.length);
    }    

    fileNameExt = getFileNameExt(linkName);

    scriptPreparedPath = insertDoubleBackslash(realPath);

    menuText = '<table border="0" width="180" cellpadding="0" cellspacing="0" height="100%">'
             + '<tr>'
             + '<th class="datahead" style="padding-left:5px;padding-right:5px;padding-top:4px;padding-bottom:4px;text-align:left;border-bottom-width:1px;border-bottom-style:solid;border-bottom-color:black;">'
             + shortFileName
             + '</th>'
             + '</tr>';

    if (parent.readonly != 'true')
    {
        menuText = menuText 
                 + menuEntry("javascript:jsDelImageLink('" + linkName + "')",resourceBundle["label.deleteLink"],null);

        menuText = menuText 
                 + menuEntry("javascript:renameLink('" + linkName + "')",resourceBundle["label.renameLink"],null);

        menuText = menuText 
                 + menuEntry("javascript:jsDescription('" + scriptPreparedPath + "')",resourceBundle["label.editMetaInfo"],null);
    }
    
    if (imgType == '1') // JPEG
    {
        menuText = menuText 
                 + menuEntry("javascript:jsExifData('" + scriptPreparedPath + "')",resourceBundle["alt.cameradata"],null);
    }
    
    /*
    if ((parent.readonly != 'true') && 
        ((imgType == '1') ||   // JPEG
         (imgType == '3')))     // PNG
    {
        menuText = menuText 
                 + menuEntry("javascript:jsMakeThumb('" + scriptPreparedPath + "')",resourceBundle["label.makethumb"],null);
    }
    */

    menuText = menuText 
             + menuEntry("javascript:jsComments('" + scriptPreparedPath + "')",resourceBundle["label.comments"],null);

    if ((parent.readonly != 'true') && 
        (parent.mailEnabled == 'true'))
    {
        menuText = menuText 
                 + menuEntry("javascript:emailLink('" + scriptPreparedPath + "')",resourceBundle["label.sendfile"],null);
    }

    if (parent.serverOS == 'win')
    {
        realDir = realPath.substring(0,realPath.lastIndexOf('\\'));
        
        if (realDir.length < 3)
        {
            realDir = realDir + "\\";
        }
    }
    else
    {
        realDir = realPath.substring(0,realPath.lastIndexOf('/'));
        
        if (realDir.length == 0)
        {
            realDir = "/";
        }
        
    }

    menuText = menuText 
             + menuEntry("javascript:origDir('" + insertDoubleBackslash(realDir) + "')",resourceBundle["label.origDir"],null);

    menuText = menuText + '</table>'; 

    menuDiv.innerHTML = menuText;

    menuDiv.style.bgcolor = '#c0c0c0';
    
    if (parent.readonly == 'true')
    {
        maxMenuHeight = 140;
    }
    else
    {
        maxMenuHeight = 220;
    }
    
    if (browserType == 'msie')
    {
        windowWidth = document.body.clientWidth;
        windowHeight = document.body.clientHeight;
        yScrolled = document.body.scrollTop;

        if (clickXPos > windowWidth - 200)
        {
            clickXPos = windowWidth - 200;
        }

        if (clickYPos > windowHeight - maxMenuHeight)
        {
            clickYPos = windowHeight - maxMenuHeight;
        }

        clickYPos = clickYPos + yScrolled;
    }
    else
    {
        windowWidth = window.innerWidth;
        windowHeight = window.innerHeight;
        yScrolled = window.pageYOffset;
        xScrolled = window.pageXOffset;
        
        if (clickYPos > yScrolled + windowHeight - maxMenuHeight)
        {
            clickYPos = yScrolled + windowHeight - maxMenuHeight;
        }

        if (clickXPos > xScrolled + windowWidth - 200)
        {
            clickXPos = xScrolled + windowWidth - 200;
        }
    }
    
    menuDiv.style.left = clickXPos + "px";
    menuDiv.style.top = clickYPos + "px";

    menuDiv.style.visibility = 'visible';
}

function jsDelImageLink(linkName)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=delImageLink&linkName=" + encodeURIComponent(linkName);
}

function jsDescription(path)
{
    descWin=window.open("<%=request.getContextPath()%>/servlet?command=editMetaInf&path=" + encodeURIComponent(path) + "&random=" + new Date().getTime(),"descWin","status=no,toolbar=no,location=no,menu=no,width=600,height=300,resizable=yes,left=20,top=100,screenX=20,screenY=100");
    descWin.focus();
    descWin.opener=self;
}

function origDir(path)
{
    parent.parent.frames[1].location.href="<%=request.getContextPath()%>/servlet?command=exp&expandPath=" + encodeURIComponent(path) + "&fastPath=true";
}

function emailLink(filePath)
{
    showPrompt('<%=request.getContextPath()%>/servlet?command=emailFilePrompt&filePath=' + encodeURIComponent(filePath), '<%=request.getContextPath()%>/xsl/emailFile.xsl', 400, 250);
    
    document.emailForm.receiver.focus();
    
    document.emailForm.receiver.select();
}


