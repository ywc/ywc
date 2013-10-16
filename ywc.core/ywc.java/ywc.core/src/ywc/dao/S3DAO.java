/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.dao;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.GetObjectMetadataRequest;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import java.io.File;
import java.io.FilterInputStream;
import java.io.IOException;
import java.util.HashMap;
import ywc.core.YWCAWSCredentials;
import ywc.core.settings;

/**
 *
 * @author jd
 */
public class S3DAO {
    
    /*
 * Copyright 2010-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

    public static boolean uploadFile(String bucketName, String key, File file) throws IOException {
        
        if (bucketName == null) bucketName = settings.get("aws.s3.bucket_default");
        
        AmazonS3 s3 = new AmazonS3Client(new YWCAWSCredentials());
        try {
            s3.putObject(new PutObjectRequest(bucketName, key, file));
            return true;
   
        } catch (AmazonServiceException ase) {
            
            if (ase.getStatusCode() != 404) {
                System.out.println(
                    "AmazonServiceException: Message->" + ase.getMessage()
                    +", HTTP Code->"+ ase.getStatusCode()
                    +", AWS Code->"+ ase.getErrorCode()
                    +", Type->"+ ase.getErrorType()
                    );
            }
        } catch (AmazonClientException ace) {
            
            System.out.println("AmazonClientException: " + ace.getMessage());
            
        }
        return false;
    }
    public static FilterInputStream getFile(String bucketName, String key) throws IOException {
        
        if (bucketName == null) bucketName = settings.get("aws.s3.bucket_default");
        
        AmazonS3 s3 = new AmazonS3Client(new YWCAWSCredentials());
        try {
            return s3.getObject(new GetObjectRequest(bucketName, key)).getObjectContent();
   
        } catch (AmazonServiceException ase) {
            
            if (ase.getStatusCode() != 404) {
                System.out.println(
                    "AmazonServiceException: Message->" + ase.getMessage()
                    +", HTTP Code->"+ ase.getStatusCode()
                    +", AWS Code->"+ ase.getErrorCode()
                    +", Type->"+ ase.getErrorType()
                    );
            }
             
        } catch (AmazonClientException ace) {
            
            System.out.println("AmazonClientException: " + ace.getMessage());
            
        }
        return null;
    }
 
    public static HashMap getMeta(String bucketName, String key) throws IOException {

        HashMap rtrn = new HashMap();

        if (bucketName == null) {
            bucketName = settings.getCdnTypeAwsS3BucketName();
        }

        AmazonS3 s3 = new AmazonS3Client(new YWCAWSCredentials());

        ObjectMetadata meta = null;
        int status = 0;

        try {
            meta = s3.getObjectMetadata(new GetObjectMetadataRequest(bucketName, key));

        } catch (AmazonServiceException ase) {
            status = ase.getStatusCode();

        } catch (AmazonClientException ace) {
        }
        
        if ((meta == null) || (status == 404)) {
            rtrn = null;
            
        } else {
        //    rtrn.put("ETag",meta.getETag());
            rtrn.put("Last-Modified",meta.getLastModified());
            rtrn.put("Content-Type",meta.getContentType());
            rtrn.put("Content-Length",meta.getContentLength());
            rtrn.put("Expiration-Time",meta.getExpirationTime());

        }

        return rtrn;
    }
    
    public static Boolean fileExists(String bucketName, String key) throws IOException {
        
        Boolean rtrn = false;
        
        HashMap meta = getMeta(bucketName,key);
        
        if (meta != null) {
            rtrn = true;
        }
        
        return rtrn;
    }
   
    

}

