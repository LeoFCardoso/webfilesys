// <%-- Comment to prevent Eclipse Validation --%>
// <%@ page language="java" contentType="text/javascript" %>
    function albumImg(imgName)
    {
        if (browserMSIE)
        {
            windowWidth = document.body.clientWidth;
            windowHeight = document.body.clientHeight;
        }
        else
        {
            windowWidth = window.innerWidth;
            windowHeight = window.innerHeight;
        }    
    
        window.location.href = '<%=request.getContextPath()%>/servlet?command=albumImg&imgName=' + encodeURIComponent(imgName) + '&windowWidth=' + windowWidth + '&windowHeight=' + windowHeight;
    }

    function albumLinkedImg(realPath)
    {
        if (browserMSIE)
        {
            windowWidth = document.body.clientWidth;
            windowHeight = document.body.clientHeight;
        }
        else
        {
            windowWidth = window.innerWidth;
            windowHeight = window.innerHeight;
        }    
    
        window.location.href = '<%=request.getContextPath()%>/servlet?command=albumImg&realPath=' + encodeURIComponent(realPath) + '&windowWidth=' + windowWidth + '&windowHeight=' + windowHeight;
    }
