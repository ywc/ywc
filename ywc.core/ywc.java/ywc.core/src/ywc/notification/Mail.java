/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.notification;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import ywc.core.data;
import ywc.core.settings;
/**
 *
 * @author jd
 */
public class Mail {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(Mail.class);
    private String host, port, protocol, user, pass;
    private String from;
    
                        
    public Mail() {
        host = settings.getProp("ywc.mail.host", null);
        port = settings.getProp("ywc.mail.port", null);
        protocol = settings.getProp("ywc.mail.protocol", null);
        user = settings.getProp("ywc.mail.user", null);
        pass = settings.getProp("ywc.mail.pass", null);
        from = settings.getProp("ywc.mail.sender", null);
    }
    
    public Mail(String _host, String _port, String _protocol, String _user, String _pass, String _from) {
        host = _host;
        port = _port;
        protocol = _protocol;
        user = _user;
        pass = _pass;
        from = _from;
    }

    public boolean sendMail(String to, String subject, String msg, String format) {
        if (msg == null)
            return false;
        
        // Get system properties
        Properties properties = null;
        Session session = null;
        
        if (protocol.equals("clear")) {
            properties = System.getProperties();
            properties.setProperty("mail.smtp.host", host);
            session = Session.getDefaultInstance(properties);

        } else if (protocol.equals("tls")) {
            properties = new Properties();
            properties.put("mail.smtp.user", from);
            properties.put("mail.smtp.host", host);
            properties.put("mail.smtp.port", port);
            properties.put("mail.smtp.starttls.enable","true");
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.socketFactory.port", port);
            properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            properties.put("mail.smtp.socketFactory.fallback", "false");
            properties.put("mail.smtp.debug", "true");

            SecurityManager security = System.getSecurityManager();

            Authenticator auth = new SMTPAuthenticator();
            session = Session.getInstance(properties, auth);
        }
        
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            
            if (to.contains(",")) {
                String[] tos = to.split(",");
                for (int i=0;i<tos.length;i++) {
                    message.addRecipient(Message.RecipientType.TO, new InternetAddress(tos[i]));
            
                }
                
            } else {
                message.addRecipient(Message.RecipientType.TO,
                    new InternetAddress(to));
            
            }
            message.setSubject(subject, "UTF-8");
            message.setText(msg, "UTF-8");
            message.setHeader("Content-Type", format + "; charset=UTF-8");
            Transport.send(message);
            logger.info("Mail sent with subject " + subject + " to " + to);
            return true;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;

    }
    
    private class SMTPAuthenticator extends javax.mail.Authenticator {
        public PasswordAuthentication getPasswordAuthentication()
        {
            return new PasswordAuthentication(from, pass);
        }
    }
}

