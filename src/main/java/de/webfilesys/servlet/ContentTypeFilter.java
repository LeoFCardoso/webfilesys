package de.webfilesys.servlet;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

import org.apache.log4j.Logger;

/**
 * Force content-type for resources
 */
public class ContentTypeFilter implements Filter {

	private class ForcableContentTypeWrapper extends HttpServletResponseWrapper {
		public ForcableContentTypeWrapper(HttpServletResponse response) {
			super(response);
		}

		@Override
		public void setContentType(String type) {
		}

		public void forceContentType(String type) {
			super.setContentType(type);
		}
	}

	public void destroy() {
	}

	private String contentType = null;

	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
			throws IOException, ServletException {
		final HttpServletRequest request = (HttpServletRequest) servletRequest;
		final HttpServletResponse response = (HttpServletResponse) servletResponse;

		String reqUrl = request.getRequestURI();
		ForcableContentTypeWrapper newResponse = new ForcableContentTypeWrapper(response);
		newResponse.forceContentType(contentType);
		filterChain.doFilter(request, newResponse);
		Logger.getLogger(getClass()).debug("Header after filter: " + reqUrl + ", " + response.getContentType());

		// Uncomment for testing
		// filterChain.doFilter(request, response);
	}

	public void init(FilterConfig config) throws ServletException {
		contentType = config.getInitParameter("ContentType");
	}

}
