/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.frontend.image;

import java.io.File;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.im4java.core.ConvertCmd;
import org.im4java.core.IM4JavaException;
import org.im4java.core.IMOperation;
import ywc.core.settings;
import ywc.ingest.cdn;

/**
 *
 * @author topher
 */
public class special {

    public static void router(String uri, HttpServletResponse response, HttpServletRequest request) {

        String action = uri.substring("special/".length() + uri.indexOf("special/")).substring(0, uri.substring("special/".length() + uri.indexOf("special/")).indexOf("/"));
        String hash = md5sum(action + "_" + uri);
        String ext = "png";

        if (!cdn.mediaExists(hash, ext, "temp", action)) {
            String cachePath = "gen/" + hash;

            if ("header".equals(action)) {
                renderHeaderDivision(cachePath, uri, response, request);

            } else if ("popupx".equals(action)) {
                renderPopupX(cachePath, uri, response, request);

            } else if ("mask".equals(action)) {
                renderMediaMask(cachePath, uri, response, request);

            } else {
            }

            Boolean saveFile = cdn.saveMediaFile(hash, ext, "temp", action, cachePath,false);
            (new File(settings.getPathYwcCache() + "/tmp/" + cachePath + ".png")).delete();
        }

           rtrn.returnMediaToClient(request, response, hash, ext, "temp", action);
    
    }

    public static void renderMediaMask(String cachePath, String uri, HttpServletResponse response, HttpServletRequest request) {
    }

    public static void renderPopupX(String cachePath, String uri, HttpServletResponse response, HttpServletRequest request) {

        String[] opts = uri.substring("popupx/".length() + uri.indexOf("popupx/")).split("/");
        String bgColor = opts[1];
        String hvrColor = opts[2].substring(0, 6);
        String srcFile = opts[0];

        Boolean onOff = true;
        if (opts[2].contains("_.png")) {
            onOff = false;
            srcFile = opts[0] + "_";
        }

        try {
            ConvertCmd cmdConv = new ConvertCmd();
            cmdConv.setSearchPath(settings.getPathImageMagick());
            IMOperation opConv = new IMOperation();
            opConv.addImage(settings.getPathYwcCoreData() + "bin/popupx/" + srcFile + ".png");

            opConv.fill("#" + hvrColor);
            if (onOff) {
                opConv.draw("color 170,75 floodfill");
            } else {
                opConv.draw("color 170,25 floodfill");
                opConv.draw("color 170,170 floodfill");
            }

            opConv.fill("#" + bgColor);
            if (onOff) {
                opConv.draw("color 170,25 floodfill");
                opConv.draw("color 170,170 floodfill");
            } else {
                opConv.draw("color 170,75 floodfill");
            }

            opConv.resize(90, 90);
            opConv.quality(settings.getMediaQualityPng());
            opConv.alpha("on");
            opConv.interlace("Line");
            opConv.addImage(settings.getPathYwcCache() + "/tmp/" + cachePath + ".png");

            cmdConv.run(opConv);
        } catch (IOException ex) {
            Logger.getLogger(special.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InterruptedException ex) {
            Logger.getLogger(special.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IM4JavaException ex) {
            Logger.getLogger(special.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static void renderHeaderDivision(String cachePath, String uri, HttpServletResponse response, HttpServletRequest request) {

        String bgColor = uri.substring(1 + uri.lastIndexOf("/")).substring(0, 6);

        try {
            ConvertCmd cmdConv = new ConvertCmd();
            cmdConv.setSearchPath(settings.getPathImageMagick());
            IMOperation opConv = new IMOperation();
            opConv.addImage(settings.getPathYwcCoreData() + "bin/header/header.png");
            opConv.fill("#" + bgColor);
            opConv.fuzz(0.15);
            opConv.draw("color 39,1 floodfill");
            opConv.alpha("on");
            opConv.interlace("Line");
            opConv.addImage(settings.getPathYwcCache() + "/tmp/" + cachePath + ".png");
            cmdConv.run(opConv);
        } catch (IOException ex) {
            Logger.getLogger(special.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InterruptedException ex) {
            Logger.getLogger(special.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IM4JavaException ex) {
            Logger.getLogger(special.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
    
    
    private static String md5sum(String text) {
        
        MessageDigest algorithm = null;
        
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
        return hexString.toString();
    }
}
