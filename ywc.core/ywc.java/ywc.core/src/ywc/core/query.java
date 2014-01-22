/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.core;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class query {

    public static ArrayList exec(String quStr, String[] quVars) {

        long queryStart = System.currentTimeMillis();
        Connection quCon = null;
        PreparedStatement quStatement = null;
        ResultSet quResultSet = null;
        int quRowCount = 0;
        HashMap quReturn = null;
        ArrayList rtrnObj = new ArrayList();

        try {

            String action = quStr.substring(0, 6).toUpperCase();
            if ((action.equals("SELECT")) && (quStr.indexOf(" LIMIT ") == -1)) {
                quStr += " LIMIT 999999";
            }

            quCon = query.getCon(quStr);

            String quPrefix = quStr.substring(0, quStr.indexOf("_")).substring(quStr.substring(0, quStr.indexOf("_")).lastIndexOf(" ") + 1);
            String quDb = "ywc" + settings.getYwcEnvApp();
            if (quPrefix.contains(".")) {
                quDb = quPrefix.substring(0, quPrefix.indexOf("."));
            }
            String quTable = quPrefix + "_" + quStr.substring(1 + quStr.indexOf("_")).substring(0, quStr.substring(1 + quStr.indexOf("_")).indexOf(" ")).replace(quDb + ".", "");
            quStr = quStr.replace(quDb + ".", "");

            if (quCon != null) {

                quStatement = quCon.prepareStatement(quStr);

                if ((quStr.indexOf("?") != -1) && (quVars != null)) {
                    for (int i = 0; i < quVars.length; i++) {
                        quStatement.setString(i + 1, quVars[i]);
                    }
                }

                //System.out.println("query: "+quStr/*+"\nQuery Values: "+ quVars.toString()*/);
                if (!action.equals("SELECT")) {

                    try {
                        quRowCount = quStatement.executeUpdate();
                    } catch (Exception ex) {
                        System.out.print(" query error: " + ex.toString());
                        try {
                            quCon.close();
                        } catch (Exception ex2) {
                        }
                    }

                    quReturn = new HashMap();
                    quReturn.put("success", true);
                    quReturn.put("affected", quRowCount);
                    quReturn.put("query", quStatement.toString());
                    rtrnObj.add(quReturn);

                } else {

                    try {
                        quResultSet = quStatement.executeQuery();
                    } catch (Exception ex) {
                        System.out.print(" query error: " + ex.toString());
                        try {
                            quCon.close();
                        } catch (Exception ex2) {
                        }
                    }

                    try {
                        ResultSetMetaData quResultMeta = quResultSet.getMetaData();
                        int quColumnCount = quResultMeta.getColumnCount();

                        while (quResultSet.next()) {
                            quReturn = new HashMap();
                            for (int i = 0; i < quColumnCount; i++) {
                                String colName = quResultMeta.getColumnName(i + 1);
                                quReturn.put(colName, quResultSet.getString(colName));
                                if (quResultSet.wasNull()) {
                                    quReturn.put(colName, null);
                                }
                            }
                            rtrnObj.add(quReturn);
                        }
                    } catch (Exception ex) {
                        System.out.print(" query error: " + ex.toString());
                        try {
                            quResultSet.close();
                            quStatement.close();
                            quCon.close();
                        } catch (Exception ex2) {
                        }
                    }
                    quResultSet.close();
                }

                long queryEnd = System.currentTimeMillis();

                quStatement.close();
                quCon.close();
            } else {

                quReturn = new HashMap();
                quReturn.put("success", false);
                quReturn.put("error", "no connection");
                quReturn.put("query", quStr);
                rtrnObj.add(quReturn);

            }

        } catch (SQLException ex) {
            System.out.print(" query error: " + ex.toString());
            try {
                quCon.close();
            } catch (Exception ex2) {
            }
        } catch (NullPointerException ex) {
            System.out.print(" query error: " + ex.toString());
            try {
                quCon.close();
            } catch (Exception ex2) {
            }
        }

        return rtrnObj;
    }

    public static Connection getCon(String quStr) throws SQLException {
        Connection con = null;

        try {
            Driver d = (Driver) Class.forName("org.sqlite.JDBC").newInstance();
            DriverManager.registerDriver(d);
            try {
                String quPrefix = quStr.substring(0, quStr.indexOf("_")).substring(quStr.substring(0, quStr.indexOf("_")).lastIndexOf(" ") + 1);
                String quDb = "ywc" + settings.getYwcEnvApp();
                if (quPrefix.contains(".")) {
                    quDb = quPrefix.substring(0, quPrefix.indexOf("."));
                }
                String quTable = quPrefix + "_" + quStr.substring(1 + quStr.indexOf("_")).substring(0, quStr.substring(1 + quStr.indexOf("_")).indexOf(" ")).replace(quDb + ".", "");
                String dbSubDir = (quDb.equals("ywccore")) ? "ywc" : settings.getYwcEnvApp();
                con = DriverManager.getConnection("jdbc:sqlite:" + settings.getYWCpath() + "/database/" + dbSubDir + "/" + quDb + ".sqlite3");
            } catch (SQLException e) {
                System.out.println("Error creating SQLite connection: " + e.toString());
            }
        } catch (Exception e) {
            System.out.println("Error loading SQLite database driver: " + e.toString());
        }

        return con;
    }
    
}
