// Comment to prevent Eclipse Validation
// <%@ page language="java" contentType="text/javascript" %>
function mkdir(path)
{  
    path = path.replace('`','\'');

    showPrompt('<%=request.getContextPath()%>/servlet?command=mkdirPrompt&path=' + encodeURIComponent(path), '<%=request.getContextPath()%>/xsl/createFolder.xsl', 320, 190);

    document.mkdirForm.NewDirName.focus();
    
    document.mkdirForm.NewDirName.select();
}

function copyDir(path)
{
    copyDirToClip(path);
}

function deleteDir(path, domId)
{
    showPrompt('<%=request.getContextPath()%>/servlet?command=ajaxRPC&method=deleteDirPrompt&param1=' + encodeURIComponent(path), '<%=request.getContextPath()%>/xsl/confirmDeleteDir.xsl', 320, 110);
}

function renameDir(path)
{
    showPrompt('<%=request.getContextPath()%>/servlet?command=renDirPrompt&path=' + encodeURIComponent(path), '<%=request.getContextPath()%>/xsl/renameDir.xsl', 320, 190);

    document.mkdirForm.NewDirName.focus();
    
    document.mkdirForm.NewDirName.select();
}

function zip(path)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=zipDir&actPath=" + encodeURIComponent(path);
}

function paste(path)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=pasteFiles&actpath=" + encodeURIComponent(path) + "&random=" + (new Date().getTime());
}

function statistics(path)
{
    var statWin=open("<%=request.getContextPath()%>/servlet?command=fileStatistics&cmd=treeStats&actpath=" + encodeURIComponent(path) + "&random=" + (new Date()).getTime(),"Statistics","scrollbars=yes,resizable=yes,width=600,height=590");
    statWin.focus();
}

function statSunburst(path)
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
    var statWin = open("<%=request.getContextPath()%>/servlet?command=folderTreeStats&path=" + encodeURIComponent(path) + "&random=" + (new Date()).getTime(),"Statistics","scrollbars=yes,resizable=yes,width=" + windowWidth + ",height=" + windowHeight);
    statWin.focus();
}

function fileSizeStatistics(path)
{
    var statWin;
    
    if (browserSafari || browserOpera) 
    {
        statWin=open("<%=request.getContextPath()%>/servlet?command=fileStatistics&cmd=sizeStats&actpath=" + encodeURIComponent(path) + "&random=" + (new Date()).getTime(),"Statistics","scrollbars=yes,resizable=yes,width=700,height=500");
    }
    else 
    {
        statWin=open("<%=request.getContextPath()%>/html/waitFileSizeStats.jsp?command=fileStatistics&cmd=sizeStats&actpath=" + encodeURIComponent(path) + "&random=" + (new Date()).getTime(),"Statistics","scrollbars=yes,resizable=yes,width=700,height=500");
    }
    statWin.focus();
}

function fileTypeStatistics(path)
{
    var statWin;
    
    if (browserSafari || browserOpera) 
    {
        statWin=open("<%=request.getContextPath()%>/servlet?command=fileStatistics&cmd=typeStats&actpath=" + encodeURIComponent(path) + "&random=" + (new Date()).getTime(),"Statistics","scrollbars=yes,resizable=yes,width=700,height=500");
    }
    else 
    {
        statWin=open("<%=request.getContextPath()%>/html/waitFileTypeStats.jsp?command=fileStatistics&cmd=typeStats&actpath=" + encodeURIComponent(path) + "&random=" + (new Date()).getTime(),"Statistics","scrollbars=yes,resizable=yes,width=700,height=500");
    }

    statWin.focus();
}

function fileAgeStatistics(path)
{
    var statWin;
    
    if (browserSafari || browserOpera) 
    {
        statWin=open("<%=request.getContextPath()%>/servlet?command=fileStatistics&cmd=ageStats&actpath=" + encodeURIComponent(path) + "&random=" + (new Date()).getTime(),"Statistics","scrollbars=yes,resizable=yes,width=700,height=500");
    }
    else 
    {
        statWin=open("<%=request.getContextPath()%>/html/waitFileAgeStats.jsp?command=fileStatistics&cmd=ageStats&actpath=" + encodeURIComponent(path) + "&random=" + (new Date()).getTime(),"Statistics","scrollbars=yes,resizable=yes,width=700,height=500");
    }
    statWin.focus();
}

function search(path)
{
    searchWin=open("<%=request.getContextPath()%>/servlet?command=search&actpath=" + encodeURIComponent(path),"Search","scrollbars=yes,resizable=yes,width=500,height=500,left=80,top=10,screenX=80,screenY=10");
    searchWin.focus();
    searchWin.opener=self;
}

function mkfile(path)
{
    showPrompt('<%=request.getContextPath()%>/servlet?command=mkfilePrompt&path=' + encodeURIComponent(path), '<%=request.getContextPath()%>/xsl/createFile.xsl', 320, 190);
    
    document.mkfileForm.NewFileName.focus();
    
    document.mkfileForm.NewFileName.select();
}

function upload(path)
{
    window.parent.frames[2].location.href = "<%=request.getContextPath()%>/servlet?command=uploadParms&actpath=" + encodeURIComponent(path);
}

function publish(path,mailEnabled)
{
    if (parent.mailEnabled == 'true')
    {
         publishWin=window.open("<%=request.getContextPath()%>/servlet?command=publishForm&actPath=" + encodeURIComponent(path) + "&type=common","publish","status=no,toolbar=no,menu=no,width=620,height=550,resizable=yes,scrollbars=no,left=30,top=20,screenX=40,screenY=20");
    }
    else
    {
         publishWin=window.open("<%=request.getContextPath()%>/servlet?command=publishParms&actPath=" + encodeURIComponent(path) + "&type=common","publish","status=no,toolbar=no,menu=no,width=620,height=290,resizable=yes,scrollbars=no,left=30,top=80,screenX=40,screenY=80");
    }

    publishWin.focus();
}

function description(path)
{
    descWin=window.open("<%=request.getContextPath()%>/servlet?command=editMetaInf&path=" + encodeURIComponent(path) + "&geoTag=true&random=" + new Date().getTime(),"descWin","status=no,toolbar=no,location=no,menu=no,width=600,height=450,scrollbars=yes,resizable=yes,left=20,top=20,screenX=20,screenY=20");
    descWin.focus();
    // descWin.opener=parent.FileList;
}

function driveInfo(path)
{
    propWin=window.open("<%=request.getContextPath()%>/servlet?command=driveInfo&path=" + encodeURIComponent(path) + "&random=" + (new Date().getTime()),"propWin","status=no,toolbar=no,location=no,menu=no,width=400,height=200,resizable=yes,left=100,top=200,screenX=100,screenY=200");
    propWin.focus();
}

function refresh(path)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=refresh&path=" + encodeURIComponent(path);
}

function rights(path)
{
    window.location.href="<%=request.getContextPath()%>/servlet?command=unixRights&actpath=" + encodeURIComponent(path) + "&isDirectory=true&random=" + (new Date()).getTime();
}

function watchFolder(path)
{   
    showPrompt('<%=request.getContextPath()%>/servlet?command=watchFolder&path=' + encodeURIComponent(path), '<%=request.getContextPath()%>/xsl/watchFolder.xsl', 360);
}
