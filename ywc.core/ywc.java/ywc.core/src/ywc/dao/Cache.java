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
public class Cache {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(Cache.class);
    
    public static CacheEntry getCacheEntry(String cacheID) {
        ArrayList entries = new ArrayList();
        ArrayList quRows = query.exec("SELECT * FROM data_cache WHERE cache_id=?", new String[]{cacheID});
        if (quRows != null && quRows.size() > 0) {
            for (int i=0; i<quRows.size(); i++) {
                HashMap row = (HashMap) quRows.get(i);
                CacheEntry entry = new CacheEntry(row.get("cache_id").toString(),
                                                    row.get("title").toString(), row.get("name").toString(),
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
                                                    row.get("title").toString(), row.get("name").toString(),
                                                    row.get("type").toString(), row.get("url").toString(), 
                                                    row.get("properties").toString(), row.get("params").toString(),
                                                    Double.parseDouble(row.get("last_updated").toString()), 
                                                    Integer.parseInt(row.get("count_updated").toString()));
                entries.add(entry);
                
            }
            
        }
        return entries;
    }
    
    // this method clearly does nothing... why is it here?
    public static Boolean updateCacheEntry(CacheEntry obj, String id) {
        return true;
    }
    
    public static boolean refreshCache(String cacheID) {
        return refreshCache(getCacheEntry(cacheID));
    }
    
    
    public static boolean refreshCache(CacheEntry entry) {
        boolean rtrn = false;
        String cacheData;
        if (entry != null) {
            if ("http".equals(entry.type)) {
                if (entry.properties.containsKey("destination") && entry.properties.get("destination").toString().equals("drupal")) {
                    Drupal drupal = new Drupal();
                    if (entry.properties.containsKey("drupalEndpoint")) {
                        drupal.overrideDrupalSetup(entry.properties.get("drupalEndpoint").toString(),
                                entry.properties.get("drupalUser").toString(),
                                entry.properties.get("drupalPass").toString());
                    }
                    if (drupal.validLogin()) {
                        cacheData = data.requestHTTP(entry.url, drupal.getDrupalHeaders("GET"), entry.params);
                        if (data.isCacheUpToDate(entry, cacheData)) {
                           rtrn = true;
                        } else if (cacheData != null) {
                           data.cache(entry, cacheData);
                           rtrn = true;
                        }
                        drupal.doDrupalLogOff();
                    }
                } else {
                    cacheData = data.requestHTTP(entry.url, entry.properties, entry.params);
                    if ((cacheData != null) && !data.isCacheUpToDate(entry, cacheData)) {
                        data.cache(entry, cacheData);
                        rtrn = true;
                    } 
                }
            }

            if ("skip".equals(entry.type)) {
                logger.info("Cache update: Skipped -> " + entry.url);
                rtrn = true;
            } else if (!rtrn) {
                logger.warn("Cache update: Failure ->" + entry.url);
            } else {
                logger.info("Cache update: Success -> " + entry.url);
                mccon.mc.flushAll();
            }
        }
        return rtrn;
    }
}
