/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.core;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.UnknownHostException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author delaplj
 */
public class settings {

    public static String get(String prop) {
        return getProp(prop,null);
    } //oist.xxx

    public static String getYWCSiteName() {
        return getProp("ywc.site.name",null);
    } //oist, enthuse,...
   
    public static String getYWCSiteEnv() {
        return getProp("ywc.site.env",null);
    } //prod, dev, test,..
    
    public static String getYWCSiteDomain() {
        return getProp("ywc.site.domain","y-w-c.org");
    } //domain name of site
    
    public static String getYWCMediaDomain() {
        return getProp("ywc.media.domain","y-w-c.org");
    } //domain name of site    
    
    public static String getYWCSiteProtocol() {
        return getProp("ywc.site.protocol","http");
    } //protocol of site
    
    public static String getDBEngine() {
        return getProp("ywc.db.engine",null);
    }

    public static String getDBPath() {
        return getProp("ywc.db.path",null);
    }

    public static String getDBHost() {
        return getProp("ywc.db.host",null);
    }

    public static String getDBPort() {
        return getProp("ywc.db.port",null);
    }

    public static String getDBName() {
        return getProp("ywc.db.name",null);
    }

    public static String getDBUser() {
        return getProp("ywc.db.user",null);
    }

    public static String getDBPass() {
        return getProp("ywc.db.pass",null);
    }

    public static String getContentDest() {
        return getProp("ywc.content_destination",null);
    }

    public static String getPathYwcCoreData() {
        return getYWCpath() + "/ywc.core/ywc.core/";
    }

    public static String getPathYwcCache() {
        return getProp("path.ywc_cache_root",getYWCpath()+"/ywc.cache");
    }

    public static String getPathYwcXsl() {
        return getYWCpath() + "/ywc.xsl/";
    }

    public static String getPathYwcLib() {
        return getYWCpath() + "/ywc.lib/";
    }

    public static String getPathImageMagick() {
        return getProp("path.imagemagick","/usr/bin");
    }

    public static String getPathExifTool() {
        return getProp("path.exiftool","/usr/bin");
    }

    public static String getPathOpenOffice() {
        return getProp("path.openoffice","/usr/bin");
    }

    public static String getCdnTypeAwsBucketName() {
        return getProp("aws.s3.bucket_default","ywc-cdn");
    }
    
    public static String getCdnTypeAwsCredsAccessKey() {
        return getProp("aws.access_key","");
    }
    
    public static String getCdnTypeAwsCredsSecretKey() {
        return getProp("aws.secret_key","");
    }

    public static String getCdnTypeSFTPHost() {
        return getProp("sftp.host","localhost");
    }
    
    public static String getCdnTypeSFTPUser() {
        return getProp("sftp.user","");
    } 
    
    public static String getCdnTypeSFTPPassword() {
        return getProp("sftp.pass","");
    } 
    
    public static String getCdnTypeSFTPPath() {
        return getProp("sftp.path","~/");
    }
    
    public static String getCdnTypeSFTPUri() {
        return getProp("sftp.uri","http://localhost/");
    } 
    
    public static String getYwcXslDelimHeader() {
//        return getProp("ywc.xsl.delim.header","---YWC---");
        return "---YWC---";
    }

    public static String getYwcXslDelimOuter() {
//        return getProp("ywc.xsl.delim.outer","_-_YWC_-_");
        return "_-_YWC_-_";
    }

    public static String getYwcXslDelimInner() {
//        return getProp("ywc.xsl.delim.inner","-_-YWC-_-");
        return "-_-YWC-_-";
    }

    public static String getYwcXslDelimCommand() {
//        return getProp("ywc.xsl.delim.command","___YWC___");
        return "___YWC___";
    }
    
    
    
    
    public static Double getMediaQualityPng() {
        return Double.parseDouble(getProp("ywc.media.quality.png","80.0"));
    }
    
    public static Double getMediaQualityJpeg() {
        return Double.parseDouble(getProp("ywc.media.quality.jpeg","60.0"));
    }    

    public static int getMediaLimitUpload() {
        return Integer.parseInt(getProp("ywc.media.limit.upload","31457280"));
    }
    
    public static int getMediaLimitSynchronousIngest() {
        return Integer.parseInt(getProp("ywc.media.limit.synchronous_ingest","2000000"));
    }
    
    public static int getMediaSizeThmb() {
        return Integer.parseInt(getProp("ywc.media.size.thmb","320"));
    }
    
    public static int getMediaSizeWork() {
        return Integer.parseInt(getProp("ywc.media.size.work","1280"));
    }
    
    public static String getMediaDatabaseMethod() {
        return getProp("ywc.media.database_method","ywc");
    }    
    
    public static String getMediaStorageMethod() {
        return getProp("ywc.media.storage_method","local");
    }    
    
    public static Boolean getMediaPngToggle() {
        return Boolean.parseBoolean(getProp("ywc.media.png.toggle","true"));
    }     
    
    public static Boolean getMediaIngestNonImages() {
        return Boolean.parseBoolean(getProp("ywc.media.ingest_non_images","true"));
    }  
    
    
    
    public static Boolean enableXslRequestCaching() {
        return Boolean.parseBoolean(getProp("ywc.xsl.request_caching","false"));
    }

    public static Boolean enableXslTransformCaching() {
        return Boolean.parseBoolean(getProp("ywc.xsl.memcached","false"));
    }

    public static Boolean enableXslVerboseLogging() {
        return Boolean.parseBoolean(getProp("ywc.xsl.verbose_logging","true"));
    }

    public static String getBackendDaemonProcesses() {
        String[] options = {"ingest_media", "uri_cache", "xml_generate", "ldap_import", "test_mail"};
        String rtrnStr = "";
        for (int i = 0; i < options.length; i++) {
            if (Boolean.parseBoolean(getProp("ywc.backend.d." + options[i],"false"))) {
                rtrnStr += options[i] + ";";
            }
        }
        return rtrnStr;
    }

    public static String getYWCpath() {
        String path = "/data/ywc"; //default expected path
        try {
            java.net.InetAddress localMachine = java.net.InetAddress.getLocalHost();
            String computerName = localMachine.getHostName();
            if (computerName != null) {
                if (computerName.startsWith("tidafe2")) {
                    path = "/opt/ywc";
                } else {
                    path = "/data/ywc";
                }
            }
        } catch (UnknownHostException ex) {
             Logger.getLogger(settings.class.getName()).log(Level.SEVERE, null, ex);
        }
        return path;
    }

    public static String getProp(String pName, String fallbackValue) {
        String ret = fallbackValue;
        try {
            Properties properties = new Properties();
            InputStream inputStream = new FileInputStream(getYWCpath() + "/ywc.conf/ywc.properties");
            properties.load(inputStream);
            inputStream.close();
            ret = properties.getProperty(pName);
        } catch (IOException ex) {
            Logger.getLogger(settings.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (ret == null) {
           ret = fallbackValue;
        }
        return ret;
    }
}
