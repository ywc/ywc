/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.core;

import com.google.gson.Gson;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Random;

/**
 *
 * @author topher
 */
public class str {
   
    
    public static String trimFileName(String filename) {
        return filename.replaceAll("\\.\\.", "").replaceAll("/", "_").trim();
    }
    
    public static String rtrnJson( ArrayList inputObj ) {
        return (new Gson()).toJson(inputObj);
    } 
    
    public static String basicId(int len) {
        String[] letters = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};
        Random rand_handle = new Random();
        int rand_index = 0;
        String rand_sequence = "";
        for (int i = 0; i < len; i++) {
            rand_index = rand_handle.nextInt(26);
            rand_sequence += letters[rand_index];
        }
        return rand_sequence;
    }

    
    
    
    private static String md5val = "";
    private static MessageDigest algorithm = null;
    
    public static String md5sum(String text) {
        try {
            algorithm = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException nsae) {
            System.out.println("Cannot find digest algorithm");
            System.exit(1);
        }
        byte[] defaultBytes = text.getBytes();
        algorithm.reset();
        algorithm.update(defaultBytes);
        byte messageDigest[] = algorithm.digest();
        StringBuilder hexString = new StringBuilder();

        for (int i = 0; i < messageDigest.length; i++) {
            String hex = Integer.toHexString(0xFF & messageDigest[i]);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        md5val = hexString.toString();
        return md5val;
    }
    
}
