/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.dao;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import ywc.core.data;
import ywc.core.settings;
import ywc.model.CacheEntry;
import ywc.notification.Mail;



/**
 *
 * @author jd
 */
public class DrupalDAO {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(DrupalDAO.class);
    
    String contentType;
    String url, user, pass, cookie;
    String httpUser, httpPass;
    
    public DrupalDAO() {
        url = settings.getProp("drupal.endpoint",null);
        user = settings.getProp("drupal.user",null);
        pass = settings.getProp("drupal.pass",null);
        httpUser = settings.getProp("drupal.http_user",null);
        httpPass = settings.getProp("drupal.http_pass",null);
    }
    public DrupalDAO(String pType) {
        contentType = pType;
        url = settings.getProp("drupal.endpoint",null);
        user = settings.getProp("drupal.user",null);
        pass = settings.getProp("drupal.pass",null);
        httpUser = settings.getProp("drupal.http_user",null);
        httpPass = settings.getProp("drupal.http_pass",null);
    }
    public DrupalDAO(String pURL, String pUser, String pPass, String pHttpUser, String pHttpPass) {
        url = pURL;
        user = pUser;
        pass = pPass;
        httpUser = pHttpUser;
        httpPass = pHttpPass;
    } 
    
    public String getCookie() {return cookie;}
    public boolean login() {
        boolean ret = false;
        
        HashMap properties = new HashMap();
        if (httpUser != null && httpPass != null) {
            properties.put("http_user", httpUser);properties.put("http_pass", httpPass);
        }
        properties.put("Content-Type", "application/x-www-form-urlencoded");
        properties.put("method", "POST");
        
        HashMap params = new HashMap();
        if (user != null && pass != null) {
            params.put("username", user);params.put("password", pass);
            
            String json = data.requestHTTP(url + "/user/login.json", properties, params);
            if (json != null) {
                JsonObject jsobj = (JsonObject) new JsonParser().parse(json);
                if (jsobj != null && jsobj.has("sessid") && jsobj.has("session_name")) {
                    cookie = jsobj.get("session_name").getAsString() + "=" + jsobj.get("sessid").getAsString();
                    //System.out.println(cookie);
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
            
        } else {
            return true;
        }
        
    }
    public void logoff() {
        HashMap properties = new HashMap();
        if (httpUser != null && httpPass != null) {
            properties.put("http_user", httpUser); properties.put("http_pass", httpPass);
        }
        properties.put("method", "POST");
        properties.put("Cookie", cookie);
        
        HashMap params = new HashMap();
        String json = data.requestHTTP(url + "/user/logout.json", properties, params);
        if (json != null && json.equals("true")) {
            logger.debug("Logout successful from " + url);
        }
    }
    public String getNode(String nid) {
        String ret = null;
        if (login()) {
            logger.debug("Login success to " + url);
            
            HashMap properties = new HashMap();
            if (httpUser != null && httpPass != null) {
                properties.put("http_user", httpUser); properties.put("http_pass", httpPass);
            }
            properties.put("method", "GET");
            properties.put("Cookie", cookie);

            HashMap params = new HashMap();
            String json = data.requestHTTP(url + "/node/" + nid + ".json", properties, params);
            //JsonObject jsobj = (JsonObject) new JsonParser().parse(json);
            if (json != null) {
                ret = json;
            } 
            logoff();
        } else {
            logger.warn("Logout failed to" + url);
        }
        return ret;
    }
    
    public String updateNode(String nid, HashMap params) {
        String ret = null;
        if (login()) {
            logger.debug("Login success to " + url);
            
            HashMap properties = new HashMap();
            if (httpUser != null && httpPass != null) {
                properties.put("http_user", httpUser); properties.put("http_pass", httpPass);
            }
            
            properties.put("Cookie", cookie);
            
            //if nid == null -> create node else update
            String json = null;
            if (nid == null) {
                properties.put("method", "POST");
                json = data.requestHTTP(url + "/node.json", properties, params);
                
            } else {
                properties.put("method", "PUT");
                json = data.requestHTTP(url + "/node/" + nid + ".json", properties, params);
                
            }
            
            if (json != null) {
               JsonObject jsobj = (JsonObject) new JsonParser().parse(json);
               if (nid == null) {
                    ret = jsobj.get("nid").getAsString();
               } else {
                   ret = nid;
               }
               
            }
            logoff();
        } else {
            logger.warn("Login failed to " + url);
        }
        return ret;
    }
    public boolean deleteNode(String nid) {
        boolean ret = false;
        if (login()) {
            logger.debug("Login success to " + url);
            
            HashMap properties = new HashMap();
            if (httpUser != null && httpPass != null) {
                properties.put("http_user", httpUser); properties.put("http_pass", httpPass);
            }
            
            properties.put("Cookie", cookie);
            
            //if nid == null -> create node else update
            String json = null;
            properties.put("method", "DELETE");
            json = data.requestHTTP(url + "/node/" + nid + ".json", properties, null);
             
            if (json != null && json.equals("true")) {
               ret = true;
            }
            logoff();
        } else {
            logger.warn("Login failed to " + url);
        }
        return ret;
    }

    public boolean subscribeList(String tid, String mail) {
        boolean ret = false;
        if (login()) {
            logger.debug("Login success to " + url);
            
            HashMap properties = new HashMap();
            if (httpUser != null && httpPass != null) {
                properties.put("http_user", httpUser); properties.put("http_pass", httpPass);
            }
            properties.put("Cookie", cookie);
            
            HashMap params = new HashMap();
            params.put("mail", mail);
            params.put("tid", tid);
            
            String json = null;
            properties.put("method", "POST");
            json = data.requestHTTP(url + "/simplenews/subscribe.json", properties, params);
             
            if (json != null && json.equals("true")) {
               ret = true;
            }
            logoff();
        } else {
            logger.warn("Login failed to " + url);
        }
        return ret;
    }

    public boolean unsubscribeList(String tid, String mail) {
        boolean ret = false;
        if (login()) {
            logger.debug("Login success to " + url);
            
            HashMap properties = new HashMap();
            if (httpUser != null && httpPass != null) {
                properties.put("http_user", httpUser); properties.put("http_pass", httpPass);
            }
            properties.put("Cookie", cookie);
            
            HashMap params = new HashMap();
            params.put("mail", mail);
            params.put("tid", tid);
            
            String json = null;
            properties.put("method", "POST");
            json = data.requestHTTP(url + "/simplenews/unsubscribe.json", properties, params);
             
            if (json != null && json.equals("true")) {
               ret = true;
            }
            logoff();
        } else {
            logger.warn("Login failed to " + url);
        }
        return ret;
    }

    public void informSubscribers(String nid, String cacheID) {
        HashMap properties = new HashMap();
        if (httpUser != null && httpPass != null) {
            properties.put("http_user", "oist"); 
            properties.put("http_pass", "oist");
        }
        
        CacheEntry entry = CacheDAO.getCacheEntry(cacheID);
        
        // if mail is disabled, let's only notify the admins
        if (settings.getProp("ywc.mail.enable", null) != null
                && settings.getProp("ywc.mail.enable", null).equals("false")) {
            
            Mail mail = new Mail();
            // send mails to subscribers
            logger.info("Notify admins only since ywc.mail.enable=false");
            mail.sendMail(settings.get("ywc.mail.admins"), 
                        "TEST - " + data.requestHTTP(settings.get("ywc.url.noauth") + "/ywc/intranet/title/" + entry.name + "/" + nid, properties, null), 
                        data.requestHTTP(settings.get("ywc.url.noauth") + "/ywc/intranet/email/" + entry.name + "/" + nid, properties, null), 
                        "text/html");
            return;
        }
            
        if (entry.properties.get("subscribe_id") != null) {
            Document dom;
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            try {
                DocumentBuilder db = dbf.newDocumentBuilder();
                dom = db.parse(settings.getPathYwcCache() + "/xml/cache/aaaaaj.xml");
                Element docEle = dom.getDocumentElement();

                //get a nodelist of <employee> elements
                NodeList nl = docEle.getElementsByTagName("simplenews_subscriber");
                
                if(nl != null && nl.getLength() > 0) {
                    for(int i = 0 ; i < nl.getLength();i++) {
                        Element el = (Element)nl.item(i);
                        String listID = getTextValue(el, "list_id");
                        String address = getTextValue(el, "mail");
                        
                        if (listID.equals(entry.properties.get("subscribe_id"))) {
                            Mail mail = new Mail();
                            
                            // send mails to subscribers
                            logger.info("Notify subscriber of " + listID + " address:" + address);
                            mail.sendMail(address, 
                                        data.requestHTTP(settings.get("ywc.url.noauth") + "/ywc/intranet/title/" + entry.name + "/" + nid, properties, null), 
                                        data.requestHTTP(settings.get("ywc.url.noauth") + "/ywc/intranet/email/" + entry.name + "/" + nid, properties, null), 
                                        "text/html");
                        }
                    }
                }
            }catch(Exception ex) {
                logger.warn("Something went wrong..");
            }
        
        } else {
            logger.warn("No subscribe_id found in caching table for " + cacheID);
        }
        
    }
    private String getTextValue(Element ele, String tagName) {
            String textVal = null;
            NodeList nl = ele.getElementsByTagName(tagName);
            if(nl != null && nl.getLength() > 0) {
                    Element el = (Element)nl.item(0);
                    textVal = el.getFirstChild().getNodeValue();
            }

            return textVal;
    }
}
