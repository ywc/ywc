/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.ingest;

import java.util.HashMap;
import ywc.core.julian;

/**
 *
 * @author topher
 */
public class queue {

    public static Boolean addItem(String media_id, String ext) throws Exception {
        Boolean rtrn = false;
        double tm = (new julian()).julianDay();
        String tmStr = ""+tm;
        
        ywc.core.query.exec("INSERT INTO queue_ingest_media ("
                + "media_id,queued_time,format"
                + ") VALUES (?,?,?)", new String[]{media_id, tmStr, ext});
        rtrn = true;
        
        return rtrn;
    }

    public static Boolean dropItem(String media_id, String ext, String queued_time) throws Exception {
        Boolean rtrn = false;

        double tm = (new julian()).julianDay();

        ywc.core.query.exec("INSERT INTO queue_ingest_media_archive"
                + " (media_id,queued_time,ingested_time,format,success,attempts)"
                + " VALUES (?,?,?,?,?,?)", new String[]{media_id, queued_time, "" + tm, ext, "1", "1"});


        return rtrn;
    }

    public static HashMap getItem(String media_id) {
        HashMap rtrnObj = new HashMap();

      /*  ArrayList quRow = ywc.core.query.exec("SELECT * FROM queue_ingest_media WHERE media_id=? LIMIT 1", new String[]{media_id});
        if (quRow.size() > 0) {
            HashMap quThisRow = (HashMap) quRows.get(0);

            if ("0".equals(in_progress)) {
            }
*/
            return rtrnObj;
        }

    }
