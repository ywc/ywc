/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.core;

import java.io.File;
import java.io.IOException;

/**
 *
 * @author topher
 */
public class filesystem {
    
    public static void delete(File f) throws IOException {
        if (f.isDirectory()) {
            for (File c : f.listFiles()) {
                delete(c);
            }
        }
        if (!f.delete()) {
 //           throw new FileNotFoundException("Failed to delete file: " + f);
        }
    }
    
    public static boolean fileExists(String filepath) {
        boolean exists = new File(filepath).exists();
        return exists;
    }

    public static long fileSize(String filepath) {
        File file = new File(filepath);
        long length = file.length();
        return length;
    }

    /*public static String fileToString(String filePath) throws FileNotFoundException, IOException {
        
        BufferedReader reader = new BufferedReader(new FileReader(filePath));
        StringBuilder builder = new StringBuilder();
        String line;

        // For every line in the file, append it to the string builder
        while ((line = reader.readLine()) != null) {
            builder.append(line);
        }

        return builder.toString();
    }*/

    public static String[] scanDir(String file_path) {
        
        String [] rtrnArr;
        
        File dir = new File(file_path);
        
        rtrnArr = dir.list();
        
        return rtrnArr;
    }

    public static String fileExtension(String file_path) {
        return file_path.substring(1+file_path.lastIndexOf(".")).toLowerCase();
    }
    
    public static String rtrnDir(String type, String version, String id) {
        
        return settings.getPathYwcCache()+"/"+type+"/"+version+"/"+id.substring(0,2)+"/"+id.substring(2,4); 
        
    }
    /*
    public static Boolean copyFile(String srcPath, String destPath) {
        Boolean rtrn = false;
        try {
            InputStream inFile = null;
            inFile = new FileInputStream(srcPath);
            OutputStream outFile = new FileOutputStream(destPath);
            byte[] buf = new byte[1024];
            int len;
            while ((len = inFile.read(buf)) > 0) {
                outFile.write(buf, 0, len);
            }
            inFile.close();
            outFile.close();
            if (fileExists(destPath)) {
                rtrn = true;
            }
        } catch (IOException ex) {
            Logger.getLogger(filesystem.class.getName()).log(Level.SEVERE, null, ex);
        }
        return rtrn;
    }*/
    
    public static Boolean checkMakeDir(String type, String version, String id) {
        
        Boolean rtrn;
        
        String baseDir = settings.getPathYwcCache()+"/"+type+"/"+version+"/";
        
        if (!fileExists(baseDir+id.substring(0,2))) {
            new File(baseDir+id.substring(0,2)).mkdir();
        }
        
        if (!fileExists(baseDir+id.substring(0,2)+"/"+id.substring(2,4))) {
            new File(baseDir+id.substring(0,2)+"/"+id.substring(2,4)).mkdir();
        }
        
        if (  fileExists(baseDir+id.substring(0,2)) && fileExists(baseDir+id.substring(0,2)+"/"+id.substring(2,4))
            ) {
            
            rtrn = true;
        } else {
        
            rtrn = false;
         }
    
        return rtrn; 
        
    }
    
    
   
}
