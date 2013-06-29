/**
 * Example for a viewhandler implementation contributed by Leonardo F. Cardoso.
 */
package br.nom.leonardo.viewhandler;

import java.io.InputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfGState;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;

import de.webfilesys.ViewHandlerConfig;
import de.webfilesys.viewhandler.ViewHandler;

/**
 * Uses iText to implement a "stamp" with userid
 * 
 * @author Leonardo F. Cardoso
 */
public class PDFViewHandler implements ViewHandler {

	public void process(String filePath, ViewHandlerConfig viewHandlerConfig, HttpServletRequest req,
			HttpServletResponse resp) {

		try {

			resp.setContentType("application/pdf");

			String userid = req.getSession().getAttribute("userid").toString().trim().toUpperCase();

			PdfReader reader = new PdfReader(filePath);
			int numberOfPages = reader.getNumberOfPages();

			PdfStamper stamper = new PdfStamper(reader, resp.getOutputStream());
			byte[] userPass = null; //Long.toHexString(System.currentTimeMillis()).getBytes();
			byte[] ownerPass = Long.toHexString(System.currentTimeMillis()).getBytes();
			stamper.setEncryption(userPass, ownerPass, PdfWriter.ALLOW_PRINTING, PdfWriter.ENCRYPTION_AES_128);
			int index = 1;
			PdfContentByte over;

			BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, BaseFont.EMBEDDED);

			PdfGState gstate = new PdfGState();
			gstate.setFillOpacity(0.3f);
			gstate.setStrokeOpacity(0.3f);

			while (index <= numberOfPages) {
				over = stamper.getOverContent(index);
				over.saveState();
				over.setGState(gstate);
				over.beginText();
				over.setFontAndSize(bf, 150);
				float pageHeight = reader.getPageSize(index).getHeight();
				float pageWidth = reader.getPageSize(index).getWidth();
				double rotacao = Math.toDegrees(Math.atan(pageHeight / pageWidth));
				over.showTextAligned(PdfContentByte.ALIGN_CENTER, userid.toUpperCase(), pageWidth / 2,
						pageHeight / 2, (float) rotacao);
				over.setFontAndSize(bf, 80);
				// Upper
				over.showTextAligned(PdfContentByte.ALIGN_CENTER, userid.toUpperCase(), pageWidth / 4,
						(pageHeight / 4) + (pageHeight / 2), (float) rotacao);
				// Lower
				over.showTextAligned(PdfContentByte.ALIGN_CENTER, userid.toUpperCase(), (pageWidth / 2)
						+ (pageWidth / 4), (pageHeight / 2) - (pageHeight / 4), (float) rotacao);
				over.endText();
				over.restoreState();
				index++;
			}
			stamper.close();

		} catch (Exception e) {
			// TODO exception handling
			e.printStackTrace();
		}

	}

	public void processZipContent(String fileName, InputStream zipIn, ViewHandlerConfig viewHandlerConfig,
			HttpServletRequest req, HttpServletResponse resp) {
	}

	public boolean supportsZipContent() {
		return false;
	}

}
