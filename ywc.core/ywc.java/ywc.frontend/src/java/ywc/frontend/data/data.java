/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.frontend.data;

import java.util.HashMap;
import ywc.core.julian;
import ywc.core.settings;

/**
 *
 * @author topher
 */
public class data {

    public static Boolean createAsset(String assetType, HashMap assetAttr) throws Exception {
        Boolean rtrnVal = false;

        String saveEnv = settings.getMediaDatabaseMethod();

        String mediaId = "aaaaaa";
        if (assetAttr.get("media_id") != null) {
            mediaId = "" + assetAttr.get("media_id");
        }

        String userId = "aaaaaa";
        if (assetAttr.get("user_id") != null) {
            userId = "" + assetAttr.get("user_id");
        }

        String fileName = "file.jpg";
        if (assetAttr.get("name") != null) {
            fileName = "" + assetAttr.get("name");
        }

        String fileExt = "jpg";
        if (assetAttr.get("ext") != null) {
            fileExt = "" + assetAttr.get("ext");
        }

        if ("ywc".equals(saveEnv)) {

            double tm = (new julian()).julianDay();
            String tmStr = "" + tm;

            ywc.core.query.exec("INSERT INTO data_media ("
                    + "media_id,created_user,modified_user,created_time,modified_time,orig_format,orig_filename"
                    + ") VALUES (?,?,?,?,?,?,?)", new String[]{mediaId, userId, userId, tmStr, tmStr, fileExt, fileName});
            
            rtrnVal = true;

        } else if ("enthuse".equals(saveEnv)) {
        } else {
        }


        return rtrnVal;
    }

    public static String generateAssetId(String assetType, HashMap inputParams) {
        String rtrnVal = "";

        String saveEnv = settings.getMediaDatabaseMethod();

        if ("ywc".equals(saveEnv)) {
            rtrnVal = ywc.core.query.genId(assetType, 32);

        } else if ("enthuse".equals(saveEnv)) {
        } else {
        }

        return rtrnVal;
    }
}
