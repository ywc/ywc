/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.frontend.image;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import ywc.core.settings;

/**
 * @author topher
 */
public class router {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(router.class);

    public static Boolean choose(HttpServletRequest request, HttpServletResponse response) {

        Boolean rtrnSuccess = false;
        try {
            String uri = request.getParameter("uri");

            String toParse = uri.substring(4 + uri.indexOf("img/"));
            if (uri.startsWith("doc/") || uri.startsWith("/doc/")) {
                toParse = uri.substring(4 + uri.indexOf("doc/"));
            }
            String action = toParse.substring(0, toParse.indexOf("/"));
            toParse = toParse.substring(action.length() + 1);
            String ext = "png";
            if (toParse.contains(".") && !"png".equals(toParse.substring(toParse.lastIndexOf(".") + 1).toLowerCase())) {
                ext = toParse.substring(toParse.lastIndexOf(".") + 1).toLowerCase();
            }

            if ("scale".equals(action)) {

                String sizeStr = toParse.substring(0, toParse.indexOf("/"));
                toParse = toParse.substring(sizeStr.length() + 1);
                String media_id = toParse.substring(0, toParse.indexOf("/"));
                if (!"png".equals(ext)) {
                    ext = "jpg"; 
               }
                
                Integer size = ywc.core.settings.getMediaSizeThmb();
                if ((request.getParameter("size")!=null)&&!"".equals(request.getParameter("size"))) {
                    size = (Integer) Integer.parseInt(request.getParameter("size"));
                } else if (!"dynamic".equals(sizeStr)) {
                    size = (Integer) Integer.parseInt(sizeStr);
                }

                render.renderMedia(media_id, ext, size, response, request);

            } else if ("text".equals(action)) {

                String params = ywc.frontend.text.uri.paramsToString(uri, request);
                render.renderText(params, response, request);

            } else if ("orig".equals(action)) {
                
                String media_id = toParse.substring(0, toParse.indexOf("/"));
                rtrn.returnMediaToClient(request, response, media_id, ext, "orig", null);

            }  else if ("special".equals(action)) {
                
                special.router(uri, response, request);

            } else {

                String imgPath = settings.getPathYwcCoreData() + "bin/core/trans." + ext;
                if (rtrn.mediaModifiedSince(request, response, imgPath)) {
                    InputStream srcFileStream = new FileInputStream(imgPath);
                    rtrn.returnStream(srcFileStream, response,"local -> "+imgPath);
                }
                
            }

        } catch (IOException ex) {
            logger.warn(ex);
        }

        return rtrnSuccess;
    }
}
