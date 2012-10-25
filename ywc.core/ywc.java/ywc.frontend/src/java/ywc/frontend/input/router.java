/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.frontend.input;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author topher
 */
public class router extends HttpServlet {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(router.class);
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control", "private, no-cache");

        String action = request.getRequestURI().substring(5);
        
        PrintWriter out = response.getWriter();
        try {
            if ("file".equals(action)) {
                ywc.frontend.input.upload.processUpload(out, request, response);
            } else {
                out.println("'"+action+"' is not a valid option");
            }
        
        }
        catch (Exception ex) {
            logger.warn(ex);
//            System.out.println(ex.getMessage());
       
        }  finally {

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