/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.ingest;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.im4java.core.ConvertCmd;
import org.im4java.core.IM4JavaException;
import org.im4java.core.IMOperation;
import org.im4java.process.Pipe;
import ywc.core.settings;

/**
 *
 * @author topher
 */
public class imagemagick {

    public static String[] ingest(String media_id, String extension) throws IM4JavaException {

        String[] rtrnArr = new String[]{"0"};
        
        long ingestTime = System.currentTimeMillis();
            
        try {

            String outMsg;
                
            System.out.println("id: "+media_id+"\ncreating working copies");
            
            int mediaSizeWork = settings.getMediaSizeWork();
            int mediaSizeThmb = settings.getMediaSizeThmb();

            // create work pngs
            
            ConvertCmd cmdConv = new ConvertCmd();
            cmdConv.setSearchPath(settings.getPathImageMagick());
                
           Boolean checkMultiPng = false;
            
           Boolean localCopyExists = (new File(settings.getPathYwcCache() + "/tmp/upl/" + media_id + "." + extension)).exists();
           
            InputStream origFileStream = null;
            BufferedInputStream origFileBufferStream = null;

            
                if (settings.getMediaPngToggle()) {

                    IMOperation opWork = new IMOperation();

                    if (localCopyExists) {
                        opWork.addImage(settings.getPathYwcCache() + "/tmp/upl/" + media_id + "." + extension);

                    } else {
                        origFileStream = cdn.getMediaInputStream(media_id, extension, "orig", null);
                        origFileBufferStream = new BufferedInputStream(origFileStream);
                        Pipe origPipeIn = new Pipe(origFileBufferStream, null);
                        opWork.addImage("-");
                        cmdConv.setInputProvider(origPipeIn);
                    }

                    opWork.background("none");
                    if ("psd".equals(extension)) {
                        opWork.flatten();
                    }
                    opWork.resize(mediaSizeWork, mediaSizeWork);
                    opWork.quality(settings.getMediaQualityPng());
                    opWork.addImage(settings.getPathYwcCache() + "/tmp/ing/" + media_id + ".png");
                    cmdConv.run(opWork);

                    checkMultiPng = (new File(settings.getPathYwcCache() + "/tmp/ing/" + media_id + "-0.png")).exists();
                    outMsg = "-> png: ";
                    if (checkMultiPng || (new File(settings.getPathYwcCache() + "/tmp/ing/" + media_id + ".png")).exists()) {
                        outMsg += "success";
                    } else {
                        outMsg += "failure";
                    }

                } else {
                    outMsg = "-> png: skipped";
                }
            
            if (origFileStream != null) {
             origFileStream.close();
            }
            if (origFileBufferStream != null) {
             origFileBufferStream.close();
            }
            
            
            System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime));
            ingestTime = System.currentTimeMillis();
            
            // create jpegs
            
           InputStream origFileStreamJpg = null;
           BufferedInputStream origFileBufferStreamJpg = null;
            
            IMOperation opWorkJpg = new IMOperation();
            if (settings.getMediaPngToggle()) {
                opWorkJpg.addImage(settings.getPathYwcCache() + "/tmp/ing/" + media_id + ".png");
            } else {
                
                if (localCopyExists) {
                    opWorkJpg.addImage(settings.getPathYwcCache() + "/tmp/upl/" + media_id + "." + extension);

                } else {
                    origFileStreamJpg = cdn.getMediaInputStream(media_id, extension, "orig", null);
                    origFileBufferStreamJpg = new BufferedInputStream(origFileStreamJpg);
                    Pipe origPipeIn = new Pipe(origFileBufferStreamJpg, null);
                    opWorkJpg.addImage("-");
                    opWorkJpg.background("none");
                    if ("psd".equals(extension)) {
                        opWorkJpg.flatten();
                    }
                    cmdConv.setInputProvider(origPipeIn);
                }
                
       //         origFileStreamJpg = cdn.getMediaInputStream(media_id, extension, "orig", null);
       //         origFileBufferStreamJpg = new BufferedInputStream(origFileStreamJpg);
       //         Pipe origPipeIn = new Pipe(origFileBufferStreamJpg, null);
                
       //         opWorkJpg.addImage("-");
       //         opWorkJpg.background("none");
       //         if ("psd".equals(extension)) {
       //             opWorkJpg.flatten();
       //         }
       //         cmdConv.setInputProvider(origPipeIn);
            }
            opWorkJpg.bordercolor("white");
            opWorkJpg.border(0);
            opWorkJpg.alpha("off");
            opWorkJpg.resize(mediaSizeWork, mediaSizeWork);
            opWorkJpg.addImage(settings.getPathYwcCache() + "/tmp/ing/" + media_id + ".jpg");
            cmdConv.run(opWorkJpg);
            
            Boolean checkMultiJpeg = (new File(settings.getPathYwcCache() + "/tmp/ing/" + media_id + "-0.jpg")).exists();
            outMsg = "-> jpg: ";
            if (checkMultiJpeg || (new File(settings.getPathYwcCache() + "/tmp/ing/" + media_id + ".jpg")).exists()) {
                outMsg += "success";
            } else {
                outMsg += "failure";
            }
            
         if (origFileStreamJpg != null) {
                origFileStreamJpg.close();
         } 
         if (origFileBufferStreamJpg != null) {
             
                origFileBufferStreamJpg.close();
            }
            
            System.out.println(outMsg+" "+(System.currentTimeMillis()-ingestTime));
            ingestTime = System.currentTimeMillis();
                    
            if (localCopyExists) {
                (new File(settings.getPathYwcCache() + "/tmp/upl/" + media_id + "." + extension)).delete();
            }
            
            // if there are multiple frames, proceed with montage creation
            if ((checkMultiPng || !settings.getMediaPngToggle()) && checkMultiJpeg) {
                
                System.out.println("multiple frames\nrenaming frames");

                String filePathBase = settings.getPathYwcCache() + "/tmp/ing/" + media_id + "-";
                for (int k = 0; k < 100; k++) {
                    if ((new File(filePathBase + k + ".png")).exists()) {
                        String str_k = "" + k;
                        if (k < 10) {
                            str_k = "00" + k;
                        } else if (k < 100) {
                            str_k = "0" + k;
                        }
                        (new File(filePathBase + k + ".jpg")).renameTo(new File(filePathBase + str_k + ".jpg"));
                        (new File(filePathBase + k + ".png")).renameTo(new File(filePathBase + str_k + ".png"));
                    } else {
                        rtrnArr[0] = ""+k;
                        break;
                    }
                }
                

                outMsg = "-> jpg: ";
                if ((new File(filePathBase + "000.jpg")).exists()) {
                    outMsg += "success";
                } else {
                    outMsg += "failure";
                }

                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();

                outMsg = "-> png: ";
                if ((new File(filePathBase + "000.png")).exists()) {
                    outMsg += "success";
                } else {
                    outMsg += "failure";
                }


                System.out.println("creating thumbnails");

                
                IMOperation opThmb = new IMOperation();
                opThmb.background("#ffffff");
                opThmb.addImage();
                opThmb.resize(mediaSizeThmb, mediaSizeThmb);
                opThmb.quality(settings.getMediaQualityJpeg());
                opThmb.addImage();
                cmdConv.run(opThmb, filePathBase + "000.jpg", filePathBase + "000-thmb.jpg");

                outMsg = "-> jpg: ";
                if ((new File(filePathBase + "000-thmb.jpg")).exists()) {
                    outMsg += "success";
                } else {
                    outMsg += "failure";
                }              
                
                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();
                
                IMOperation opThmb2 = new IMOperation();
                opThmb2.addImage();
                opThmb2.resize(mediaSizeThmb, mediaSizeThmb);
                opThmb2.quality(settings.getMediaQualityPng());
                opThmb2.addImage();
                cmdConv.run(opThmb2, filePathBase + "000.png", filePathBase + "000-thmb.png");

                outMsg = "-> png: ";
                if ((new File(filePathBase + "000-thmb.png")).exists()) {
                    outMsg += "success";
                } else {
                    outMsg += "failure";
                }  
                
                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();
                
                System.out.println("publishing working copies");
                
                outMsg = "-> jpg: ";
                if (ywc.ingest.cdn.saveMediaFile(media_id, "jpg", "work",null, "ing/" + media_id+"-000",false)) {
                    outMsg += "success";
                } else {
                    outMsg += "failure";
                }  
                
                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();
                
                System.out.println("publishing thumbnails");

                outMsg = "-> jpg: ";
                if (ywc.ingest.cdn.saveMediaFile(media_id, "jpg", "thmb",null, "ing/" + media_id + "-000-thmb",false)) {
                    outMsg += "success";
                } else {
                    outMsg += "failure";
                }  

                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();
                
                outMsg = "-> png: ";
                if (ywc.ingest.cdn.saveMediaFile(media_id, "png", "thmb",null, "ing/" + media_id + "-000-thmb",false)) {
                    outMsg += "success";
                } else {
                    outMsg += "failure";
                }  
                
                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();
                 
                outMsg = "cleaning up: ";
                
                for (int k = 0; k < 100; k++) {
                    String str_k = "" + k;
                    if (k < 10) {
                        str_k = "00" + k;
                    } else if (k < 100) {
                        str_k = "0" + k;
                    }
                    
                    if ((new File(filePathBase + str_k + ".png")).exists()) {
                        (new File(filePathBase + str_k + ".png")).delete();
                    }
                    if ((new File(filePathBase + str_k + ".jpg")).exists()) {
                        (new File(filePathBase + str_k + ".jpg")).delete();
                    }
                    if ((new File(filePathBase + str_k + "-thmb.png")).exists()) {
                        (new File(filePathBase + str_k + "-thmb.png")).delete();
                    }
                    if ((new File(filePathBase + str_k + "-thmb.jpg")).exists()) {
                        (new File(filePathBase + str_k + "-thmb.jpg")).delete();
                    }
                }
                
                outMsg += "success";
                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                
            } else {

                rtrnArr[0] = "1";
                
                System.out.println("single frame\ncreating thumbnails");

                IMOperation opThmb = new IMOperation();
                opThmb.addImage();
                opThmb.resize(mediaSizeThmb, mediaSizeThmb);
                opThmb.quality(settings.getMediaQualityJpeg());
                opThmb.addImage();
                cmdConv.run(opThmb, settings.getPathYwcCache() + "/tmp/ing/" + media_id + ".jpg", settings.getPathYwcCache() + "/tmp/ing/" + media_id + "-thmb.jpg");

                outMsg = "-> jpg: ";
                if ((new File(settings.getPathYwcCache() + "/tmp/ing/" + media_id + "-thmb.jpg")).exists()) {
                   outMsg += "success";
                } else {
                    outMsg += "failure";
                }  
                
                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();

                if (settings.getMediaPngToggle()) {
                    IMOperation opThmb2 = new IMOperation();
                    opThmb2.addImage();
                    opThmb2.resize(mediaSizeThmb, mediaSizeThmb);
                    opThmb2.quality(settings.getMediaQualityPng());
                    opThmb2.addImage();
                    cmdConv.run(opThmb2, settings.getPathYwcCache() + "/tmp/ing/" + media_id + ".png", settings.getPathYwcCache() + "/tmp/ing/" + media_id + "-thmb.png");

                    outMsg = "-> png: ";
                    if ((new File(settings.getPathYwcCache() + "/tmp/ing/" + media_id + "-thmb.png")).exists()) {
                        outMsg += "success";
                    } else {
                        outMsg += "failure";
                    }
                } else {
                    outMsg = "-> png: skipped";
                }

                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();

                System.out.println("publishing working copies");

                outMsg = "-> jpg: ";
                if (ywc.ingest.cdn.saveMediaFile(media_id, "jpg", "work",null, "ing/" + media_id,false)) {
                  outMsg += "success";
                } else {
                    outMsg += "failure";
                }  

                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();
                
                if (settings.getMediaPngToggle()) {
                    outMsg = "-> png delete: ";
                    if ((new File(settings.getPathYwcCache() + "/tmp/ing/" + media_id + ".png")).delete()) {
                        outMsg += "success";
                    } else {
                        outMsg += "failure";
                    }
                    System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime) + "ms");
                    ingestTime = System.currentTimeMillis();
                }

                
                System.out.println("publishing thumbnails");
                
                outMsg = "-> jpg: ";
                if (ywc.ingest.cdn.saveMediaFile(media_id, "jpg", "thmb",null, "ing/" + media_id + "-thmb",false)) {
                  outMsg += "success";
                } else {
                    outMsg += "failure";
                } 
                
                System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime)+"ms");
                ingestTime = System.currentTimeMillis();

                
                if (settings.getMediaPngToggle()) {
                    outMsg = "-> png: ";
                    if (ywc.ingest.cdn.saveMediaFile(media_id, "png", "thmb", null, "ing/" + media_id + "-thmb",false)) {
                        outMsg += "success";
                    } else {
                        outMsg += "failure";
                    }

                    System.out.println(outMsg + " " + (System.currentTimeMillis() - ingestTime) + "ms");
                }
            }
            

            
        } catch (IOException ex) {
            Logger.getLogger(imagemagick.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InterruptedException ex) {
            Logger.getLogger(imagemagick.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IM4JavaException ex) {
            Logger.getLogger(imagemagick.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return rtrnArr;

    }
    
}
