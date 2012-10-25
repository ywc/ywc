/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.ingest;

import java.util.HashMap;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.im4java.core.IM4JavaException;
import ywc.core.settings;
import ywc.core.xslt;

/**
 *
 * @author topher
 */
public class ingest {

    public static String[] ingestMedia(String[] docProperties, String media_id) throws IM4JavaException, Exception {
        
        String[] ingestFeedback = null;
        Boolean metaSuccess = false;
        String ext = docProperties[2];

        if ("imagemagick".equals(docProperties[0])) {
            ingestFeedback = ywc.ingest.imagemagick.ingest(media_id, ext);
      //      metaSuccess = ywc.ingest.imagemagick.meta(media_id, ext);
        } else if ("ffmpeg".equals(docProperties[0])) {
            ingestFeedback = ywc.ingest.ffmpeg.ingest(media_id, ext);
      //      metaSuccess = true;
        } else if ("openoffice".equals(docProperties[0])) {
            ingestFeedback = ywc.ingest.openoffice.ingest(media_id, ext);
            if ("1".equals(ingestFeedback[0])) {
                ingestFeedback = ywc.ingest.imagemagick.ingest(media_id, "pdf");
      //          metaSuccess = ywc.ingest.imagemagick.meta(media_id, "pdf");
            }
        } else {
            ingestFeedback = new String[]{"1"};
      //      metaSuccess = true;
        }
        
        return ingestFeedback;
    }
    
    public static Boolean ingestSuccess(String[] ingestFeedback) {
        Boolean rtrn = false;
        if ((ingestFeedback != null) && (((Integer) Integer.parseInt((String) ingestFeedback[0])) > 0)) {
            rtrn = true;
        }
        return rtrn;
    }
    
    public static Boolean ingestSynchronously(Boolean originalExists, String ext, long fileSize) {
        
        ext = ext.toLowerCase();
        if (    originalExists
                && ((("jpg".equals(ext)) || ("jpeg".equals(ext))) || ("png".equals(ext)) || ("gif".equals(ext)))
                && (fileSize < settings.getMediaLimitSynchronousIngest())) {
            return true;
        }
        return false;
    }    

    public static String[] docProperties(String ext) {
        String[] rtrn = new String[]{"none", "doc", "ext"};
        try {
            HashMap rtrnObj = new HashMap();
            rtrnObj.put("ext", ext);
            rtrnObj.put("return", "convert");
            rtrn[0] = xslt.exec(settings.getPathYwcCoreData() + "xml/core/filetypes.xml", settings.getPathYwcCoreData() + "xsl/core/router/filetypes.xsl", rtrnObj, null, null);

            rtrnObj = new HashMap();
            rtrnObj.put("ext", ext);
            rtrnObj.put("return", "type");
            rtrn[1] = xslt.exec(settings.getPathYwcCoreData() + "xml/core/filetypes.xml", settings.getPathYwcCoreData() + "xsl/core/router/filetypes.xsl", rtrnObj, null, null);

            rtrn[2] = ext;
        } catch (Exception ex) {
            Logger.getLogger(ingest.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rtrn;
    }
}
