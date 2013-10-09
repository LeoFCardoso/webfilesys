<%@page import="de.webfilesys.servlet.JAASSecurityFilter"%>
<%@page import="de.webfilesys.WebFileSys"%>
<%@page import="de.webfilesys.LanguageManager"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Login</title>
<style>
#wraper {
	width: 250px;
	height: 250px;
	padding: 20px;
	box-shadow: 2px 2px 10px 10px #ccc;
	-webkit-box-shadow: 2px 2px 10px 10x #ccc;
	-moz-box-shadow: 2px 2px 10px 10px #ccc;
	font-family: Calibri, Arial, Helvetica;
	font-size: 16px;
	text-shadow: 1px 1px #cccccc;
	border-radius: 3px;
	-moz-border-radius: 3px;
	-ms-border-radius: 3px -o-border-radius:3px;
	-webkit-border-radius: 3px;
	top: 50%;
	left: 50%;
	margin-left: -145px;
	margin-top: -145px;
	position: fixed;
}

#wraper input {
	font-family: Calibri, Arial, Helvetica;
}

#wraper h1 {
	font-weight: normal;
	font-size: 24px;
}

#wraper label {
	width: 100%;
	float: left;
	margin-bottom: 5px;
}

#wraper input[type=text],#wraper input[type=password] {
	width: 240px;
	height: 20px;
	float: left;
	padding: 4px;
	border: 1px solid #d5d5d5;
	outline: none;
	margin-bottom: 15px;
	box-shadow: 5px 5px 2px #f1f1f1;
	-webkit-box-shadow: 5px 5px 2px #f1f1f1;
	-moz-box-shadow: 5px 5px 2px #f1f1f1;
	clear: both;
}

#wraper input[type=submit] {
	padding: 6px 10px;
	outline: none;
	border: none;
	margin-bottom: 15px;
	cursor: pointer;
	color: #fff;
	background-image: linear-gradient(bottom, #0047CC, #0085CC);
	background-image: -o-linear-gradient(bottom, #0047CC, #0085CC);
	background-image: -moz-linear-gradient(bottom, #0047CC, #0085CC);
	background-image: -webkit-linear-gradient(bottom, #0047CC, #0085CC);
	background-image: -ms-linear-gradient(bottom, #0047CC, #0085CC);
	border-radius: 3px;
	-moz-border-radius: 3px;
	-ms-border-radius: 3px -o-border-radius:3px;
	-webkit-border-radius: 3px;
	text-shadow: 1px 1px #0047CC;
	font-size: 16px;
}
</style>
</head>

<body>
	<div id="wraper">
		<h1>
			<%
				out.print(WebFileSys.getInstance().getJAASAppName());
			%>
			Login
		</h1>
		<label><%=LanguageManager.getInstance().getResource(
					WebFileSys.getInstance().getPrimaryLanguage(), "alert.noRole1",
					"You don't have the correct role to access this system.")%><a
			href="<%=request.getContextPath()%>/"><%=LanguageManager.getInstance().getResource(
					WebFileSys.getInstance().getPrimaryLanguage(), "label.tryAgain", "Try again.")%></a>
			<%=LanguageManager.getInstance().getResource(
					WebFileSys.getInstance().getPrimaryLanguage(), "alert.noRole2",
					"after ask for proper role.")%></label>
	</div>
	<%
		String user = request.getRemoteUser();
		JAASSecurityFilter.doWarnLog("User '" + user
				+ "' did a sucessfull login but doesn't have proper role to access this system.");
		session.invalidate();
	%>
</body>
</html>


