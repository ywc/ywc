/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.frontend.image;

import java.io.*;
import java.net.SocketException;
import java.util.HashMap;
import javax.net.ssl.SSLProtocolException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.im4java.core.CommandException;
import org.im4java.core.ConvertCmd;
import org.im4java.core.IM4JavaException;
import org.im4java.core.IMOperation;
import org.im4java.process.Pipe;
import ywc.core.settings;
import ywc.core.str;
import ywc.frontend.ws.process;
import ywc.ingest.cdn;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 *
 * @author topher
 */
public class render {
    private static final org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(process.class);
    public static void renderMedia(String media_id, String format, Integer imgSize, HttpServletResponse response, HttpServletRequest request) {

        int thmbSize = settings.getMediaSizeThmb();
        int workSize = settings.getMediaSizeWork();
        String storageMethod = settings.getMediaStorageMethod();
        String action = "scale";

        int thisSize = thmbSize;
        String srcFile = "thmb";

        if (imgSize != null) {
            thisSize = imgSize;
            if (thisSize >= workSize) {
                thisSize = workSize;
            }
            if (thisSize > thmbSize) {
                srcFile = "work";
                format = "jpg";
            }
        }

        double thisQual = (double) settings.getMediaQualityJpeg();
        if ("png".equals(format)) {
            thisQual = (double) settings.getMediaQualityPng();
        }

        String srcFormat = "png";
        if (("jpg".equals(format)) || ("jpeg".equals(format)) || !settings.getMediaPngToggle()) {
            srcFormat = "jpg";
        }


        try {

            if ((thisSize == thmbSize) || (thisSize == workSize)) {
                if (cdn.mediaExists(media_id, format, srcFile, null)) {
                    rtrn.returnMediaToClient(request, response, media_id, format, srcFile, null);
                } else {
                    rtrn.returnMediaError(request, response, format, 404);
                    //   System.out.println("ywc:\tfile not found (" + media_id + ", " + format + ")");
                }
            } else {

                String fileNameAddition = action + "." + thisSize;

                if (!cdn.mediaExists(media_id, srcFormat, "temp", fileNameAddition)) {

                    boolean renderSuccess = false;
                    int renderTryCount = 0;

                    boolean saveFileStream = true;

                    while (!renderSuccess) {

                        renderTryCount++;

                        if (renderTryCount > 20) {
                            logger.warn("image render failure accepted after " + (renderTryCount - 1) + " attempts, returning 500 error");
                            rtrn.returnMediaError(request, response, format, 500);
                            break;
                        }
                        
                        InputStream srcFileStream = null;
                        
                        try {
                            srcFileStream = cdn.getMediaInputStream(media_id, srcFormat, srcFile, null);

                            if (srcFileStream == null) {

                                rtrn.returnMediaError(request, response, format, 404);

                            } else {

                                String tempId = str.basicId(20);

                                String inputFilePath = "";
                                File inputFileObj = null;

                                BufferedInputStream srcFileBufferStream = null;

                                if (saveFileStream) {
                                    inputFilePath = settings.getPathYwcCache() + "/tmp/img/" + tempId + ".input." + srcFormat;
                                    inputFileObj = new File(inputFilePath);
                                    OutputStream inputFileStream = new FileOutputStream(inputFileObj);

                                    int cnt = 0;
                                    byte[] bytes = new byte[1024];
                                    while ((cnt = srcFileStream.read(bytes)) != -1) {
                                        if (Thread.interrupted()) {
                                            throw new InterruptedException();
                                        }
                                        inputFileStream.write(bytes, 0, cnt);
                                    }

                                    inputFileStream.flush();
                                    inputFileStream.close();
                                }

                                String cacheFilePath = settings.getPathYwcCache() + "/tmp/img/" + tempId + "." + format;

                                try {
                                    ConvertCmd cmdConv = new ConvertCmd();
                                    cmdConv.setSearchPath(settings.getPathImageMagick());
                                    IMOperation opConv = new IMOperation();

                                    if (saveFileStream) {
                                        opConv.addImage(inputFilePath);
                                    } else {
                                        srcFileBufferStream = new BufferedInputStream(srcFileStream);
                                        Pipe srcPipeIn = new Pipe(srcFileBufferStream, null);
                                        opConv.addImage("-");
                                        cmdConv.setInputProvider(srcPipeIn);
                                    }
                                    opConv.resize(thisSize, thisSize);
                                    opConv.quality(thisQual);
                                    opConv.addImage(cacheFilePath);
                                    cmdConv.run(opConv);

                                } catch (CommandException ex) {
                                    logger.warn("image render failure (CommandException) on attempt #" + renderTryCount + ", trying again");
                                } catch (IM4JavaException ex) {
                                    logger.warn("image render failure (IM4JavaException) on attempt #" + renderTryCount + ", trying again");
                                }

                                if (srcFileBufferStream != null) {
                                    srcFileBufferStream.close();
                                }
                                if (srcFileStream != null) {
                                    srcFileStream.close();
                                }

                                if (saveFileStream) {
                                    inputFileObj.delete();
                                }

                                if (cdn.saveMediaFile(media_id, format, "temp", fileNameAddition, "img/" + tempId, false)) {
                                    rtrn.returnMediaToClient(request, response, media_id, format, "temp", fileNameAddition);
                                } else if ((new File(cacheFilePath)).exists()) {
                                    response.setContentType(rtrn.getMimeType(format));
                                    rtrn.returnStream(new FileInputStream(cacheFilePath), response,"local -> "+cacheFilePath);
                                }

                                renderSuccess = true;
                            }
                        } catch (SocketException ex) {
                            logger.warn("image render failure (SocketException) on attempt #" + renderTryCount + ", trying again");
                            if (srcFileStream != null) {
                                srcFileStream.close();
                            }
                        } catch (SSLProtocolException ex) {
                            logger.warn("image render failure (SSLProtocolException) on attempt #" + renderTryCount + ", trying again");
                            if (srcFileStream != null) {
                                srcFileStream.close();
                            }
                        } finally {
                        }
                    }

                } else {
                    rtrn.returnMediaToClient(request, response, media_id, format, "temp", fileNameAddition);
                }
            }

        } catch (FileNotFoundException ex) {
            logger.warn("image render failure (FileNotFoundException), returning 500 error");
            rtrn.returnMediaError(request, response, format, 500);
        } catch (IOException ex) {
            logger.warn( "image render failure (IOException), returning 500 error");
            rtrn.returnMediaError(request, response, format, 500);
        } catch (InterruptedException ex) {
            logger.warn("image render failure (InterruptedException), returning 500 error");
            rtrn.returnMediaError(request, response, format, 500);
        }

    }

    public static void renderEmpty(HttpServletResponse response) {
    }

    public static void renderText(String params, HttpServletResponse response, HttpServletRequest request) {

        String hash = md5sum(params);

        if (!cdn.mediaExists(hash, "png", "temp", "text")) {

            String options = "_size__background__font__pointsize__fill__stroke__strokewidth_";
            String[] others = params.split("&");
            String cachePath = "txt/" + hash;
            String text = "";
            HashMap opts = new HashMap();

            for (int i = 0; i < others.length; i++) {
                if (others[i].contains("=") && ("text".equals(others[i].substring(0, others[i].indexOf("="))))) {
                    text += others[i].substring(1 + others[i].indexOf("="));
                    break;
                }
            }

            for (int i = 0; i < others.length; i++) {
                if (others[i].contains("=")) {
                    String key = others[i].substring(0, others[i].indexOf("="));
                    if (options.indexOf("_" + key + "_") > -1) {
                        opts.put(key, others[i].substring(1 + others[i].indexOf("=")));
                    } else if (!"text".equals(key)) {
                        logger.debug("Render text: " + key);
//                        System.out.println("appending to text string: " + key);
                        if (others[i].lastIndexOf("=") == (others[i].length() - 1)) {
                            text += "&" + others[i].substring(0, others[i].lastIndexOf("="));
                        } else {
                            text += "&" + others[i];
                        }
                    }
                } else {
                    text += "&" + others[i];
                }
            }

            Integer size = 1024;
            if (opts.get("size") != null) {
                size = (Integer) Integer.parseInt((String) opts.get("size"));
            }

            String bg = "#ffffff";
            if ((opts.get("background") != null) && (((String) opts.get("background")).length() == 6)) {
                bg = "#" + (String) opts.get("background");
            }

            String fontDir = settings.getPathYwcLib() + "ywc-font/";
            String fontName = "arial";
            String fontPath = fontDir + fontName + "/" + fontName + ".ttf";
            if (opts.get("font") != null) {
                fontName = ((String) opts.get("font")).toLowerCase();
                fontPath = fontDir + fontName + "/" + fontName + ".ttf";
                if (!(new File(fontPath)).exists()) {
                    fontPath = fontDir + "arial/arial.ttf";
                }
            }

            Integer pointsize = 24;
            if (opts.get("pointsize") != null) {
                pointsize = (Integer) Integer.parseInt((String) opts.get("pointsize"));
            }

            String fill = "#000000";
            if (opts.get("fill") != null) {
                if (((String) opts.get("fill")).length() == 6) {
                    fill = "#" + (String) opts.get("fill");
                } else {
                    fill = (String) opts.get("fill");
                }
            }

            String stroke = fill;
            if (opts.get("stroke") != null) {
                stroke = "#" + (String) opts.get("stroke");
            }

            Integer strokeWidth = 0;
            if (opts.get("strokewidth") != null) {
                strokeWidth = Integer.parseInt((String) opts.get("strokewidth"));
            }

            try {

                ConvertCmd cmdConv = new ConvertCmd();
                cmdConv.setSearchPath(settings.getPathImageMagick());
                IMOperation opConv = new IMOperation();
                opConv.addImage(settings.getPathYwcCoreData() + "bin/core/trans.gif");
                opConv.resize(size, size);
                opConv.fill(bg);
                opConv.draw("color 1,1 replace");
                opConv.font(fontPath);
                opConv.pointsize(pointsize);
                opConv.fill(fill);
                opConv.stroke(stroke);
                opConv.strokewidth(strokeWidth);
                opConv.gravity("east");
                opConv.draw("text 1,1 \"" + text.replaceAll("\"", "\\\"") + "  |\"");
                opConv.trim();
                opConv.p_repage();
                opConv.chop((int) Math.round(100 / (2 + text.length())), 0, 0, 0, Boolean.TRUE);
                opConv.alpha("on");
                opConv.transparent(bg);
                opConv.interlace("Line");
                opConv.addImage(settings.getPathYwcCache() + "/tmp/" + cachePath + ".png");
                cmdConv.run(opConv);

            } catch (Exception ex) {
                logger.warn(ex);
            } 

            Boolean saveFile = cdn.saveMediaFile(hash, "png", "temp", "text", cachePath, false);
            (new File(settings.getPathYwcCache() + "/tmp/" + cachePath + ".png")).delete();

            rtrn.returnMediaToClient(request, response, hash, "png", "temp", "text");

        } else {

            rtrn.returnMediaToClient(request, response, hash, "png", "temp", "text");

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
