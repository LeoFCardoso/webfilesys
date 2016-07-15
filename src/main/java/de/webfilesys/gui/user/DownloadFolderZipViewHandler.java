package de.webfilesys.gui.user;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.util.Date;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import de.webfilesys.WebFileSys;
import de.webfilesys.stats.DirStatsByAge;
import de.webfilesys.util.CommonUtils;
import de.webfilesys.viewhandler.PDFViewHandler;

/**
 * Use PDF view handler to put content inside Zip file
 * 
 * @author Leonardo F. Cardoso, based on original by Frank Hoehnel
 */
public class DownloadFolderZipViewHandler extends UserRequestHandler {

	public DownloadFolderZipViewHandler(HttpServletRequest req, HttpServletResponse resp, HttpSession session,
			PrintWriter output, String uid) {
		super(req, resp, session, output, uid);
	}

	protected void process() {
		String path = getParameter("path");

		if (!checkAccess(path)) {
			return;
		}

		String errorMsg = null;

		File folderFile = new File(path);

		if ((!folderFile.exists()) || (!folderFile.isDirectory()) || (!folderFile.canRead())) {
			errorMsg = "folder is not a readable directory: " + path;
		}

		String dirName = null;

		int lastSepIdx = path.lastIndexOf(File.separatorChar);

		if (lastSepIdx < 0) {
			lastSepIdx = path.lastIndexOf('/');
		}

		if ((lastSepIdx < 0) || (lastSepIdx == path.length() - 1)) {
			errorMsg = "invalid path for folder download: " + path;
		} else {
			dirName = path.substring(lastSepIdx + 1);
		}

		// Check if max number of zip files is reached.
		DirStatsByAge dsba = new DirStatsByAge();
		dsba.determineStatistics(path);
		int maxFilesForDownload = WebFileSys.getInstance().getDownloadFolderFileLimit();
		long maxSizeForDownload = WebFileSys.getInstance().getDownloadFolderSizeLimitInBytes();
		if ((dsba.getFilesInTree() > maxFilesForDownload) || (dsba.getTreeFileSize() > maxSizeForDownload)) {
			errorMsg = "Muitos arquivos foram selecionados para download (" + dsba.getFilesInTree() + " arquivos, "
					+ dsba.getTreeFileSize() / (1024 * 1024) + " megabytes). <br>Os máximos são " + maxFilesForDownload
					+ " arquivos ou " + maxSizeForDownload / (1024 * 1024) + " megabytes.<br>Pasta selecionada '"
					+ folderFile.getName()
					+ "'.<br>Por favor, <a href='javascript:history.go(-1)'>retorne</a> e tente novamente!";
		}

		if (errorMsg != null) {
			Logger.getLogger(getClass()).warn(errorMsg);
			resp.setStatus(404);
			resp.setContentType("text/html");
			try {
				PrintWriter output = new PrintWriter(resp.getWriter());
				output.println("<html>");
				output.println("<body>");
				output.println(errorMsg);
				output.println("</body>");
				output.println("</html>");
				output.flush();
				return;
			} catch (IOException ioEx) {
				Logger.getLogger(getClass()).warn(ioEx);
			}
		}

		resp.setContentType("application/zip");

		String token = getParameter("token");
		if (token != null) {
			Logger.getLogger(getClass()).debug("Setting fileDownloadToken to control blockUI with " + token);
			Cookie cookie = new Cookie("fileDownloadToken", token);
			resp.addCookie(cookie);
		}

		resp.setHeader("Content-Disposition", "attachment; filename=" + dirName + ".zip");

		OutputStream byteOut = null;
		ZipOutputStream zipOut = null;

		try {
			byteOut = resp.getOutputStream();
			zipOut = new ZipOutputStream(byteOut);

			// Test code to simulate slow zip compression
			// try {
			// Thread.sleep(2000);
			// } catch (InterruptedException e) {
			// // TODO Auto-generated catch block
			// e.printStackTrace();
			// }

			// Add metadata file to identify zip file and try to start download quickly
			String infoText = "User: " + req.getSession().getAttribute("userid").toString().trim().toUpperCase();
			infoText += "; generated on " + DateFormat.getDateTimeInstance().format(new Date());
			ZipEntry newZipEntry = new ZipEntry("_INFO.TXT");
			zipOut.putNextEntry(newZipEntry);
			zipOut.write(infoText.getBytes());
			zipOut.flush(); // try to sinalize browser to start downloading

			zipFolderTree(path, "", zipOut);

		} catch (IOException ioEx) {
			Logger.getLogger(getClass()).warn(ioEx);
		} finally {
			try {
				if (zipOut != null) {
					zipOut.close();
				}
				if (byteOut != null) {
					byteOut.close();
				}
			} catch (Exception ex) {
			}
		}
	}

	private void zipFolderTree(String actPath, String relativePath, ZipOutputStream zipOut) {
		File actDir = new File(actPath);

		String fileList[] = actDir.list();

		if (fileList.length == 0) {
			return;
		}

		for (int i = 0; i < fileList.length; i++) {
			File tempFile = new File(actPath + File.separator + fileList[i]);

			if (tempFile.isDirectory()) {
				zipFolderTree(actPath + File.separator + fileList[i], relativePath + fileList[i] + "/", zipOut);
			} else {
				String fullFileName = actPath + File.separator + fileList[i];
				String relativeFileName = relativePath + fileList[i];

				try {
					ZipEntry newZipEntry = new ZipEntry(relativeFileName);
					zipOut.putNextEntry(newZipEntry);
					FileInputStream inStream = null;
					File tempStampedPdf = File.createTempFile("fmwebPdFStamp", null);
					try {
						File originalFile = new File(fullFileName);
						Logger.getLogger(getClass())
								.info("User " + getUid() + " requested this file on multi download: " + originalFile);
						if (CommonUtils.getFileExtension(originalFile.getName()).equalsIgnoreCase(".pdf")) {
							// Will use view handler logic for PDFs
							PDFViewHandler pdfHandler = new PDFViewHandler();
							OutputStream fos = new FileOutputStream(tempStampedPdf);
							pdfHandler.processOutputStream(originalFile.getCanonicalPath(), req, fos);
							inStream = new FileInputStream(tempStampedPdf);
						} else {
							// Normal behaviour of multiDownload
							inStream = new FileInputStream(originalFile);
						}

						byte buff[] = new byte[4096];
						int count;
						while ((count = inStream.read(buff)) >= 0) {
							zipOut.write(buff, 0, count);
						}

					} catch (Exception zioe) {
						Logger.getLogger(getClass()).warn("failed to zip file " + fullFileName, zioe);
					} finally {
						tempStampedPdf.delete();
						if (inStream != null) {
							try {
								inStream.close();
							} catch (Exception ex) {
							}
						}
					}
				} catch (IOException ioex) {
					Logger.getLogger(getClass()).error("failed to zip file " + fullFileName, ioex);
				}
			}
		}
	}
}
