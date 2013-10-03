<%@page import="java.security.MessageDigest"%>
<%@page import="de.webfilesys.servlet.JAASSecurityFilter"%>

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
		<h1>Pauta ROD Login</h1>
		<label>As credenciais de acesso não foram aceitas.</label> <label><a
			href="<%=request.getContextPath()%>/">Tente novamente.</a></label> <label>Se
			o erro persistir, contacte o Service Desk.</label>
	</div>
	<%
		String user = request.getParameter("j_username");
		String userMd5 = "";
		try {
			byte[] bytesOfMessage = user.getBytes();
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] digest = md.digest(bytesOfMessage);
			//byte[] para string -> http://stackoverflow.com/questions/415953/generate-md5-hash-in-java
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < digest.length; ++i) {
				sb.append(Integer.toHexString((digest[i] & 0xFF) | 0x100).substring(1, 3));
			}
			userMd5 = sb.toString();
		} catch (Exception e) {
			JAASSecurityFilter.doWarnLog("Error generatind MD5 sum: " + e.getMessage());
			userMd5 = "";
		}
		JAASSecurityFilter.doWarnLog("Bad login attempt from " + request.getRemoteAddr() + ":"
				+ request.getRemotePort() + " for username with MD5 sum: " + userMd5);
		session.invalidate();
	%>
</body>
</html>


