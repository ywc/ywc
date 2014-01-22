/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.backend.ws;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import ywc.core.data;
import ywc.core.settings;
import ywc.dao.Drupal;
import ywc.notification.Mail;

/**
 *
 * @author jd
 */
public class action extends HttpServlet {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(action.class);
    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "private, no-cache");
        response.setHeader("Content-Disposition", "inline; filename=\"files.json\"");
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        String output = null;
        Boolean isOK = true;
        String isOKMsg = "";
        try {

            String call = request.getRequestURI().split("/action/")[1];
            logger.debug(request.getRequestURI());

            if (call == null || "".equals(call)) {
                isOK = false;
                isOKMsg = "missing asset or parameters";

            } else if (call.equals("sendmail")) {
                String to = request.getParameter("to");
                String subject = request.getParameter("subject");
                String url = request.getParameter("url");

                
                if (subject.contains("http://") || subject.contains("https://")) {
                    subject = data.requestHTTP(subject, null, null);
                }
                
                if (to != null && subject != null && url != null) {
                    logger.info("Sendmail " + url + " to " + to);
                    
                    Mail mail = new Mail();
                    if (url.contains("http://") || url.contains("https://")) {
                        isOK = mail.sendMail(to, 
                                subject, 
                                data.requestHTTP(url, null, null), 
                                "text/html");
                    } else {
                        isOK = mail.sendMail(to, 
                                subject, 
                                data.requestHTTP(settings.get("ywc.url.noauth") + "/" + url, null, null), 
                                "text/html");
                    }
                            

                } else {
                    isOK = false;
                }

            } else if (call.startsWith("auth/check")) {
                
                isOK = true;
                response.setHeader("Content-Disposition", "");
                response.setContentType("text/html;charset=UTF-8");
                
                output = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
                +"\n<html xmlns=\"http://www.w3.org/1999/xhtml\">"
                +"\n<head>"
                +"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/>"
                +"<title>Redirecting...</title>"
                +"</head>"
                +"\n<body onLoad=\""
                 +"window.opener.setTimeout('ywcAuthCallback();',25);"
                +"window.close();\">Redirecting..."
                +"<span style=\"display:none;\">success</span>"
                +"</body>\n</html>";
                            
            } else if (call.startsWith("list/")) {
                String[] params = call.split("/");
                String asset = params[0];
                String listID = null;
                if (params.length > 1) {
                    listID = params[1];
                }

                String mail = request.getParameter("mail");

                if (listID != null && mail != null) {

                    if (request.getMethod().equals("GET")) {
                        //get my subscription
                        
                    } else if (request.getMethod().equals("POST")) {
                        logger.info("Subscribe user to list " + listID + " with mail " + mail);
                        
                        Drupal drupal = new Drupal();
                        if (!drupal.subscribeList(listID, mail)) {
                            isOK = false;
                        }
                        ywc.dao.Cache.refreshCache("aaaaaj"); //TODO better
                        

                    } else if (request.getMethod().equals("DELETE")) {
                        logger.info("Unsubscribe user from list " + listID + " with mail " + mail);
                        
                        Drupal drupal = new Drupal();
                        if (!drupal.unsubscribeList(listID, mail)) {
                            isOK = false;
                        }
                        ywc.dao.Cache.refreshCache("aaaaaj"); //TODO better
                        

                    }
                } else {
                    isOK = false;
                }

            } else {

                String[] params = call.split("/");
                String asset = params[0];
                String assetID = null;
                if (params.length > 1) {
                    assetID = params[1];
                }
                
                String dest = settings.getContentDest();
                if (dest != null && "drupal".equals(dest)) {

                    if (request.getMethod().equals("GET")) {

                        if (assetID == null) {
                            isOK = false;
                            isOKMsg = "missing_id";
                        } else {
                            Drupal drupal = new Drupal(asset);
                            //System.out.println(drupal.getNode(assetID));
                            output = drupal.getNode(assetID);
                        }

                    } else if (request.getMethod().equals("POST")) {

                        HashMap parameters = new HashMap();
                        Enumeration paramNames = request.getParameterNames();
                        while (paramNames.hasMoreElements()) {
                            String paramName = (String) paramNames.nextElement();
                            String[] paramValues = request.getParameterValues(paramName);
                            String paramValue = paramValues[0];
                            parameters.put(paramName, paramValue);
                        }
                        parameters.put("type", asset);

                        if (assetID != null) {
                            logger.info("Updating item " + asset + " nid:" + assetID);
                        } else {
                            logger.info("Creating item " + asset);
                        }
                        
                        Drupal drupal = new Drupal(asset);
                        String nid = drupal.updateNode(assetID, parameters);
                        if (nid != null) {
                            isOKMsg = nid;
                            logger.info("Item created successfully nid:" + nid);
                            
                            //refresh ywc cache
                            String cacheID = request.getParameter("ywc_cache_id");
                            if (cacheID != null && !"".equals(cacheID)) {
                                ywc.dao.Cache.refreshCache(cacheID);
                            }

                            //sendmail
                            if (assetID == null) {
                                logger.info("Inform subscribers for item nid:" + nid);
                                drupal.informSubscribers(nid, cacheID);
                            }

                        } else {
                            isOK = false;
                        }

                    } else if (request.getMethod().equals("DELETE")) {
                        
                        if (assetID == null || "".equals(assetID)) {
                            isOK = false;
                        } else {
                            logger.info("Deleting item " + asset + " nid:" + assetID);
                            
                            Drupal drupal = new Drupal(asset);
                            if (!drupal.deleteNode(assetID)) {
                                isOK = false;

                            }
                            //refresh ywc cache
                            String cacheID = request.getParameter("ywc_cache_id");
                            if (cacheID != null && !"".equals(cacheID)) {
                                ywc.dao.Cache.refreshCache(cacheID);
                            }
                            
                        }

                    }

                } else {
                    logger.warn("Unknown content destination");
                }
            }

        } finally {

            if (output == null) {
                ArrayList mapList = new ArrayList();
                HashMap map = new HashMap();
                if (isOK) {
                    map.put("status", "success");
                } else {
                    map.put("status", "failure");
                }

                map.put("msg", isOKMsg);
                mapList.add(map);
                out.println(ywc.core.str.rtrnJson(mapList));
            } else {
                out.println(output);
            }
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
