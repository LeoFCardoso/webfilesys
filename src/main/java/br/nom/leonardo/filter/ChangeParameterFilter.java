package br.nom.leonardo.filter;

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
	 * These commands will be redirected to "blank" command //TODO - check another "dangerous" commands and
	 * add to this list
	 */
	private static final String[] disallowedCommands = { "exifThumb", "fileStatistics", "fileSysUsage",
			"ftpBackup", "getFile", "getThumb", "getZipContentFile", "mobile", "mp3Thumb", "multiDownload",
			"multiFileCopyMove", "multiFileDownloadPrompt", "multiFileOp", "pasteFiles", "pictureStory",
			"processList", "slideShowInFrame", "slideShowParms", "storyInFrame", "thumbnail", "unixCmdLine",
			"uploadParms", "visitorFile" };

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
			responseHttp.sendRedirect(requestHttp.getContextPath() + "/servlet?command=blank");
			return;
		}

		chain.doFilter(request, response);

	}

	public void destroy() {
	}

	public void init(FilterConfig filterConfig) {
	}
}
