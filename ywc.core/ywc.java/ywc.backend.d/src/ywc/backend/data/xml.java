/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.backend.data;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import ywc.core.*;

/**
 *
 * @author topher
 */
public class xml {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(xml.class);
    
    public static Boolean cycleThruDataTypes(String destinationDirectory) {
        Boolean outVal = false;
        try {
            String typeList = xslt.exec(settings.getPathYwcCoreData()+ "xml/core/datatypes.xml", settings.getPathYwcCoreData() + "xsl/core/router/datatypes.xsl", null, null, null);

            String[] lines = typeList.split("\\r?\\n");
            if (lines.length > 0) {
                for (int i=0; i < lines.length; i++) {
                    cacheDataType(lines[i],settings.getPathYwcCache() + "/xml/data/","");
                }
                outVal = true;
            }

        } catch (Exception ex) {
            logger.warn(ex);
        }

        return outVal;
    }

    public static Boolean cacheDataType(String dataType, String destinationDirectory, String databasePrefix) {

        Boolean writeSucc = false;
        
        ArrayList quRows = query.exec("SELECT * FROM "+databasePrefix+"data_"+dataType+" ORDER BY " + dataType + "_id", new String[]{});
        String outXml = conv.objToXml(dataType, quRows);
        
        int rowCnt = -1;
        try {
           ArrayList quNumRows = query.exec("SELECT COUNT(*) AS numRows FROM "+databasePrefix+"data_"+dataType, new String[]{});
            rowCnt = Integer.parseInt((String) ((HashMap) quNumRows.get(0)).get("numRows"));
        } catch (Exception e) {
            
        }
        if (rowCnt >= 0) {
        
            FileWriter outFile;
            try {
                outFile = new FileWriter(new File(destinationDirectory + dataType + ".xml"));
                PrintWriter writeXml = new PrintWriter(outFile);
                writeXml.println(outXml);
                writeXml.close();
                if (filesystem.fileExists(destinationDirectory + dataType + ".xml")) {
                    writeSucc = true;
                }
            } catch (IOException ex) {
                logger.warn(ex);
            }

            if (writeSucc) {
                logger.info("Cache " + dataType + " success");
            } else {
                logger.warn("Cache " + dataType + " failure");
            }

        } else {
            logger.info("Cache " + dataType + " skipped");
        }
        
        return writeSucc;
    }
}
