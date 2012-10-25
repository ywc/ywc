/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.backend.ingest;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import ywc.core.*;
import ywc.backend.data.xml;

/**
 *
 * @author topher
 */
public class ingest {

    public static void ingest() throws Exception {

        long startTime = System.currentTimeMillis();

        System.out.println("beginning media ingestion");

        while ((System.currentTimeMillis() - startTime) < 50000) {

            System.out.println("\tthis thread has been running for " + Math.round((System.currentTimeMillis() - startTime) / 1000) + " seconds)");

            System.out.println("checking media ingestion queue");

            ArrayList quRows = query.exec("SELECT * FROM queue_ingest_media WHERE in_progress=0 ORDER BY queued_time LIMIT 10", new String[]{});

            System.out.println("found " + quRows.size() + " media items to ingest");

            for (int i = 0; i < quRows.size(); i++) {

                if ((System.currentTimeMillis() - startTime) < 55000) {
                    HashMap quRow = (HashMap) quRows.get(i);

                    ArrayList quThisRow = query.exec("SELECT * FROM queue_ingest_media WHERE rank=? LIMIT 1", new String[]{(String) quRow.get((String) "rank")});
                    if (quThisRow.size() > 0) {
                        HashMap quThisRow_ = (HashMap) quRows.get(0);
                        String in_progress = (String) quThisRow_.get((String) "in_progress");

                        if ("0".equals(in_progress)) {

                            String media_id = (String) quRow.get((String) "media_id");
                            String ext = (String) quRow.get((String) "format");

                            System.out.println("#" + (i + 1) + ") " + media_id + "." + ext + "");

                            query.exec("UPDATE queue_ingest_media SET in_progress=?, start_time=? WHERE rank=?", new String[]{"" + 1, "" + (new julian()).julianDay(), (String) quRow.get((String) "rank")});

                            if (ywc.ingest.cdn.mediaExists(media_id, ext, "orig",null)) {

                                String[] ingestProperties = ywc.ingest.ingest.docProperties(ext);
                                System.out.println("method: " + ingestProperties[0]);

                                String[] ingestFeedback = ywc.ingest.ingest.ingestMedia(ingestProperties, media_id);


                                if (ywc.ingest.ingest.ingestSuccess(ingestFeedback)) {
                                    try {
                                        query.exec("INSERT INTO queue_ingest_media_archive (media_id,queued_time,ingested_time,format,success,attempts) VALUES (?,?,?,?,?,?)", new String[]{media_id, (String) quRow.get((String) "queued_time"), "" + (new julian()).julianDay(), ext, "1", "1"});
                                        query.exec("DELETE FROM queue_ingest_media WHERE rank=?", new String[]{(String) quRow.get((String) "rank")});
                                        query.exec("UPDATE data_media SET modified_time=?, ingested_time=?, active=?, duration=?, type=? WHERE media_id=?", new String[]{"" + (new julian()).julianDay(), "" + (new julian()).julianDay(), "1", ingestFeedback[0], ingestProperties[1], media_id});
                                        xml.cacheDataType("media",settings.getPathYwcCache() + "/xml/data/","");
                                    } catch (Exception ex) {
                                        Logger.getLogger(ingest.class.getName()).log(Level.SEVERE, null, ex);
                                    }
                                } else {
                                    try {
                                        query.exec("UPDATE queue_ingest_media SET attempts=attempts+1, in_progress=0 WHERE rank=?", new String[]{(String) quRow.get((String) "rank")});
                                    } catch (Exception ex) {
                                        Logger.getLogger(ingest.class.getName()).log(Level.SEVERE, null, ex);
                                    }
                                }
                            } else {
                                System.out.println("failed to move orig into place");
                                try {
                                    query.exec("INSERT INTO queue_ingest_media_archive (media_id,queued_time,ingested_time,format,success,attempts) VALUES (?,?,?,?,?,?)", new String[]{media_id, (String) quRow.get((String) "queued_time"), "" + (new julian()).julianDay(), ext, "0", "1"});
                                    query.exec("DELETE FROM queue_ingest_media WHERE rank=?", new String[]{(String) quRow.get((String) "rank")});
                                    query.exec("DELETE FROM data_media WHERE media_id=?", new String[]{media_id});
                                } catch (Exception ex) {
                                    Logger.getLogger(ingest.class.getName()).log(Level.SEVERE, null, ex);
                                }
                            }
                            /*} else {
                            System.out.println("file not found");
                            try {
                            query.exec("INSERT INTO queue_ingest_media_archive (media_id,queued_time,ingested_time,format,success,attempts) VALUES (?,?,?,?,?,?)", new String[]{media_id, (String) quRow.get((String) "queued_time"), "" + (new julian()).julianDay(), ext, "0", "1"});
                            query.exec("DELETE FROM queue_ingest_media WHERE rank=?", new String[]{(String) quRow.get((String) "rank")});
                            query.exec("DELETE FROM data_media WHERE media_id=?", new String[]{media_id});
                            } catch (Exception ex) {
                            Logger.getLogger(ingest.class.getName()).log(Level.SEVERE, null, ex);
                            }
                            }*/
                        }
                    }
                }
            }
            System.out.println("\twaiting 5 seconds before next repetition");
            Thread.sleep(5000);
        }
    }

    
}
