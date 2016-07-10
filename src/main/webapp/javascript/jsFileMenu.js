// <%-- Comment to prevent Eclipse Validation --%>
// <%@ page language="java" contentType="text/javascript" %>
function description(path)
{
    var windowWidth = 600;
    var windowHeight = 300;
    
    var xpos = (screen.width - windowWidth) / 2;
    var ypos = (screen.height - windowHeight) / 2;

    descWin=window.open("<%=request.getContextPath()%>/servlet?command=editMetaInf&path=" + encodeURIComponent(path) + "&random=" + new Date().getTime(),"descWin","status=no,toolbar=no,location=no,menu=no,width=" + windowWidth + ",height=" + windowHeight + ",resizable=yes,left=" + xpos + ",top=" + ypos + ",screenX=" + xpos + ",screenY=" + ypos);
    descWin.focus();
    descWin.opener=self;
}

function comments(path)
{ 
    var windowWidth = 550;
    var windowHeight = 500;
    if (windowHeight > screen.height - 120)
    {
        windowHeight = screen.height - 120;
    }
    
    var xpos = (screen.width - windowWidth) / 2;
    var ypos = (screen.height - windowHeight) / 2;

    commentWin = window.open("<%=request.getContextPath()%>/servlet?command=listComments&actPath=" + encodeURIComponent(path),"commentWin","status=no,toolbar=no,location=no,menu=no,scrollbars=yes,width=" + windowWidth + ",height=" + windowHeight + ",resizable=yes,left=" + xpos + ",top=" + ypos + ",screenX" + xpos + ",screenY=" + ypos);
    commentWin.focus();
}

function viewZip(path)
{
    unzipWin=window.open("<%=request.getContextPath()%>/servlet?command=viewZip&filePath=" + encodeURIComponent(path),"unzipWin","status=no,toolbar=no,menu=yes,width=500,height=580,resizable=yes,scrollbars=yes,left=100,top=40,screenX=100,screenY=40");
    unzipWin.focus();
}

function hexView(fileName)
{
    var hexWin = window.open("<%=request.getContextPath()%>/servlet?command=hexView&fileName=" + encodeURIComponent(fileName), "hexWin","status=no,toolbar=no,menu=yes,width=780,height=600,resizable=yes,scrollbars=yes,left=10,top=10,screenX=20,screenY=20");
    hexWin.focus();
}

function zip(path)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=zipFile&filePath=" + encodeURIComponent(path);
}

function editMP3(path)
{
    mp3Win=window.open("<%=request.getContextPath()%>/servlet?command=editMP3&path=" + encodeURIComponent(path) + "&random=" + new Date().getTime(),"mp3Win","status=no,toolbar=no,location=no,menu=no,scrollbars=yes,width=500,height=380,resizable=yes,left=150,top=100,screenX=150,screenY=100");
    mp3Win.focus();
}

function renameFile(fileName)
{   
    showPrompt('<%=request.getContextPath()%>/servlet?command=renameFilePrompt&fileName=' + encodeURIComponent(fileName), '<%=request.getContextPath()%>/xsl/renameFile.xsl', 360);
    
    document.renameForm.newFileName.focus();
    
    document.renameForm.newFileName.select();
}

function cloneFile(fileName)
{   
    showPrompt('<%=request.getContextPath()%>/servlet?command=cloneFilePrompt&fileName=' + encodeURIComponent(fileName), '<%=request.getContextPath()%>/xsl/cloneFile.xsl', 360);
    
    document.renameForm.newFileName.focus();
    
    document.renameForm.newFileName.select();
}

function copyToClipboard(fileName)
{
    cutCopyToClip(fileName, 'copy');
}

function cutToClipboard(fileName)
{
    cutCopyToClip(fileName, 'cut');
}

function editRemote(fileName)
{
    var editWinWidth = screen.width - 80;
    var editWinHeight = screen.height - 70;

    if (editWinWidth > 800) 
    {
        editWinWidth = 800;
    }

    if (editWinHeight > 700) 
    {
        editWinHeight = 700;
    }
    
    editWin=window.open("<%=request.getContextPath()%>/servlet?command=editFile&filename=" + encodeURIComponent(fileName) + "&screenHeight=" + editWinHeight,"editWin","status=no,toolbar=no,location=no,menu=no,width=" + editWinWidth + ",height=" + editWinHeight + ",resizable=yes,left=20,top=5,screenX=20,screenY=5");
    editWin.focus();
    editWin.opener=self;
}

function viewFile(path)
{
    // window.open('<%=request.getContextPath()%>/servlet?command=getFile&filePath=' + encodeURIComponent(path),"_blank","status=yes,toolbar=yes,menubar=yes,location=yes,resizable=yes,scrollbars=yes");
   
    var viewPath = "";
    
    if (path.charAt(0) == '/')
    {
       viewPath = '<%=request.getContextPath()%>/servlet' + encodeURI(path);
    }
    else
    {
       viewPath = '<%=request.getContextPath()%>/servlet/' + URLEncode(path);
    }
    
    window.open(viewPath,"_blank","status=yes,toolbar=yes,menubar=yes,location=yes,resizable=yes,scrollbars=yes");
}

function tail(path)
{
    window.open('<%=request.getContextPath()%>/servlet?command=tail&filePath=' + encodeURIComponent(path) + "&initial=true","_blank","status=yes,toolbar=yes,menubar=yes,location=yes,resizable=yes,scrollbars=yes");
}

function grep(path, fileName)
{
    var checkResult = ajaxRPC("grepAllowed", encodeURIComponent(path));
    if (checkResult == 'true') 
    {
        showPrompt('<%=request.getContextPath()%>/servlet?command=ajaxRPC&method=grepParams&param1=' + encodeURIComponent(fileName), '<%=request.getContextPath()%>/xsl/grepParams.xsl', 320, 130);
    }
    else 
    {
        alert(checkResult);
    }
}

function delFile(fileName)
{
    showPrompt('<%=request.getContextPath()%>/servlet?command=ajaxRPC&method=deleteFilePrompt&param1=' + encodeURIComponent(fileName), '<%=request.getContextPath()%>/xsl/confirmDeleteFile.xsl', 320, 130);
}

/* not used anymore ? */
function deleteFile(fileName)
{
    window.location.href = "<%=request.getContextPath()%>/servlet?command=fmdelete&fileName=" + fileName + "&deleteRO=yes";
}

function accessRights(path)
{
    rightWin = window.open("<%=request.getContextPath()%>/servlet?command=unixRights&actpath=" + encodeURIComponent(path) + "&isDirectory=false&random=" + (new Date()).getTime(),"rightWin","status=no,toolbar=no,menu=no,resizable=yes,scrollbars=yes,height=530,width=350,left=200,top=40,screenX=200,screenY=40");
    rightWin.focus();
}

function gunzip(path)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=gunzip&filename=" + encodeURIComponent(path);
}

function compress(path)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=unixCompress&actPath=" + encodeURIComponent(path);
}

function untar(path)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=untar&filePath=" + encodeURIComponent(path);
}

function sendFile(fileName)
{
    showPrompt('<%=request.getContextPath()%>/servlet?command=emailFilePrompt&fileName=' + encodeURIComponent(fileName), '<%=request.getContextPath()%>/xsl/emailFile.xsl', 400, 250);
    
    document.emailForm.receiver.focus();
    
    document.emailForm.receiver.select();
}

function delLink(linkName)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=deleteLink&linkName=" + encodeURIComponent(linkName);
}

function switchReadWrite(path)
{   
    showPrompt('<%=request.getContextPath()%>/servlet?command=switchReadWrite&filePath=' + encodeURIComponent(path), '<%=request.getContextPath()%>/xsl/switchReadWrite.xsl', 360);
}

function associatedProg(path)
{
    var url = '<%=request.getContextPath()%>/servlet?command=runAssociatedProgram&filePath=' + encodeURIComponent(path);

    xmlRequest(url, startProgramResult);
}

function encrypt(fileName)
{   
    showPrompt('<%=request.getContextPath()%>/servlet?command=cryptoKeyPrompt&fileName=' + encodeURIComponent(fileName), '<%=request.getContextPath()%>/xsl/encrypt.xsl', 360);
    
    document.cryptoForm.cryptoKey.focus();
    
    document.cryptoForm.cryptoKey.select();
}

function decrypt(fileName)
{   
    showPrompt('<%=request.getContextPath()%>/servlet?command=cryptoKeyPrompt&fileName=' + encodeURIComponent(fileName), '<%=request.getContextPath()%>/xsl/decrypt.xsl', 360);
    
    document.cryptoForm.cryptoKey.focus();
    
    document.cryptoForm.cryptoKey.select();
}

function startProgramResult() {
    if (req.readyState == 4)
    {
        if (req.status == 200)
        {
             var item = req.responseXML.getElementsByTagName("success")[0];            
             var success = item.firstChild.nodeValue;

             if (success != 'true') {
                 var msgItem = req.responseXML.getElementsByTagName("message")[0];            
                 var message = msgItem.firstChild.nodeValue;
                 alert(message);
             }             
        }
    }
}

//function URLEncode(path)
//{
//    var encodedPath = '';
//
//    for (i = 0; i < path.length; i++)
//    {
//        c = path.charAt(i);
//    
//        if (c == '\\')
//        {
//            encodedPath = encodedPath + '/';
//        }
//        else
//        {
//            encodedPath = encodedPath + c;
//        }
//    }
//    return(encodeURI(encodedPath)); 
//}

function URLEncode(path)
{
    var encodedPath = '';

    for (i = 0; i < path.length; i++)
    {
        c = path.charAt(i);
    
        if (c == '/')
        {
            encodedPath = encodedPath + c;
        }
        else if (c == '\\')
        {
            encodedPath = encodedPath + '/';
        }
        else
        {
            encodedPath = encodedPath + encodeURIComponent(c);
        }
    }
    return(encodedPath); 
}
