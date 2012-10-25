/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.model;
import java.util.HashMap;

/**
 *
 * @author jd
 */
public class CacheEntry extends Asset{
    public String type;
    public String title;
    public String name;
    public String url;
    public HashMap properties;
    public HashMap params;
    public Double lastUpdated; //store the last time the cached was updated
    public int countUpdated; //store the number of time it was updated
    
    public CacheEntry(String pCacheID, String pTitle, String pName,
            //double pCreatedTime, double pModifiedTime, 
             //           String pCreatedUser, String pModifiedUser,
                        String pType, String pUrl, String pProperties, String pParams,
                        Double pLastUpdated, int pCountUpdated) {
        
        assetID = pCacheID;
        title = pTitle;
        name = pName;
        
 //       createdTime = pCreatedTime;
 //       modifiedTime = pModifiedTime;
 //       createdUser = pCreatedUser;
 //       modifiedUser = pModifiedUser;
        
        lastUpdated = pLastUpdated;
        countUpdated = pCountUpdated;
        
        
        type = pType;
        url = pUrl;
        
        properties = new HashMap();
        String aProps[] = pProperties.split("\\,");
        if (aProps != null && aProps.length > 0) {
            for (int i=0; i<aProps.length; i++) {
                if (aProps[i] != null && aProps[i].split("=").length == 2) {
                    properties.put(aProps[i].split("=")[0], aProps[i].split("=")[1]);
                }
                
            }
        }
        
        params = new HashMap();
        String aParams[] = pParams.split("\\,");
        if (aParams != null && aParams.length > 0) {
            for (int i=0; i<aParams.length; i++) {
                if (aParams[i] != null && aParams[i].split("=").length == 2) {
                    params.put(aParams[i].split("=")[0], aParams[i].split("=")[1]);
                }
                
            }
        }
        
    }

}
