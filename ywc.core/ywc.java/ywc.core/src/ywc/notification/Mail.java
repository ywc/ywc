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

public class Mail {

    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(Mail.class);
    private String host, port, protocol, user, pass, fromAddress, replyToAddress;

    public Mail() {
        host = settings.getProp("ywc.mail.host", null);
        port = settings.getProp("ywc.mail.port", null);
        protocol = settings.getProp("ywc.mail.protocol", null);
        user = settings.getProp("ywc.mail.user", null);
        pass = settings.getProp("ywc.mail.pass", null);
        fromAddress = settings.getProp("ywc.mail.sender", null);
        replyToAddress = settings.getProp("ywc.mail.reply_to_address", null);
    }

    public Mail(String _host, String _port, String _protocol, String _user, String _pass, String _fromAddress, String _replyToAddress) {
        host = _host;
        port = _port;
        protocol = _protocol;
        user = _user;
        pass = _pass;
        fromAddress = _fromAddress;
        replyToAddress = _replyToAddress;
    }

    public boolean sendMail(String toAddress, String subject, String body, String replyToAddress, String format) {
        if (body == null) {
            return false;
        }

        // Get system properties
        Properties properties = null;
        Session session = null;

        if (protocol.equals("clear")) {
            properties = System.getProperties();
            properties.setProperty("mail.smtp.host", host);
            session = Session.getDefaultInstance(properties);

        } else if (protocol.equals("tls")) {
            properties = new Properties();
            properties.put("mail.smtp.user", fromAddress);
            properties.put("mail.smtp.host", host);
            properties.put("mail.smtp.port", port);
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.socketFactory.port", port);
            properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            properties.put("mail.smtp.socketFactory.fallback", "false");
            properties.put("mail.smtp.debug", "true");

            SecurityManager securityManager = System.getSecurityManager();

            Authenticator auth = new SMTPAuthenticator();
            session = Session.getInstance(properties, auth);
        }

        try {
            MimeMessage mimeMessage = new MimeMessage(session);
            mimeMessage.setFrom(new InternetAddress(fromAddress));
            mimeMessage.setReplyTo(new javax.mail.Address[] {
                new javax.mail.internet.InternetAddress(replyToAddress)
            });
            if (toAddress.contains(",")) {
                String[] tos = toAddress.split(",");
                for (int i = 0; i < tos.length; i++) {
                    mimeMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(tos[i]));
                }
            } else {
                mimeMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(toAddress));
            }
            mimeMessage.setSubject(subject, "UTF-8");
            mimeMessage.setText(body, "UTF-8");
            mimeMessage.setHeader("Content-Type", format + "; charset=UTF-8");
            Transport.send(mimeMessage);
            logger.info("Mail sent with subject " + subject + " to " + toAddress);
            return true;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    private class SMTPAuthenticator extends javax.mail.Authenticator {

        public PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(fromAddress, pass);
        }
    }
}
