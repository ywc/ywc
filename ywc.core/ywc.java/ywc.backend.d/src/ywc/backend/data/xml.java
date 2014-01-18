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

    public static Boolean cacheAllDataTypes(String destinationDirectory) {
        Boolean rtrn = false;
        String pathCore = settings.getPathYwcCoreData();
        String pathCache = settings.getPathYwcCache();
        try {
            String typeList = xslt.exec(pathCore + "xml/core/datatypes.xml", pathCore + "xsl/core/router/datatypes.xsl", null, null, null);
            String[] lines = typeList.split("\\r?\\n");
            if (lines.length > 0) {
                for (int i = 0; i < lines.length; i++) {
                    cacheDataType(lines[i], pathCore + "xml/data/", "ywccore.");
                    cacheDataType(lines[i], pathCache + "/xml/data/", "");
                }
                rtrn = true;
            }
        } catch (Exception ex) {
            logger.warn(ex);
        }
        return rtrn;
    }

    public static Boolean cacheDataType(String dataType, String destinationDirectory, String databasePrefix) {
        Boolean rtrn = false;
        ArrayList quRows = query.exec("SELECT * FROM " + databasePrefix + "data_" + dataType + " ORDER BY " + dataType + "_id", new String[]{});
        String outXml = conv.objToXml(dataType, quRows);
        int rowCnt = -1;
        try {
            ArrayList quNumRows = query.exec("SELECT COUNT(*) AS numRows FROM " + databasePrefix + "data_" + dataType, new String[]{});
            rowCnt = Integer.parseInt((String) ((HashMap) quNumRows.get(0)).get("numRows"));
        } catch (Exception e) {
            logger.warn(e);
        }
        if (rowCnt >= 0) {
            FileWriter outFile;
            try {
                outFile = new FileWriter(new File(destinationDirectory + dataType + ".xml"));
                PrintWriter writeXml = new PrintWriter(outFile);
                writeXml.println(outXml);
                writeXml.close();
                if (filesystem.fileExists(destinationDirectory + dataType + ".xml")) {
                    rtrn = true;
                }
            } catch (IOException ex) {
                logger.warn(ex);
            }
            if (rtrn) {
                logger.info("Cache " + dataType + " success");
            } else {
                logger.warn("Cache " + dataType + " failure");
            }
        } else {
            logger.info("Cache " + dataType + " skipped");
        }
        return rtrn;
    }
}
