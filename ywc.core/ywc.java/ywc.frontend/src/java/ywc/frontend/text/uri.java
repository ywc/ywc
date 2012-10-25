/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.frontend.text;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import ywc.core.settings;
import ywc.core.xslt;

/**
 *
 * @author topher
 */
public class uri {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(uri.class);
    public static String paramsToString(String uri, HttpServletRequest request) {
        String params = "";
        if (uri.contains("?")) {
            params = uri.substring(1 + uri.indexOf("?"));
        }
        String urlParamsIndex;
        Enumeration urlParams = request.getParameterNames();
        while (urlParams.hasMoreElements()) {
            urlParamsIndex = (String) urlParams.nextElement();
            if (!"uri".equals(urlParamsIndex)
                    && !"nocache".equals(urlParamsIndex)
                    && !"flushcache".equals(urlParamsIndex)) {
                if (!"".equals(params)) {
                    params += "&";
                }
                params += urlParamsIndex + "=" + request.getParameter(urlParamsIndex);
            }
        }
        return params;
    }

    public static String langFromUri(String uri) {
        String outLang = "en";
        try {
            if ((uri.length() >= 4) && uri.startsWith("/") && (uri.substring(3).startsWith("/"))) {
                HashMap langObj = new HashMap();
                langObj.put("abbr", uri.substring(1,3));
                outLang = xslt.exec(settings.getPathYwcCoreData()+"xml/core/langs.xml", settings.getPathYwcCoreData() + "xsl/core/router/langs.xsl", langObj, null, null);
            }
        } catch (Exception ex) {
            logger.warn(ex);
        }
        return outLang;
    }
    
    public static String isolateUri(String uri, String lang) {
        String outUri = uri;
        
        if (uri.startsWith("/"+lang+"/")) {
            outUri = uri.substring(3);
        }
        
        if (uri.contains("?")) {
            outUri = outUri.substring(0,outUri.indexOf("?"));
        }
        
        return outUri;
    }
    
    
    public static Boolean aggregateIncludes(HttpServletRequest request, HttpServletResponse response, long routerStart, Boolean flushCache) {
        PrintWriter out = null;
        Boolean rtrnVal = false;

        String uri = request.getParameter("uri");

        String params = ywc.frontend.text.uri.paramsToString(uri, request);
        HashMap paramObj = new HashMap();
        paramObj.put("params", params);
        paramObj.put("uri", uri);
            
        try {
            
            out = response.getWriter();
            response.setDateHeader("Last-Modified", System.currentTimeMillis());
            response.setHeader("Cache-Control", "private, no-cache, no-store, must-revalidate");
            
            if (uri.startsWith("/inc/js") || uri.startsWith("inc/js")) {
                response.setContentType("text/javascript");
            } else if (uri.startsWith("/inc/css") || uri.startsWith("inc/css")) {
                response.setContentType("text/css");
            }
            
            String mcHash = "ywc_"+ywc.core.str.md5sum(settings.getPathYwcCache() + "/xml/data/include.xml" + "%" + settings.getPathYwcCoreData()+"xsl/core/render/include.xsl" + "%" + uri + "%" + params);
                        
            out.println(xslt.exec(settings.getPathYwcCache() + "/xml/data/include.xml", settings.getPathYwcCoreData() + "xsl/core/render/include.xsl", paramObj, mcHash, flushCache));
            
            logger.debug("Include " + (System.currentTimeMillis() - routerStart) + "ms\t" + uri);
            
        } catch (IOException ex) {
            logger.warn(ex);
        } finally {
            out.close();
        }
        return rtrnVal;
    }
            

    
    
}
