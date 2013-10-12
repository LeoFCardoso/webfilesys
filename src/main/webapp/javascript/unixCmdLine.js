// <%-- Comment to prevent Eclipse Validation --%>
// <%@ page language="java" contentType="text/javascript" %>
function submitCmd()
{
    var ajaxUrl = '<%=request.getContextPath()%>/servlet';

    xmlRequestPost(ajaxUrl, getFormData(document.form1), showCmdOutput);
}

function showCmdOutput()
{
    if (req.readyState == 4)
    {
        if (req.status == 200)
        {
            var item = req.responseXML.getElementsByTagName("cmdOutput")[0];            
            var stdout = item.firstChild.nodeValue;
             
            var cmdOutDiv = document.getElementById('cmdOutput');
            cmdOutDiv.innerHTML = '<pre>' + stdout + '</pre>';
        }
    }
}