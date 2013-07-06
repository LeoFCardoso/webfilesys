/**
 * Example for a viewhandler implementation contributed by Leonardo F. Cardoso.
 */
package de.webfilesys.viewhandler;

import java.io.File;
import java.io.InputStream;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfGState;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;

import de.webfilesys.ViewHandlerConfig;

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
			byte[] userPass = null;
			String ownerPassStr = Long.toHexString(System.currentTimeMillis())
					+ Long.toHexString((long) (Math.random() * 1000000));
			byte[] ownerPass = ownerPassStr.getBytes();
			stamper.setEncryption(userPass, ownerPass, PdfWriter.ALLOW_PRINTING, PdfWriter.ENCRYPTION_AES_128);
			int index = 1;
			PdfContentByte over;

			BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI, BaseFont.EMBEDDED);

			PdfGState gstate = new PdfGState();
			gstate.setFillOpacity(0.2f);
			gstate.setStrokeOpacity(0.2f);

			while (index <= numberOfPages) {
				over = stamper.getOverContent(index);
				over.saveState();
				over.setGState(gstate);
				over.beginText();
				over.setFontAndSize(bf, 150);
				float pageHeight = reader.getPageSize(index).getHeight();
				float pageWidth = reader.getPageSize(index).getWidth();
				double rotacao = Math.toDegrees(Math.atan(pageHeight / pageWidth));
				float fixedX = 20;
				// Middle
				over.showTextAligned(PdfContentByte.ALIGN_CENTER, userid.toUpperCase(), fixedX
						+ (pageWidth / 2), pageHeight / 2, (float) rotacao);
				over.setFontAndSize(bf, 80);
				// Upper
				Date actualDate = new Date();
				DateFormat dfDate = DateFormat.getDateInstance(DateFormat.SHORT, new Locale("pt", "BR"));
				over.showTextAligned(PdfContentByte.ALIGN_CENTER, dfDate.format(actualDate), fixedX
						+ (pageWidth / 4), (pageHeight / 4) + (pageHeight / 2), (float) rotacao);
				// Lower
				over.showTextAligned(PdfContentByte.ALIGN_CENTER, "BNDES", fixedX + (pageWidth / 2)
						+ (pageWidth / 4), (pageHeight / 2) - (pageHeight / 4), (float) rotacao);
				over.endText();
				over.restoreState();
				index++;
			}
			stamper.close();
			reader.close();
			resp.getOutputStream().close();

		} catch (Exception e) {
			Logger.getLogger(getClass()).error(
					"PDF file (" + filePath + ") could not be stamped. " + e.getMessage());
			try {
				Document document = new Document();
				PdfWriter.getInstance(document, resp.getOutputStream());
				document.open();
				File file = new File(filePath);
				document.add(new Paragraph(
						"O documento '"
								+ file.getName()
								+ "' não pode ser exibido nesta ferramenta, pois foi criado com proteção de segurança. "
								+ "Por favor, certifique-se que foi gerado um arquivo PDF sem proteção de segurança,"
								+ " mas não se preocupe, pois esta ferramenta somente exibe arquivos PDF com a devida proteção, gerada em tempo real."));
				document.close();
			} catch (Exception e1) {
				Logger.getLogger(getClass()).error(
						"Error PDF for (" + filePath + ") could not be generated. " + e1.getMessage());
			}
		}
	}

	public void processZipContent(String fileName, InputStream zipIn, ViewHandlerConfig viewHandlerConfig,
			HttpServletRequest req, HttpServletResponse resp) {
	}

	public boolean supportsZipContent() {
		return false;
	}

}
