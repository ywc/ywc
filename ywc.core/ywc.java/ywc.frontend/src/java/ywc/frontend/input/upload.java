/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.frontend.input;

import com.oreilly.servlet.MultipartRequest;
import java.io.File;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import ywc.core.filesystem;
import ywc.core.settings;

/**
 *
 * @author topher
 */
public class upload {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(upload.class);
    
    public static void processUpload(PrintWriter out, HttpServletRequest request, HttpServletResponse response) {
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Content-Disposition", "inline; filename=\"files.json\"");
        response.setHeader("X-Content-Type-Options", "nosniff");
        
        if (request.getHeader("User-Agent").toLowerCase().indexOf("msie") > 0) {
            response.setContentType("text/plain;charset=UTF-8");
        } else {
            response.setContentType("application/json;charset=UTF-8");
        }
              
        if ("GET".equals(request.getMethod())) {
            out.println(ywc.core.str.rtrnJson(get(request, response)));
        } else if ("POST".equals(request.getMethod())) {
            out.println(ywc.core.str.rtrnJson(post(request, response)));
        } else if ("DELETE".equals(request.getMethod())) {
            out.println(ywc.core.str.rtrnJson(delete(request, response)));
        } else {
            out.println(ywc.core.str.rtrnJson(empty()));
        }
    }
    
    public static ArrayList empty() {
        ArrayList rtrnObj = new ArrayList();
        return rtrnObj;
    }
    
    public static ArrayList get(HttpServletRequest request, HttpServletResponse response) {
        ArrayList rtrnObj = new ArrayList();
        return rtrnObj;
    }

    public static ArrayList delete(HttpServletRequest request, HttpServletResponse response) {
        ArrayList rtrnObj = new ArrayList();
        return rtrnObj;
    }
    
    public static ArrayList post(HttpServletRequest request, HttpServletResponse response) {
        ArrayList rtrnObj = new ArrayList();
        long ingestTime = System.currentTimeMillis();
        try {
            String outMsg;
            
            String media_id = ywc.core.str.basicId(32);
            
            MultipartRequest uploadRequest = new MultipartRequest(request
                            ,settings.getPathYwcCache() + "/tmp/upl/" //saved to (renamed after)
                            , settings.getMediaLimitUpload() // maximum upload size
                  //          ,"UTF-8"
                  //          ,new DefaultFileRenamePolicy()
                            );
            Enumeration files = uploadRequest.getFileNames();
            while (files.hasMoreElements()) {
                String upload = (String) files.nextElement();
                String filename = uploadRequest.getFilesystemName(upload);
                String file_ext = filesystem.fileExtension(filename).toLowerCase();

                File tmp = new File(settings.getPathYwcCache() + "/tmp/upl/" + filename);
                String savePath = settings.getPathYwcCache() + "/tmp/upl/" + media_id + "." + file_ext;
                Boolean orig_save = tmp.renameTo(new File(savePath));

                HashMap fileObj = new HashMap();
                fileObj.put("media_id", media_id);
                fileObj.put("name", filename);
                fileObj.put("ext", file_ext);

                outMsg = "setup";
                logger.debug(outMsg + " " + (System.currentTimeMillis() - ingestTime));
                ingestTime = System.currentTimeMillis();
                
                if (orig_save) {
                    long fileSize = filesystem.fileSize(savePath);
                    fileObj.put("orig", "doc/orig/"+media_id+"/"+filename);
                    fileObj.put("image", settings.getYwcEnvProtocol()+"://"+settings.getYWCMediaDomain()
                                        +"/img/scale/dynamic/"+media_id+"/image.jpg");
                    fileObj.put("size", fileSize);
                    
                    Boolean saveMedia = ywc.ingest.cdn.saveMediaFile(media_id, file_ext, "orig",null, "upl/"+media_id,true);
                    
                    outMsg = "save original";
                    logger.debug(outMsg + " " + (System.currentTimeMillis() - ingestTime));
                    ingestTime = System.currentTimeMillis();
                    
                    Boolean addToQueue = true;
                    if (ywc.ingest.ingest.ingestSynchronously(saveMedia, file_ext, fileSize)) {
                        String[] ingestProperties = ywc.ingest.ingest.docProperties(file_ext);
                        String[] ingestFeedback = ywc.ingest.ingest.ingestMedia(ingestProperties, media_id);
                        if (ywc.ingest.ingest.ingestSuccess(ingestFeedback)) {
                            addToQueue = false;
                        } else {
                            logger.warn("Failed to ingest media item: "+media_id+"."+file_ext);
                        }
                        outMsg = "verifying ingestion success";
                        logger.debug(outMsg + " " + (System.currentTimeMillis() - ingestTime));
                        ingestTime = System.currentTimeMillis();
                    } else if (!settings.getMediaIngestNonImages()) {
                        fileObj.remove("image");
                    }
                    
                    if (addToQueue && !settings.getMediaIngestNonImages()) {
                        logger.debug("This item ("+file_ext+") will not be added to the ingestion queue.");
                    } else if (addToQueue && !ywc.ingest.queue.addItem(media_id,file_ext)) {
                        logger.warn("Failed to add media item "+media_id+"."+file_ext+" to the ingestion queue.");
                    }
                    
                    rtrnObj.add(fileObj);
                } else {
                   logger.warn("File coiuld not saved ");
                }
            }

        } catch (Exception ex) {
            logger.warn(ex);
        }

        response.setHeader("Vary", "Accept");

        return rtrnObj;
    }
}
