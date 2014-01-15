/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.frontend.image;

import java.io.*;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import ywc.core.settings;
import ywc.core.xslt;
import ywc.ingest.cdn;

/**
 *
 * @author topher
 */
public class rtrn {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(rtrn.class);
    
    public static void returnMediaToClient(HttpServletRequest request, HttpServletResponse response, String media_id, String ext, String version, String fileNameAddition) {

        if (media_id.length() >= 4) {
            String storageMethod = settings.getMediaStorageMethod();
            String fileDir = "doc" + cdn.getFileDir(media_id, ext, version);
            String fileName = media_id + cdn.formatMediaFileNameAddition(fileNameAddition) + "." + ext;

            try {

                if ("local".equals(storageMethod) && mediaModifiedSince(request, response, settings.getPathYwcCache() + "/" + "doc" + cdn.getFileDir(media_id, ext, version) + "/" + media_id + cdn.formatMediaFileNameAddition(fileNameAddition) + "." + ext)) {
                    response.setContentType(getMimeType(ext));
                    InputStream srcFileStream = cdn.getMediaInputStream(media_id, ext, version, fileNameAddition);
                    returnStream(srcFileStream, response, "local -> "+media_id+"."+ext);

                } else if ("aws".equals(storageMethod)) {
                    String redirectDomain = settings.getCdnTypeAwsCloudFrontDomain().equals("") ? settings.getCdnTypeAwsS3BucketName()+".s3.amazonaws.com" : settings.getCdnTypeAwsCloudFrontDomain();
                    response.sendRedirect(settings.getYwcEnvProtocol()+"://"+redirectDomain+"/"+fileDir+"/"+fileName);

                } else if ("sftp".equals(storageMethod)) {
                    response.sendRedirect(settings.getCdnTypeSFTPUri()+"/"+fileDir+"/"+fileName);
                    
                }

            } catch (IOException ex) {
                logger.warn(ex);
            }
        }
    }

    public static void returnStream(InputStream srcFileStream, HttpServletResponse response, String streamName) {
        try {
            ServletOutputStream outFileStream = response.getOutputStream();
            byte[] buf = new byte[5 * 1024];
            int cnt = 0;
            while ((cnt = srcFileStream.read(buf)) >= 0) {
                outFileStream.write(buf, 0, cnt);
            }
            outFileStream.close();
            srcFileStream.close();
        } catch (Exception ex) {
            logger.warn("return stream failure", ex);
        }
    }

    public static String getMimeType(String extIn) {
        String rtrnMime = "text/html";
        String ext = extIn.toLowerCase();
        if ("png".equals(ext)) {
            rtrnMime = "image/png";
        } else if ("jpg".equals(ext) || "jpeg".equals(ext)) {
            rtrnMime = "image/jpeg";
        } else {
            try {
                HashMap rtrnObj = new HashMap();
                rtrnObj.put("ext", ext.toLowerCase());
                rtrnObj.put("return", "mime");
                String mcHash = "ywc_" + ywc.core.str.md5sum(settings.getPathYwcCoreData() + "xml/core/filetypes.xml" + "%" + settings.getPathYwcCoreData() + "xsl/core/router/filetypes.xsl%" + ext.toLowerCase() + "%mime");
                rtrnMime = xslt.exec(settings.getPathYwcCoreData() + "xml/core/filetypes.xml", settings.getPathYwcCoreData() + "xsl/core/router/filetypes.xsl", rtrnObj, mcHash, null);
            } catch (Exception ex) {
                logger.warn(ex);
            }
        }
        return rtrnMime;
    }

    public static Boolean mediaModifiedSince(HttpServletRequest request, HttpServletResponse response, String mediaPath) {
        Boolean rtrn = true;
        long lastModified = System.currentTimeMillis();
        if (request.getHeader("If-Modified-Since") != null) {
            File mediaFile = null;
            mediaFile = new File(mediaPath);
            if ((mediaFile != null) && mediaFile.exists()) {
                lastModified = mediaFile.lastModified();
            }
            if (lastModified < request.getDateHeader("If-Modified-Since")) {
                response.setStatus(response.SC_NOT_MODIFIED);
                rtrn = false;
            }
        }

        response.setDateHeader("Last-Modified", lastModified);
        response.setHeader("Cache-Control", "must-revalidate");

        return rtrn;
    }
    
    public static void returnMediaError(HttpServletRequest request, HttpServletResponse response, String format, int error) {
        
        if (!"jpg".equals(format)) {
            format = "png";
        }
        String imgPath = settings.getPathYwcCoreData() + "bin/error/no-image-" + error + "." + format;

        try {
        //    if (rtrn.mediaModifiedSince(request, response, imgPath)) {
            InputStream srcFileStream = new FileInputStream(imgPath);
            rtrn.returnStream(srcFileStream, response,"local -> "+imgPath);
            srcFileStream.close();
            response.setStatus(error);
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            response.setHeader("Cache-Control", "no-cache");
            response.setHeader("Cache-Control", "no-store");
        //    }
        }  catch (Exception ex) {
            logger.warn(ex);
        }
    }
}
