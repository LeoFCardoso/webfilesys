package de.webfilesys.gui.xsl;

import java.io.File;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.w3c.dom.Element;

import de.webfilesys.ClipBoard;
import de.webfilesys.WebFileSys;
import de.webfilesys.util.UTF8URLEncoder;
import de.webfilesys.util.XmlUtil;

/**
 * This should be used only in simple form (read only) webfilesys
 * 
 * @author Leonardo F. Cardoso (based on original by Frank Hoehnel)
 */
public class XslWinUNCDirTreeHandler extends XslDirTreeHandler {

	boolean clientIsLocal = false;

	public XslWinUNCDirTreeHandler(HttpServletRequest req, HttpServletResponse resp, HttpSession session, PrintWriter output,
			String uid, boolean clientIsLocal) {
		super(req, resp, session, output, uid);

		this.clientIsLocal = clientIsLocal;
	}

	protected void process() {
		String docRoot = userMgr.getDocumentRoot(uid);

		if (!accessAllowed(actPath)) {
			actPath = docRoot;
		}

		XmlUtil.setChildText(folderTreeElement, "currentPath", actPath);

		XmlUtil.setChildText(folderTreeElement, "encodedPath", UTF8URLEncoder.encode(actPath));

		ClipBoard clipBoard = (ClipBoard) session.getAttribute("clipBoard");

		if ((clipBoard == null) || clipBoard.isEmpty()) {
			XmlUtil.setChildText(folderTreeElement, "clipBoardEmpty", "true", false);
		} else {
			XmlUtil.setChildText(folderTreeElement, "clipBoardEmpty", "false", false);
		}

		XmlUtil.setChildText(folderTreeElement, "css", userMgr.getCSS(uid), false);

		XmlUtil.setChildText(folderTreeElement, "language", language, false);

		Element computerElement = doc.createElement("computer");

		folderTreeElement.appendChild(computerElement);

		// Leonardo - hide localhostname for security
		// computerElement.setAttribute("name", WebFileSys.getInstance().getLocalHostName());
		computerElement.setAttribute("name", "IN�CIO");

		Element parentElement = computerElement;

		// One level up from UserDocRoot
		String UNCPathDocRoot = WebFileSys.getInstance().getUserDocRoot();

		boolean access = accessAllowed(UNCPathDocRoot);

		if (access) {
			dirCounter++;

			if (actPath.equals(UNCPathDocRoot)) {
				currentDirNum = dirCounter;
			}

			Element rootElement = doc.createElement("folder");

			// Name must be the last name from UNC path
			File f = new File(UNCPathDocRoot);
			rootElement.setAttribute("name", f.getName());

			rootElement.setAttribute("id", Integer.toString(dirCounter));

			rootElement.setAttribute("path", UNCPathDocRoot);

			rootElement.setAttribute("menuPath", UNCPathDocRoot);

			computerElement.appendChild(rootElement);

			parentElement = rootElement;
		}

		if (dirTreeStatus.dirExpanded(UNCPathDocRoot)) {
			dirSubTree(parentElement, actPath, UNCPathDocRoot, access);
		}

		String fastPath = getParameter("fastPath");

		if (fastPath != null) {
			XmlUtil.setChildText(folderTreeElement, "fastPath", insertDoubleBackslash(actPath));
		}

		int topOfScreenDir = 0;

		if (currentDirNum > 5) {
			topOfScreenDir = currentDirNum - 5;
		}

		int scrollPos;

		if (browserManufacturer == BROWSER_MSIE) {
			scrollPos = topOfScreenDir * 17; // pixels per line
		} else {
			scrollPos = topOfScreenDir * 18; // pixels per line
		}

		XmlUtil.setChildText(folderTreeElement, "scrollPos", "" + scrollPos);

		this.processResponse("folderTree.xsl");
	}
}
