/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.core;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 *
 * @author topher
 */
public class conv {

    public static int daysToSecs(Double days) {

        return (new Double(days * 86400)).intValue();

        //    return (new Double (""+(days*86400*1000))).floatValue();
    }

    
    public static String escXml(String input_string) {
        return input_string.
                replaceAll("&", "&amp;").
                replaceAll("<", "&lt;").
                replaceAll(">", "&gt;").
                replaceAll("\"", "&quot;");
    }
    
    public static String unEscXml(String input_string) {
        return input_string.
                replaceAll("&amp;", "&").
                replaceAll("&lt;", "<").
                replaceAll("&gt;", ">").
                replaceAll("&quot;", "\"");
    }
    
    public static String objToXml(String nodeName, ArrayList dbObj) {
        
        String allRows = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n<ywc>";
        
        Integer buildXml = 0;
        if (dbObj.size() == 1) {
            HashMap dbRow = (HashMap) dbObj.get(0);
            Iterator it = dbRow.entrySet().iterator();
            String strError = "\n<error";
            while (it.hasNext()) {
                Map.Entry pairs = (Map.Entry) it.next();
                if ("error".equals(pairs.getKey().toString())) {
                    strError += " type=\""+conv.escXml(pairs.getValue().toString())+"\"";
                    buildXml++;
                //} else if ("query".equals(pairs.getKey().toString())) {
                //    strError += " query=\""+conv.escXml(pairs.getValue().toString())+"\"";
                //    buildXml++;
                } else if ("success".equals(pairs.getKey().toString()) && "false".equals(pairs.getValue().toString())) {
                    buildXml++;
                }
            }
            if (buildXml == 2) {
                allRows += strError+" />";
            }
        }
        
        if (buildXml < 2) {
            for (int i = 0; i < dbObj.size(); i++) {

                HashMap dbRow = (HashMap) dbObj.get(i);
                String thisRow = "\n<" + nodeName;
                String nonKeys = "";

                Iterator it = dbRow.entrySet().iterator();
                while (it.hasNext()) {
                    Map.Entry pairs = (Map.Entry) it.next();
                    if (pairs.getKey().toString() == null ? (nodeName + "_id") == null : pairs.getKey().toString().equals(nodeName + "_id")) {
                        thisRow += " " + conv.escXml(pairs.getKey().toString()) + "=\"" + conv.escXml(pairs.getValue().toString()) + "\"";
                    } else {
                        if (!"text".equals(conv.escXml(pairs.getKey().toString()))) {
                            nonKeys += " " + conv.escXml(pairs.getKey().toString()) + "=\"" + conv.escXml(pairs.getValue().toString()) + "\"";
                        }
                    }
                }

                allRows += thisRow + nonKeys + " />";
            }
        }
        
        allRows += "\n</ywc>";


        return allRows;
    }
}
