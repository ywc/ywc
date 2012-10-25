/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.ingest;

import java.io.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import ywc.core.settings;
import ywc.dao.S3DAO;

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

            if ("local".equals(storageMethod)) {
                for (int i = 0; i < types.length; i++) {
                    String base = settings.getPathYwcCache() + "/doc";
                    File dirA = new File(base + "/" + types[i] + "/" + dirs[0]);
                    if (!dirA.exists()) {
                        if ((types[i].equals(contextType)) || (!"temp".equals(contextType))) {
                            dirA.mkdir();
                        }
                    }
                    File dirB = new File(base + "/" + types[i] + "/" + dirs[0] + "/" + dirs[1]);
                    if (dirA.exists() && !dirB.exists()) {
                        rtrn = dirB.mkdir();
                    } else {
                        rtrn = true;
                    }
                }
            } else if ("aws".equals(storageMethod)) {
                rtrn = true;

            } else if ("sftp".equals(storageMethod)) {
                rtrn = false;
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
                    rtrn = S3DAO.fileExists(null, fileDir + "/" + fileName);
                    
                } else if ("sftp".equals(storageMethod)) {
                    rtrn = false;
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
                    String fullFileDir = settings.getPathYwcCache() + "/" + fileDir;
                    rtrn = localFile.renameTo(new File(new File(fullFileDir), fileName));

                } else if ("aws".equals(storageMethod)) {
                    S3DAO.uploadFile(null, fileDir + "/" + fileName, localFile);
                    if ((keepOrig == null) || (keepOrig == false)) {
                        localFile.delete();
                    }
                    rtrn = mediaExists(media_id, ext, version, fileNameAddition);
                
                } else if ("sftp".equals(storageMethod)) {
                    rtrn = false;
                    
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
                    fileStream = S3DAO.getFile(null, fileDir + "/" + fileName);

                } else if ("sftp".equals(storageMethod)) {
                    fileStream = null;
                    
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
