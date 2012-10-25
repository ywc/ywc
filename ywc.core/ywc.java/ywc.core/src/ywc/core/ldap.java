/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.core;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.LdapContext;
import javax.naming.ldap.StartTlsResponse;

/**
 *
 * @author jd
 */
public class ldap {
    private String domain;
    private String ldapHost;
    private boolean startTLS;
    private String searchBase;
    private String ldapUserDN;
    private String ldapUser;
    private String ldapPw;

    private LdapContext ctx;
    private StartTlsResponse tls;
    
    public ldap(){
        this.domain = "iter.org";
        this.ldapHost = "ldap://dc1.iter.org:389";
        this.searchBase = "dc=iter,dc=org";
        this.ldapUser = "svc_yeswecan";
        this.ldapPw = "";
    }
    public ldap(String domain, String host, boolean startTLS, String dn, String user, String pw){
        this.domain = domain;
        this.ldapHost = host;
        this.startTLS = startTLS;
        this.ldapUserDN = dn;
        this.ldapUser = user;
        this.ldapPw = pw;
        
        System.out.println("domain:"+domain);
        System.out.println("host:"+host);
        System.out.println("startTLS:"+startTLS);
        System.out.println("userdn:"+dn);
        System.out.println("userlogin:"+user);
        System.out.println("userpw:"+pw);
    }
    
    public LdapContext getCon() {
       return null;
    }
    public void close() {
        try {
            tls.close();
            ctx.close();
        } catch (NamingException ex) {
            Logger.getLogger(ldap.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(ldap.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    public ArrayList getResults(String pAttrs[], String pOU, String pFilter) {
        ArrayList res = new ArrayList();
        LdapContext ctx = getCon();

        String base = pOU;
        
        SearchControls searchCtls = new SearchControls();
        searchCtls.setReturningAttributes(pAttrs);
        searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);

        try {
            NamingEnumeration answer = ctx.search(base, pFilter, searchCtls);
            while (answer.hasMoreElements()) {
                SearchResult sr = (SearchResult) answer.next();
                Attributes attrs = sr.getAttributes();
                Map amap = null;
                if (attrs != null) {
                    amap = new HashMap();
                    NamingEnumeration ne = attrs.getAll();
                    while (ne.hasMore()) {
                        Attribute attr = (Attribute) ne.next();
                        ArrayList aval = new ArrayList();
                        for (int j = 0; j < attr.size(); j++) {
                            aval.add(attr.get(j));
                        }
                        amap.put(attr.getID(), aval);
                    }
                    ne.close();
                }
                res.add(amap);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
        return res;
    }

}
