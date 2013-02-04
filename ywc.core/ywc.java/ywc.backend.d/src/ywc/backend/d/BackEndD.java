/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.backend.d;

import java.util.ArrayList;
import java.util.Map;
import ywc.backend.data.xml;
import ywc.backend.ingest.ingest;
import ywc.core.data;
import ywc.core.ldap;
import ywc.core.settings;
import ywc.core.xslt;
import ywc.dao.CacheDAO;
import ywc.dao.DrupalDAO;
import ywc.model.CacheEntry;

/**
 * @author topher
 */
public class BackEndD {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(BackEndD.class);
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        logger.info("Starting backend.d");
        
        try {

            if (settings.getYWCSiteName() != null) {

                String action = null;
                if (args.length > 0) {
                    action = args[0].toString();
                } else {
                    action = settings.getBackendDaemonProcesses();
                }
                
                if (action != null && !"".equals(action)) {

                    if (action.contains("xml_generate")) {
                        xml.cycleThruDataTypes(settings.getPathYwcCache() + "/xml/data/");
  
                        logger.info("Building ywc core db xml files");
                        
                        Boolean outVal = false;
                        String typeList = xslt.exec(settings.getPathYwcCoreData() + "xml/core/datatypes.xml", settings.getPathYwcCoreData() + "xsl/core/router/datatypes.xsl", null, null, null);

                        String[] lines = typeList.split("\\r?\\n");
                        if (lines.length > 0) {
                            for (int i = 0; i < lines.length; i++) {
                                ywc.backend.data.xml.cacheDataType(lines[i], settings.getPathYwcCoreData() + "xml/data/", "ywccore.");
                            }
                            outVal = true;
                        }
                    }

                    if (action.contains("uri_cache")) {
                        updateCache();
                    }

                    if (action.equals("ldap_import")) {
                        ldapImport();
                        //updateLdapCache();
                    }

                    if (action.equals("test_mail")) {
                        DrupalDAO drupal = new DrupalDAO();
                        drupal.informSubscribers("22", "aaaaaa");
                        //Mail mail = new Mail("smtp.free.fr", "25", "clear", "", "");
                        /*Mail mail = new Mail("smtp.gmail.com", "465", "tls", "ywcmailer@gmail.com", "2ThumbsUP!");
                        mail.sendMail("ywcmailer@gmail.com",
                                "delaplagnejd@gmail.com",
                                "Test Message",
                                data.requestHTTP("http://www.iter.org/buzz/item/marketplace/656", null, null),
                                "text/html");
                                * 
                                */
                    }

                    if (action.contains("ingest_media")) {
                        ingest.ingest();
                    }

                }


            }

        } catch (Exception ex) {
            logger.warn(ex);
        }
    }

    public static void updateCache() {

        ArrayList entries = CacheDAO.getCacheEntries();
        if (entries != null && entries.size() > 0) {
            for (int i = 0; i < entries.size(); i++) {
                CacheEntry entry = (CacheEntry) entries.get(i);
                logger.info("Caching " + entry.url);
                
                //check if entry.params include "dest" 
                if (entry.properties.containsKey("destination") && entry.properties.get("destination").toString().equals("drupal")) {
                    DrupalDAO drupal = new DrupalDAO();
                    
                    // override drupal endpoint
                    if (entry.properties.containsKey("drupalEndpoint")) {
                        logger.info("Override Drupal endpoint with " + entry.properties.get("drupalEndpoint"));
                        drupal.setEndpoint(entry.properties.get("drupalEndpoint").toString(), 
                                            entry.properties.get("drupalUser").toString(), 
                                            entry.properties.get("drupalPass").toString());
                    }
                    
                    if (drupal.login()) {
                        entry.properties.put("Cookie", drupal.getCookie());

                        String cacheData = data.retrieve(entry);
                        if (cacheData != null) {
                            if (!data.isCacheUpToDate(entry, cacheData)) {
//                                System.out.println("\tsuccess");
                                data.cache(entry, cacheData);

                                //update cache entry
                                entry.countUpdated++;

                            } else {
//                                System.out.println("\tno_update_needed");
                            }
                        } else {
                            logger.warn("Cache failed for " + entry.url);
                        }
                        drupal.logoff();
                    }

                } else {

                    String cacheData = data.retrieve(entry);
                    if (cacheData != null) {
                        if (!data.isCacheUpToDate(entry, cacheData)) {
//                            System.out.println("\tsuccess");
                            data.cache(entry, cacheData);

                            //update cache entry
                            entry.countUpdated++;

                        } else {
//                            System.out.println("\tno_update_needed");
                        }
                    } else {
                        logger.warn("Cache failed for " + entry.url);
                    }
                }
            }

        } else {
            logger.warn("No cache entry found");
        }
    }

    public static void ldapImport() {
        ldap ldap;
        if (settings.get("ywc.ldap.start_tls").equals("yes")) {
            ldap = new ldap(settings.get("ywc.ldap.domain"),
                    settings.get("ywc.ldap.url"),
                    true,
                    settings.get("ywc.ldap.userdn"),
                    settings.get("ywc.ldap.user"),
                    settings.get("ywc.ldap.pass"));


        } else {
            ldap = new ldap(settings.get("ywc.ldap.domain"),
                    settings.get("ywc.ldap.url"),
                    false,
                    settings.get("ywc.ldap.userdn"),
                    settings.get("ywc.ldap.user"),
                    settings.get("ywc.ldap.pass"));
        }


        //get users
        ArrayList aUsers = new ArrayList();
        aUsers = ldap.getResults(
                settings.get("ywc.ldap.people.properties").split("\\,"),
                settings.get("ywc.ldap.people.dn"),
                "objectClass=person");
        for (int i = 0; i < aUsers.size(); i++) {
            Map user;
            user = (Map) aUsers.get(i);
            //System.out.println(((ArrayList) user.get("sAMAccountName")).get(0));
            System.out.println("User:" + ((ArrayList) user.get("givenName")).get(0)
                    + " "
                    + ((ArrayList) user.get("sn")).get(0)
                    + " "
                    + ((ArrayList) user.get("memberOf")).size());
        }
//
//        //get ou
//        ArrayList aOU = new ArrayList();
//        aOU = ldap.getResults(new String[]{"name", "description"}, "OU=IO,OU=core,DC=iter,DC=org", "objectClass=organizationalUnit");
//        for (int i = 0; i < aOU.size(); i++) {
//            Map oU;
//            oU = (Map) aOU.get(i);
//            System.out.println("OU:" + ((ArrayList) oU.get("name")).get(0) + " " + ((ArrayList) oU.get("description")).get(0));
//        }
//
//        //get groups
//        ArrayList aGroups = new ArrayList();
//        aGroups = ldap.getResults(new String[]{"name", "description", "mail", "member"}, "OU=IO_GD,OU=core,DC=iter,DC=org", "objectClass=group");
//        for (int i = 0; i < aGroups.size(); i++) {
//            Map group;
//            group = (Map) aGroups.get(i);
//
//            if (((ArrayList) group.get("member")) != null) {
//                System.out.println("Group:" + ((ArrayList) group.get("name")).get(0)
//                        + " "
//                        + ((ArrayList) group.get("description")).get(0)
//                        + " "
//                        + ((ArrayList) group.get("member")).size());
//            } else {
//                System.out.println("Group:" + ((ArrayList) group.get("name")).get(0)
//                        + " "
//                        + ((ArrayList) group.get("description")).get(0));
//            }
//        }

//        //get users
//        ArrayList aUsers = new ArrayList();
//        aUsers = ldap.getResults(new String[]{"sAMAccountName", "sn", "givenName", "mail", "memberOf"}, "OU=IO,OU=core,DC=iter,DC=org", "objectClass=person");
//        for (int i = 0; i < aUsers.size(); i++) {
//            Map user;
//            user = (Map) aUsers.get(i);
//            //System.out.println(((ArrayList) user.get("sAMAccountName")).get(0));
//            System.out.println("User:" + ((ArrayList) user.get("givenName")).get(0)
//                    + " "
//                    + ((ArrayList) user.get("sn")).get(0)
//                    + " "
//                    + ((ArrayList) user.get("memberOf")).size());
//        }
//
//        //get ou
//        ArrayList aOU = new ArrayList();
//        aOU = ldap.getResults(new String[]{"name", "description"}, "OU=IO,OU=core,DC=iter,DC=org", "objectClass=organizationalUnit");
//        for (int i = 0; i < aOU.size(); i++) {
//            Map oU;
//            oU = (Map) aOU.get(i);
//            System.out.println("OU:" + ((ArrayList) oU.get("name")).get(0) + " " + ((ArrayList) oU.get("description")).get(0));
//        }
//
//        //get groups
//        ArrayList aGroups = new ArrayList();
//        aGroups = ldap.getResults(new String[]{"name", "description", "mail", "member"}, "OU=IO_GD,OU=core,DC=iter,DC=org", "objectClass=group");
//        for (int i = 0; i < aGroups.size(); i++) {
//            Map group;
//            group = (Map) aGroups.get(i);
//
//            if (((ArrayList) group.get("member")) != null) {
//                System.out.println("Group:" + ((ArrayList) group.get("name")).get(0)
//                        + " "
//                        + ((ArrayList) group.get("description")).get(0)
//                        + " "
//                        + ((ArrayList) group.get("member")).size());
//            } else {
//                System.out.println("Group:" + ((ArrayList) group.get("name")).get(0)
//                        + " "
//                        + ((ArrayList) group.get("description")).get(0));
//            }
//        }
    }
}
