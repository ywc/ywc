/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import ywc.core.data;
import ywc.core.mccon;
import ywc.core.query;
import ywc.model.CacheEntry;


/**
 *
 * @author jd
 */
public class CacheDAO {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(CacheDAO.class);
    
    public static CacheEntry getCacheEntry(String cacheID) {
        ArrayList entries = new ArrayList();
        ArrayList quRows = query.exec("SELECT * FROM data_cache WHERE cache_id=?", new String[]{cacheID});
        if (quRows != null && quRows.size() > 0) {
            for (int i=0; i<quRows.size(); i++) {
                HashMap row = (HashMap) quRows.get(i);
                CacheEntry entry = new CacheEntry(row.get("cache_id").toString(),
                                                    row.get("title").toString(),
                                                    row.get("name").toString(),
                                          //          Double.parseDouble(row.get("created_time").toString()), 
                                          //          Double.parseDouble(row.get("modified_time").toString()), 
                                          //          row.get("created_user").toString(), 
                                          //          row.get("modified_user").toString(), 
                                                    row.get("type").toString(), row.get("url").toString(), 
                                                    row.get("properties").toString(), row.get("params").toString(),
                                                    Double.parseDouble(row.get("last_updated").toString()), 
                                                    Integer.parseInt(row.get("count_updated").toString()));
                
                return entry;
                
            }
            
        }
        return null;
    }
    public static ArrayList getCacheEntries() {
        
        ArrayList entries = new ArrayList();
        ArrayList quRows = query.exec("SELECT * FROM data_cache", new String[]{});
        if (quRows != null && quRows.size() > 0) {
            for (int i=0; i<quRows.size(); i++) {
                HashMap row = (HashMap) quRows.get(i);
                CacheEntry entry = new CacheEntry(row.get("cache_id").toString(),
                                                    row.get("title").toString(),
                                                    row.get("name").toString(),
                                       //             Double.parseDouble(row.get("created_time").toString()), 
                                       //             Double.parseDouble(row.get("modified_time").toString()), 
                                       //             row.get("created_user").toString(), 
                                       //             row.get("modified_user").toString(), 
                                                    row.get("type").toString(), row.get("url").toString(), 
                                                    row.get("properties").toString(), row.get("params").toString(),
                                                    Double.parseDouble(row.get("last_updated").toString()), 
                                                    Integer.parseInt(row.get("count_updated").toString()));
                
                entries.add(entry);
                
            }
            
        }
        return entries;
    }
    public static Boolean updateCacheEntry(CacheEntry obj, String id) {
        return true;
    }
    
    public static boolean refreshCache(String cacheID) {
        
        CacheEntry entry = getCacheEntry(cacheID);
        if (entry != null) {
            if (entry.properties.containsKey("destination") && entry.properties.get("destination").toString().equals("drupal")) {
                DrupalDAO drupal = new DrupalDAO();
                if (drupal.login()) {
                    entry.properties.put("Cookie", drupal.getCookie());

                    String cacheData = data.retrieve(entry);
                    if (cacheData != null) {
                        if (!data.isCacheUpToDate(entry, cacheData)) {
                            logger.info("Cache updated for " + entry.url);
                            data.cache(entry, cacheData);
                            mccon.mc.flushAll();
                            return true;

                        } else {
                            //System.out.println("\tno_update_needed");
                        }
                    } else {
                        logger.warn("Update cache of " + entry.url + " failed");
                    }
                    drupal.logoff();
                }

            } else {

                String cacheData = data.retrieve(entry);
                if (cacheData != null) {
                    if (!data.isCacheUpToDate(entry, cacheData)) {
                        logger.info("Cache updated for " + entry.url);
                        data.cache(entry, cacheData);
                        mccon.mc.flushAll();
                        return true;
                        
                    } else {
                        //Logger.getLogger(data.class.getName()).log(Level.INFO, "Updated cache of {0} success", entry.url);
                    }
                } else {
                    logger.warn("Update cache of " + entry.url + " failed");
                }
            }
            
        }
        return false;
    }
    
}
