/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.ingest;

import com.jcraft.jsch.Channel;
import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpException;
import com.jcraft.jsch.UserInfo;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Level;
import java.util.logging.Logger;
import ywc.core.settings;
import ywc.dao.S3;

/**
 *
 * @author topher
 */
public class cdn {

    public static String getFileDir(String media_id, String ext, String version) {
        String path = media_id.substring(0, 2) + "/" + media_id.substring(2, 4);
        return "/" + version + "/" + path;
    }

    public static Boolean checkOrMakeDirs(String media_id, String contextType) {
        Boolean rtrn = false;

        if (media_id.length() >= 4) {
            String storageMethod = settings.getMediaStorageMethod();
            String[] dirs = {media_id.substring(0, 2), media_id.substring(2, 4)};
            String[] types = {"orig", "work", "thmb", "temp"};

            if ("local".equals(storageMethod) || "sftp".equals(storageMethod)) {
                for (int i = 0; i < types.length; i++) {
                    String base = settings.getPathYwcCache() + "/doc";
                    String dirA = types[i] + "/" + dirs[0];
                    if (!directoryExists(dirA)) {
                        if ((types[i].equals(contextType)) || (!"temp".equals(contextType))) {
                            directoryCreate(dirA);
                        }
                    }
                    String dirB = types[i] + "/" + dirs[0] + "/" + dirs[1];
                    if (directoryExists(dirA) && !directoryExists(dirB)) {
                        rtrn = directoryCreate(dirB);
                    } else {
                        rtrn = true;
                    }
                }
            } else if ("aws".equals(storageMethod)) {
                rtrn = true;
            }
        }

        return rtrn;
    }

    private static Boolean directoryExists(String relativePath) {
        Boolean rtrn = false;
        String storageMethod = settings.getMediaStorageMethod();
        String base;
        if ("local".equals(storageMethod)) {
            base = settings.getPathYwcCache() + "/doc/";
            File file = new File(base + relativePath);
            rtrn = file.exists();
        } else if ("sftp".equals(storageMethod)) {
            base = "http://"+settings.getCdnTypeSFTPUri() + "/doc/";
            try {
                URL url = new URL(base + relativePath);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.setRequestMethod("GET");  //OR  huc.setRequestMethod("HEAD");
                conn.connect();
                rtrn = !(conn.getResponseCode() == 404);
            } catch (MalformedURLException ex) {
                Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return rtrn;
    }
    
    private static Boolean urlExists(String fullUrl) {
        Boolean rtrn = false;
        try {
            HttpURLConnection.setFollowRedirects(false);
            //HttpURLConnection.setInstanceFollowRedirects(false);
            HttpURLConnection conn = (HttpURLConnection) new URL(fullUrl).openConnection();
            conn.setRequestMethod("HEAD");
            conn.connect();
            rtrn = !(conn.getResponseCode() == 404);
        } catch (MalformedURLException ex) {
            Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rtrn;
    }
    
    public static Boolean directoryCreate(String relativePath) {
        Boolean rtrn = false;
        String storageMethod = settings.getMediaStorageMethod();
        String base;
        if ("local".equals(storageMethod)) {
            base = settings.getPathYwcCache() + "/doc/";
            File file = new File(base + relativePath);
            rtrn = file.mkdir();
        } else if ("sftp".equals(storageMethod)) {
            try {
                JSch jsch = new JSch();
                java.util.Properties config = new java.util.Properties(); 
                config.put("StrictHostKeyChecking", "no");
                config.put("VerifyHostKeyDNS", "no");
                Session session = jsch.getSession( settings.getCdnTypeSFTPUser(), settings.getCdnTypeSFTPHost(), settings.getCdnTypeSFTPPort());
                session.setConfig(config);
                session.setPassword(settings.getCdnTypeSFTPPassword());
                session.connect();
                Channel channel = session.openChannel("sftp");
                channel.connect();
                ChannelSftp sftpChannel = (ChannelSftp) channel;
                sftpChannel.mkdir(settings.getCdnTypeSFTPPath() + "/doc/" + relativePath);
                sftpChannel.exit();
                session.disconnect();
                rtrn = directoryExists(relativePath);
            } catch (JSchException ex) {
                Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SftpException ex) {
                Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return rtrn;
    }
    
    public static Boolean mediaExists(String media_id, String ext, String version, String fileNameAddition) {
        Boolean rtrn = false;
                    
        if (media_id.length() >= 4) {
            String storageMethod = settings.getMediaStorageMethod();
            String fileDir = "doc" + getFileDir(media_id, ext, version);
            String fileName = media_id + formatMediaFileNameAddition(fileNameAddition) + "." + ext;

            try {
                if ("local".equals(storageMethod)) {
                    rtrn = new File(settings.getPathYwcCache() + "/" + fileDir + "/" + fileName).exists();
                } else if ("aws".equals(storageMethod)) {
                    rtrn = S3.fileExists(null, fileDir + "/" + fileName);
                } else if ("sftp".equals(storageMethod)) {
                    rtrn = urlExists("http://"+settings.getCdnTypeSFTPUri() + "/" + fileDir+"/"+fileName);
                }

            } catch (IOException ex) {
                Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return rtrn;
    }

    public static Boolean saveMediaFile(String media_id, String ext, String version, String fileNameAddition, String currLoc, Boolean keepOrig) {
        Boolean exists = mediaExists(media_id, ext, version, fileNameAddition);
        Boolean rtrn = exists;
        String storageMethod = settings.getMediaStorageMethod();
        File localFile = new File(settings.getPathYwcCache() + "/tmp/" + currLoc + "." + ext);
        try {
            if (localFile.exists() && checkOrMakeDirs(media_id, version) && !exists) {

                String fileDir = "doc" + getFileDir(media_id, ext, version);
                String fileName = media_id + formatMediaFileNameAddition(fileNameAddition) + "." + ext;

                if ("local".equals(storageMethod)) {
                    rtrn = localFile.renameTo(new File(new File(settings.getPathYwcCache() + "/" + fileDir), fileName));

                } else if ("aws".equals(storageMethod)) {
                    S3.uploadFile(null, fileDir + "/" + fileName, localFile);
                    if ((keepOrig == null) || (keepOrig == false)) {
                        localFile.delete();
                    }
                    rtrn = mediaExists(media_id, ext, version, fileNameAddition);
                
                } else if ("sftp".equals(storageMethod)) {
                    try {
                        JSch jsch = new JSch();
                        java.util.Properties config = new java.util.Properties(); 
                        config.put("StrictHostKeyChecking", "no");
                        config.put("VerifyHostKeyDNS", "no");
                        Session session = jsch.getSession( settings.getCdnTypeSFTPUser(), settings.getCdnTypeSFTPHost(), settings.getCdnTypeSFTPPort());
                        session.setConfig(config);
                        session.setPassword(settings.getCdnTypeSFTPPassword());
                        session.connect();
                        Channel channel = session.openChannel("sftp");
                        channel.connect();
                        ChannelSftp sftpChannel = (ChannelSftp) channel;
                        sftpChannel.put(localFile.getPath(), settings.getCdnTypeSFTPPath() + "/" + fileDir + "/" + fileName);
                        rtrn = mediaExists(media_id, ext, version, fileNameAddition);
                        sftpChannel.exit();
                        session.disconnect();
                    } catch (JSchException ex) {
                        Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (SftpException ex) {
                        Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
        } catch (IOException ex) {
            Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rtrn;
    }

    public static String formatMediaFileNameAddition(String fileNameAddition) {
        String rtrn = "";
        if ((fileNameAddition != null) && !"".equals(fileNameAddition)) {
            rtrn = "." + fileNameAddition;
        }
        return rtrn;
    }

    public static InputStream getMediaInputStream(String media_id, String ext, String version, String fileNameAddition) {
        InputStream fileStream = null;
        if (media_id.length() >= 4) {
            String storageMethod = settings.getMediaStorageMethod();
            String fileDir = "doc" + getFileDir(media_id, ext, version);
            String fileName = media_id + formatMediaFileNameAddition(fileNameAddition) + "." + ext;
            try {
                if ("local".equals(storageMethod)) {
                    if (mediaExists(media_id, ext, version, fileNameAddition)) {
                        fileStream = new FileInputStream(settings.getPathYwcCache() + "/" + fileDir + "/" + fileName);
                    }
                } else if ("aws".equals(storageMethod)) {
                    fileStream = S3.getFile(null, fileDir + "/" + fileName);

                } else if ("sftp".equals(storageMethod)) {
                    try {
                        JSch jsch = new JSch();
                        java.util.Properties config = new java.util.Properties(); 
                        config.put("StrictHostKeyChecking", "no");
                        config.put("VerifyHostKeyDNS", "no");
                        Session session = jsch.getSession( settings.getCdnTypeSFTPUser(), settings.getCdnTypeSFTPHost(), settings.getCdnTypeSFTPPort());
                        session.setConfig(config);
                        session.setPassword(settings.getCdnTypeSFTPPassword());
                        session.connect();
                        Channel channel = session.openChannel("sftp");
                        channel.connect();
                        ChannelSftp sftpChannel = (ChannelSftp) channel;
                        fileStream = sftpChannel.get( settings.getCdnTypeSFTPPath() + "/" + fileDir + "/" + fileName);
//                        sftpChannel.exit();
//                        session.disconnect();
                    } catch (JSchException ex) {
                        Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
                    } catch (SftpException ex) {
                        Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } catch (FileNotFoundException ex) {
                Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
            } catch (IOException ex) {
                Logger.getLogger(cdn.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return fileStream;
    }

    public static Boolean deleteMediaFile(String media_id, String ext, String version) {
        Boolean rtrn = false;
        String storageMethod = settings.getMediaStorageMethod();


        return rtrn;
    }
}
