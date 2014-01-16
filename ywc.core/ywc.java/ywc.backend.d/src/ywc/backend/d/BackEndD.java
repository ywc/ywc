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
import ywc.ingest.cdn;
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

            if (settings.getYwcEnvApp() != null) {

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
                    }

                    if (action.equals("test_mail")) {
                        DrupalDAO drupal = new DrupalDAO();
                        drupal.informSubscribers("22", "aaaaaa");
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

    private static void updateCache() {
        ArrayList entries = CacheDAO.getCacheEntries();
        if (entries != null && entries.size() > 0) {
            for (int i = 0; i < entries.size(); i++) {
                CacheDAO.refreshCache( (CacheEntry) entries.get(i) );
            }
        } else {
            logger.warn("No cache entries found");
        }
    }

    private static void ldapImport() {
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
            System.out.println("User:" + ((ArrayList) user.get("givenName")).get(0)
                    + " "
                    + ((ArrayList) user.get("sn")).get(0)
                    + " "
                    + ((ArrayList) user.get("memberOf")).size());
        }
    }
}
