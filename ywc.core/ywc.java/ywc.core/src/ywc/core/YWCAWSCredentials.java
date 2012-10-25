/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.core;

import com.amazonaws.auth.AWSCredentials;

/**
 *
 * @author jd
 */
public class YWCAWSCredentials implements AWSCredentials {

    @Override
    public String getAWSAccessKeyId() {
        return settings.getCdnTypeAwsCredsAccessKey();
    }

    @Override
    public String getAWSSecretKey() {
        return settings.getCdnTypeAwsCredsSecretKey();
    }
    
}
