/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.backend.d;

import java.util.logging.Level;
import java.util.logging.Logger;
import ywc.core.settings;
import ywc.core.xslt;

/**
 *
 * @author topher
 */
public class BuildCoreXml {
    
    public static void main(String[] args) {
        
        System.out.println("building ywc core db xml files");

        try {

            Boolean outVal = false;
            String typeList = xslt.exec(settings.getPathYwcCoreData() + "xml/core/datatypes.xml", settings.getPathYwcCoreData() + "xsl/core/router/datatypes.xsl", null, null, null);

            String[] lines = typeList.split("\\r?\\n");
            if (lines.length > 0) {
                for (int i = 0; i < lines.length; i++) {
                    ywc.backend.data.xml.cacheDataType(lines[i],settings.getPathYwcCoreData()+"xml/data/","ywccore.");
                }
                outVal = true;
            }


        } catch (Exception ex) {
            Logger.getLogger(BackEndD.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
    
}
