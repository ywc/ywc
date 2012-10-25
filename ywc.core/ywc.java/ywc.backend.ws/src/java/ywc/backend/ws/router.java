/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.backend.ws;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import ywc.core.query;

/**
 *
 * @author jd
 */
@WebServlet(name = "router", urlPatterns = {"/router"})
public class router extends HttpServlet {
    private static final Logger logger = Logger.getLogger(router.class);
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "private, no-cache");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/xml");

        PrintWriter out = response.getWriter();
        int lastModified = 1111111111;
        String output = "";
        Boolean isOK = false;
        try {
            long queryStart = System.currentTimeMillis();
            String call = request.getRequestURI().split("/bws")[1];


            if (call != null && !"".equals(call)) {

                if (call.startsWith("/get/")) {

                    String asset_full = call.split("/get/")[1];
                    String asset_db = asset_full;
                    String asset_name = asset_full;

                    String strQuery = "SELECT ";

                    //distinct
                    String strDistinct = request.getParameter("distinct");
                    if (strDistinct != null && !"".equals(strDistinct)) {
                        strQuery += " DISTINCT ";
                    }

                    strQuery += " * FROM data_" + asset_name;
                    String[] strQueryParam = null;
                    
                    ArrayList<String> aQueryParam = new ArrayList<String>();
                    
                     //join clause
                    String strJoin = request.getParameter("join");
                    if (strJoin != null && !"".equals(strJoin)) {
    
                        strQuery += " JOIN " + strJoin.split("\\,")[0] 
                                + " ON " + strJoin.split("\\,")[1] 
                                + " = " + strJoin.split("\\,")[2]
                                + " ";
                    }
                    
                    //where clause
                    String strWhere = request.getParameter("where");
                    if (strWhere != null && !"".equals(strWhere)) {
    
                        String[] aWhere = strWhere.split("\\s(OR|AND)\\s");

                        for (int i = 0; i < aWhere.length; i++) {
                            String strWhereOper = "";
                            if (i < aWhere.length - 1) {
                                strWhereOper = strWhere.split(aWhere[i])[1].split(aWhere[i + 1])[0];
                            }

                            String[] aWhere2 = aWhere[i].split("(=|<|>|<=|=>|IN|LIKE)");
                            String strCol = aWhere2[0];
                            String strVal = aWhere2[1];
                            String strOper = aWhere[i].split(strCol)[1].split(strVal)[0];

                            if (i == 0) {
                                strQuery += " WHERE ";
                            }
                            strQuery += " " + strCol + strOper + "? " + strWhereOper;
                            aQueryParam.add(strVal);

                        }
                        strQueryParam = aQueryParam.toArray(new String[aQueryParam.size()]);

                    }

                    //orderby+limit
                    String strOrderBy = request.getParameter("orderby");
                    if (strOrderBy != null && !"".equals(strOrderBy)) {
                        strQuery += " ORDER BY " + strOrderBy;
                    }

                    String strLimit = request.getParameter("limit");
                    if (strLimit != null && !"".equals(strLimit)) {
                        strQuery += " LIMIT " + strLimit;
                    }

                    


                    ArrayList quRtrn = query.exec(
                            strQuery,
                            strQueryParam);

                    output += ywc.core.conv.objToXml(asset_name, quRtrn);

                    isOK = true;

                } else if (call.startsWith("/update/")) {

                    String asset_full = call.split("/update/")[1];
                    String asset_db = asset_full;
                    String asset_name = asset_full;

                    String strQuery = "UPDATE data_" + asset_name + " SET ";

                    String[] strQueryParam = null;

                    //set clause
                    String strSet = request.getParameter("set");
                    String strWhere = request.getParameter("where");
                    if (strSet != null && !"".equals(strSet)
                            && strWhere != null && !"".equals(strWhere)) {

                        ArrayList<String> aQueryParam = new ArrayList<String>();

                        String[] aSet = strSet.split("\\,");

                        for (int i = 0; i < aSet.length; i++) {

                            String[] aSet2 = aSet[i].split("=");
                            String strCol = aSet2[0];
                            String strVal = aSet2[1];

                            if (i > 0) {
                                strQuery += ",";
                            }
                            strQuery += " " + strCol + "=? ";
                            aQueryParam.add(strVal);

                        }

                        //where clause
                        String[] aWhere = strWhere.split("\\s(OR|AND)\\s");

                        for (int i = 0; i < aWhere.length; i++) {
                            String strWhereOper = "";
                            if (i < aWhere.length - 1) {
                                strWhereOper = strWhere.split(aWhere[i])[1].split(aWhere[i + 1])[0];
                            }

                            String[] aWhere2 = aWhere[i].split("(=|<|>|<=|=>|IN|LIKE)");
                            String strCol = aWhere2[0];
                            String strVal = aWhere2[1];
                            String strOper = aWhere[i].split(strCol)[1].split(strVal)[0];

                            if (i == 0) {
                                strQuery += " WHERE ";
                            }
                            strQuery += " " + strCol + strOper + "? " + strWhereOper;
                            aQueryParam.add(strVal);

                        }
                        strQueryParam = aQueryParam.toArray(new String[aQueryParam.size()]);


                        ArrayList quRtrn = query.exec(
                                strQuery,
                                strQueryParam);

                        output += ywc.core.conv.objToXml(asset_name, quRtrn);
                    }



                } else if (call.startsWith("/assoc/")) {

                    String assetFull = call.split("/assoc/")[1];
                    String assetNameParent = assetFull.split("/")[0];
                    String assetIDParent = assetFull.split("/")[1];
                    String assetID = request.getParameter("asset_id");
                    String assetType = request.getParameter("asset_type");

                    String strQuery = "INSERT INTO assoc_" + assetNameParent + "(" + assetNameParent + "_id,asset_type,asset_id) VALUES (?,?,?)";
                    String[] strQueryParam = null;
                    ArrayList aQueryParam = new ArrayList();
                    aQueryParam.add(assetIDParent);
                    aQueryParam.add(assetType);
                    aQueryParam.add(assetID);
                    strQueryParam = (String[]) aQueryParam.toArray(new String[aQueryParam.size()]);

                    ArrayList quRtrn = query.exec( strQuery, strQueryParam );

                    output += ywc.core.conv.objToXml(assetNameParent, quRtrn);
                
                } else if (call.startsWith("/disassoc/")) {

                    String assetFull = call.split("/disassoc/")[1];
                    String assetNameParent = assetFull.split("/")[0];
                    String assetIDParent = assetFull.split("/")[1];
                    String assetID = request.getParameter("asset_id");
                    String assetType = request.getParameter("asset_type");

                    String strQuery = "DELETE FROM assoc_" + assetNameParent + " WHERE "+ assetNameParent + "_id=? AND asset_type=? AND asset_id=?";
                    String[] strQueryParam = null;
                    ArrayList aQueryParam = new ArrayList();
                    aQueryParam.add(assetIDParent);
                    aQueryParam.add(assetType);
                    aQueryParam.add(assetID);
                    strQueryParam = (String[]) aQueryParam.toArray(new String[aQueryParam.size()]);

                    ArrayList quRtrn = query.exec( strQuery, strQueryParam );

                    output += ywc.core.conv.objToXml(assetNameParent, quRtrn);
                
                } else if (call.startsWith("/delete/")) {

                    String asset_full = call.split("/delete/")[1];
                    String asset_name = asset_full;

                    String strQuery = "DELETE FROM data_" + asset_name + " WHERE ";

                    String[] strQueryParam = null;

                    String strWhere = request.getParameter("where");
                    if (strWhere != null && !"".equals(strWhere)) {

                        ArrayList<String> aQueryParam = new ArrayList<String>();
                        //where clause
                        String[] aWhere = strWhere.split("\\s(OR|AND)\\s");

                        for (int i = 0; i < aWhere.length; i++) {
                            String strWhereOper = "";
                            if (i < aWhere.length - 1) {
                                strWhereOper = strWhere.split(aWhere[i])[1].split(aWhere[i + 1])[0];
                            }

                            String[] aWhere2 = aWhere[i].split("(=|<|>|<=|=>|IN|LIKE)");
                            String strCol = aWhere2[0];
                            String strVal = aWhere2[1];
                            String strOper = aWhere[i].split(strCol)[1].split(strVal)[0];

                            strQuery += " " + strCol + strOper + "? " + strWhereOper;
                            aQueryParam.add(strVal);

                        }
                        strQueryParam = aQueryParam.toArray(new String[aQueryParam.size()]);


                        ArrayList quRtrn = query.exec( strQuery, strQueryParam );

                        output += ywc.core.conv.objToXml(asset_name, quRtrn);
                    }



                } else if (call.startsWith("/add/")) {

                    String asset_full = call.split("/add/")[1];
                    String asset_name = asset_full;

                    String strQuery = "INSERT INTO data_" + asset_name + " (";

                    String[] strQueryParam = null;

                    //set clause
                    String strSet = request.getParameter("set");
                    if (strSet != null && !"".equals(strSet)) {

                        ArrayList<String> aQueryParam = new ArrayList<String>();

                        String[] aSet = strSet.split("\\|\\|");
                        String strValueMark = "";
                        for (int i = 0; i < aSet.length; i++) {

                            String[] aSet2 = aSet[i].split("=");
                            String strCol = aSet2[0];
                            String strVal = aSet2[1];

                            if (i > 0) {
                                strQuery += ", ";
                                strValueMark += ", ";
                            }
                            
                            strQuery += "" + strCol + "";
                            strValueMark += "?";
                            
                            aQueryParam.add(strVal);

                        }
                        
                        strQuery += "," + asset_name + "_id) VALUES (" + strValueMark + ",?)";
                        
                        aQueryParam.add(query.genId(asset_name, 6));
                        
                        strQueryParam = aQueryParam.toArray(new String[aQueryParam.size()]);

                        ArrayList quRtrn = query.exec( strQuery, strQueryParam );

                        output += ywc.core.conv.objToXml(asset_name, quRtrn);
                    }

                } 

            }
            
            out.print(output);

            long queryEnd = System.currentTimeMillis();
            logger.debug("call - " + call + " - " + (queryEnd - queryStart) + "ms");

        } finally {

            out.close();
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
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
     * Handles the HTTP <code>POST</code> method.
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

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
