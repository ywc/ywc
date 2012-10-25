/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.core;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author topher
 */
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
            
            String DbEngine = settings.getDBEngine();
            
            if ("sqlite".equals(DbEngine)) {
                String quGrp = quStr.substring(0,quStr.indexOf("_")).substring(quStr.substring(0,quStr.indexOf("_")).lastIndexOf(" ")+1);
                String quDb = quStr.substring(1+quStr.indexOf("_")).substring(0,quStr.substring(1+quStr.indexOf("_")).indexOf(" "));
                quStr = quStr.replace(quGrp+"_"+quDb,quDb);
            }
            

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
        
        //if (settings.getProp("ywc.db.engine") == null) {throw XXException;}
        //need to create custom exception class 
        
        String engine = settings.getDBEngine();
        if (engine.equals("sqlite")) {
            String sqlite_path_absolute = "";
            sqlite_path_absolute = settings.getYWCpath() + "/" + settings.getDBPath();
            try {
                Driver d = (Driver) Class.forName("org.sqlite.JDBC").newInstance();
                DriverManager.registerDriver(d);
                try {
                   String quGrp = quStr.substring(0,quStr.indexOf("_")).substring(quStr.substring(0,quStr.indexOf("_")).lastIndexOf(" ")+1);
                    String quDb = quStr.substring(1+quStr.indexOf("_")).substring(0,quStr.substring(1+quStr.indexOf("_")).indexOf(" "));
                    con = DriverManager.getConnection("jdbc:sqlite:" + sqlite_path_absolute + "/" + quGrp + "/" +quDb + ".sqlite");
                } catch (SQLException e) {
                    System.out.println("Error creating SQLite connection: " + e.toString());
                }
            } catch (Exception e) {
                System.out.println("Error loading SQLite database driver: " + e.toString());
            }
        
        } else if (engine.equals("mysql")) {
           
            String url = "jdbc:mysql://"+settings.getDBHost()+":"+settings.getDBPort()+"/";
            String driver = "com.mysql.jdbc.Driver";
            try {
                Class.forName(driver).newInstance();
                con = DriverManager.getConnection(url + settings.getDBName(), settings.getDBUser(), settings.getDBPass());
                
            } catch (Exception e) {
                
            }
           
        } else if (engine.equals("sqlserver")) {
        
            String url = "jdbc:sqlserver://"+settings.getDBHost()+":"+settings.getDBPort();
            String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
            try {
                Class.forName(driver).newInstance();
                con = DriverManager.getConnection(url + ";databaseName="+settings.getDBName()+";user="+settings.getDBUser()+";password="+settings.getDBPass());
                
            } catch (Exception e) {
                
            }
        }
        return con;
    }

    public static String genId(String assetType, int len) {
        
        String id = "";
        Boolean is_unique = false;
        
        while (is_unique == false) {
            id = str.basicId(len);
    //        ArrayList qu = query.exec("SELECT * FROM data_" + assetType + " WHERE "+assetType+"_id=\""+id+"\"", new String[]{});
    //        if (qu.isEmpty()) {
                is_unique = true;
    //        }
        }
        return id;
    }
}
