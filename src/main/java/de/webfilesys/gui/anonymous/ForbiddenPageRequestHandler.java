package de.webfilesys.gui.anonymous;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import de.webfilesys.gui.RequestHandler;

/**
 * @author Leonardo Cardoso
 */
public class ForbiddenPageRequestHandler extends RequestHandler {
	public ForbiddenPageRequestHandler(HttpServletRequest req, HttpServletResponse resp, PrintWriter output) {
		super(req, resp, null, output);
	}

	protected void process() {
		output.println("<html>");
		output.println("<head>");
		output.println("</head>");
		output.println("<body>");
		// TODO - set localized message to end user
		output.println("<h3>403 - Proibido. O acesso a esta página é vedado. Contate o administrador do sistema!</h3>");
		output.println("</body></html>");
		output.flush();
	}
}
