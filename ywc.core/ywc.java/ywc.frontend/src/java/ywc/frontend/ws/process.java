/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.frontend.ws;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import ywc.core.filesystem;
import ywc.core.settings;
import ywc.core.xslt;


/**
 *
 * @author topher
 */
public class process {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(process.class);
    
    public static String getRouterAction(String uri) {
        String action = "";
        String[] uriBlocks = uri.split("/");
        for (int i = 0; i < uriBlocks.length; i++) {
            if (!"".equals(uriBlocks[i])) {
                action = uriBlocks[i];
                break;
            }
        }
        return action;
    }

    public static Boolean isUriRedirect(HashMap paramObj, String uri, long routerStart, HttpServletResponse response, HttpServletRequest request) throws IOException {
        Boolean rtrn = false;
        
        String mcHash = "ywc_"+ywc.core.str.md5sum(settings.getPathYwcCache() + "/xml/data/uri.xml" + "%" + settings.getPathYwcCoreData()+"xsl/core/router/redirect.xsl" + "%" + uri);
        String redirect = xslt.exec(settings.getPathYwcCache() + "/xml/data/uri.xml", settings.getPathYwcCoreData() + "xsl/core/router/redirect.xsl", paramObj, mcHash, null).trim();
        
        if (!"".equals(redirect) && !redirect.startsWith("ywc-media-")) {
            response.setStatus(response.SC_MOVED_TEMPORARILY);
            response.setHeader("Location", redirect);
            rtrn = true;
            logger.debug("Redirect: " + uri + " to " + redirect);
//            System.out.println("ywc:\t" + (System.currentTimeMillis() - routerStart) + "ms\t" + uri+"\tredirect: "+redirect);
        } else if (redirect.startsWith("ywc-media-")) {
            String media_id = redirect.substring(10);
            String ext = uri.substring(1+uri.lastIndexOf("."));
            ywc.frontend.image.rtrn.returnMediaToClient(request, response, media_id, ext, "orig", null);
            rtrn = true;
            logger.debug("RedirectMedia: " + uri + " to media " + media_id);
//            System.out.println("ywc:\t" + (System.currentTimeMillis() - routerStart) + "ms\t" + uri+"\tmedia: "+media_id);
        }
        return rtrn;
    }

    public static String appendCookiesAndHeaders(String params, HttpServletRequest request) {
        if (request.getCookies() != null) {
            Cookie[] cookies = request.getCookies();
            for (int i = 0; i < cookies.length; i++) {
                Cookie cookie = cookies[i];
                if (cookie.getName().equals("token_id")) {
                    if (!"".equals(params)) {
                        params += "&";
                    }
                    params += cookie.getName() + "=" + cookie.getValue();
                }
            }
        }
        if (request.getHeader("User-Agent") != null) {
            if (!"".equals(params)) {
                params += "&";
            }
            params += "HTTP-User-Agent=" + request.getHeader("User-Agent");
        }

        return params;
    }

    public static Boolean xslCommand(String xslOutput, HttpServletResponse response) {
        Boolean rtrn = false;

        if (xslOutput.contains(settings.getYwcXslDelimCommand())) {
            String[] getCommand = xslOutput.split(settings.getYwcXslDelimCommand());
            String commandType = getCommand[1].substring(0, getCommand[1].indexOf(":"));
            String commandText = getCommand[1].substring(1 + getCommand[1].indexOf(":"));

            if ("redirect".equals(commandType)) {
                response.setStatus(response.SC_MOVED_TEMPORARILY);
                response.setHeader("Location", commandText);
                rtrn = true;
            }
        }

        return rtrn;
    }

    public static void proxyUrl(String uri, HttpServletResponse response) throws MalformedURLException, IOException {

        response.setDateHeader("Last-Modified", System.currentTimeMillis());
        response.setHeader("Cache-Control", "private, no-cache, no-store, must-revalidate");

        String[] allowedUrl = settings.get("ywc.proxy.allowed_domains").split("\\,");
        String remoteUrl = uri.split("/url/")[1];

        if (remoteUrl != null && !"".equals(remoteUrl) && allowedUrl != null) {
            for (int i = 0; i < allowedUrl.length; i++) {

                if (remoteUrl.indexOf(allowedUrl[i]) != -1) {
                    //System.out.println("grab http://" + remoteUrl);

                    URL oURL = new URL("http://" + remoteUrl);
                    URLConnection oConnection = oURL.openConnection();
                    BufferedReader in = new BufferedReader(
                            new InputStreamReader(
                            oConnection.getInputStream()));
                    String inputLine;
                    response.setContentType(oConnection.getContentType());
                    String contentType = oConnection.getContentType();
                    int contentLength = oConnection.getContentLength();

                    if (contentType.startsWith("text/") || contentLength == -1) {
                        PrintWriter out = response.getWriter();
                        while ((inputLine = in.readLine()) != null) {
                            out.println(inputLine);
                        }
                        in.close();

                    } else {
                        OutputStream out = response.getOutputStream();
                        InputStream raw = oConnection.getInputStream();
                        InputStream input = new BufferedInputStream(raw);
                        byte[] data = new byte[contentLength];
                        int bytesRead = 0;
                        int offset = 0;
                        while (offset < contentLength) {
                            bytesRead = input.read(data, offset, data.length - offset);
                            if (bytesRead == -1) {
                                break;
                            }
                            offset += bytesRead;
                        }
                        in.close();

                        if (offset != contentLength) {
                            throw new IOException("Only read " + offset + " bytes; Expected " + contentLength + " bytes");
                        }

                        out.write(data);
                        out.flush();
                    }

                }
            }
        }

    }

    public static String xslRequestCachingInit() {
        String xslRequestCacheId = "";
        if (settings.enableXslRequestCaching()) {
            xslRequestCacheId = ywc.core.str.basicId(10);
            new File(settings.getPathYwcCache() + "/tmp/xml/" + xslRequestCacheId).mkdir();
        }
        return xslRequestCacheId;
    }

    public static HashMap xslRequestCachingParam(String xslRequestCacheId, String mcHash, HashMap paramObj) {
        String filePath = "";
        if (settings.enableXslRequestCaching()) {
            filePath = settings.getPathYwcCache() + "/tmp/xml/" + xslRequestCacheId;
        }
        paramObj.put("cache_path", filePath+"---" + mcHash);
        return paramObj;
    }

    public static void xslRequestCachingCleanup(String xslRequestCacheId) {
        try {
            if (settings.enableXslRequestCaching()) {
                filesystem.delete((new File(settings.getPathYwcCache() + "/tmp/xml/" + xslRequestCacheId)));
            }
        } catch (IOException ex) {
            logger.warn(ex);
        }
    }
}
