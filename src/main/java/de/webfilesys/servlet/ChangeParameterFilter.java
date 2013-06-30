package de.webfilesys.servlet;

import java.io.IOException;
import java.util.Arrays;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

/**
 * This filter modifies some functions of WebFileSys to prevent some features to be used.
 * 
 * It should be complemented by user interface maintenance to hide these options
 * 
 * @author leonardo
 * 
 */
public final class ChangeParameterFilter implements Filter {

	/**
	 * These commands will be redirected to "forbidden" command //TODO - check another "dangerous" commands
	 * and add to this list
	 */
	private static final String[] disallowedCommands = { "ajaxRPC", "downloadFolder", "deleteDir",
			"exifThumb", "fileStatistics", "fileSysUsage", "fmdelete", "ftpBackup", "getFile", "getThumb",
			"getZipContentFile", "mobile", "moveDir", "mp3Thumb", "multiDownload", "multiFileCopyMove",
			"multiFileDownloadPrompt", "multiFileOp", "pasteFiles", "pictureStory", "processList",
			"removeDir", "renameFile", "renameFilePrompt", "search", "slideShow", "slideShowInFrame",
			"slideShowParms", "storyInFrame", "thumbnail", "unixCmdLine", "uploadParms", "visitorFile" };

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse,
	 * javax.servlet.FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		String valueCommand = request.getParameter("command");
		HttpServletRequest requestHttp = (HttpServletRequest) request;

		if (Arrays.asList(disallowedCommands).contains(valueCommand)) {
			HttpServletResponse responseHttp = (HttpServletResponse) response;
			responseHttp.sendRedirect(requestHttp.getContextPath() + "/servlet?command=forbidden");

			String loggedInUser = (String) ((requestHttp.getSession().getAttribute("userid") != null) ? requestHttp
					.getSession().getAttribute("userid") : "no user logged on");

			Logger.getLogger(getClass()).warn(
					loggedInUser + " tried not allowed command: " + valueCommand
							+ ". Redirecting to forbidden page.");
			return;
		}

		chain.doFilter(request, response);

	}

	public void destroy() {
	}

	public void init(FilterConfig filterConfig) {
	}
}
