/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.ingest;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.artofsolving.jodconverter.OfficeDocumentConverter;
import org.artofsolving.jodconverter.office.DefaultOfficeManagerConfiguration;
import org.artofsolving.jodconverter.office.OfficeManager;
import ywc.core.settings;

/**
 *
 * @author topher
 */
public class openoffice {

    public static String[] ingest(String media_id, String extension) {

        String[] rtrnArr = new String[]{"0"};

        System.out.println("**STARTING OPENOFFICE.ORG CONVERSION**");

        try {
            OfficeManager officeManager = new DefaultOfficeManagerConfiguration()
                    .setOfficeHome(settings.getPathOpenOffice())
                    //.setConnectionProtocol(OfficeConnectionProtocol.PIPE)
                    //.setPipeNames("office1", "office2")
                    .setTaskExecutionTimeout(45000L).buildOfficeManager();
            officeManager.start();

            System.out.println("\n**CONVERTING TO PDF**");

            
            String origFilePath = settings.getPathYwcCache() + "/tmp/ing/-" + media_id + "." + extension;
            InputStream origFileInputStream = cdn.getMediaInputStream(media_id, extension, "orig",null);
            File origFile = new File(origFilePath);
            OutputStream origFileOutputStream = new FileOutputStream(origFile);
            byte buf[] = new byte[1024];
            int len;
            while ((len = origFileInputStream.read(buf)) > 0) {
                origFileOutputStream.write(buf, 0, len);
            }
            origFileOutputStream.close();
            origFileInputStream.close();

            
            String pdfPath = settings.getPathYwcCache() + "/tmp/ing/" + media_id + ".pdf";

            OfficeDocumentConverter converter = new OfficeDocumentConverter(officeManager);
//            System.out.println(filesystem.rtrnDir("doc", "orig", media_id) + "/" + media_id + "." + extension);
            converter.convert(new File(origFilePath), new File(pdfPath));

            officeManager.stop();

            File pdfFile = new File(pdfPath);

            if (pdfFile.exists()) {
                System.out.println("PDF -> SUCCESS\n\n**MOVING PDF TO ORIG LOCATION**");
                if (ywc.ingest.cdn.saveMediaFile(media_id, "pdf", "orig",null, "ing/" + media_id,false)) {
                System.out.println("PDF -> SUCCESS");       
                    rtrnArr[0] = "1";
                }

            }
        } catch (Exception ex) {
            Logger.getLogger(openoffice.class.getName()).log(Level.SEVERE, null, ex);
        }

        return rtrnArr;
    }
}
