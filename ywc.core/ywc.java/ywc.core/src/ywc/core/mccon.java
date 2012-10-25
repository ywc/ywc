/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package ywc.core;
import com.danga.MemCached.MemCachedClient;
import com.danga.MemCached.SockIOPool;
import java.sql.Connection;
//import se.enthu.model.CachedCall;

/**
 *
 * @author jd
 */
public class mccon {
    private static mccon instance = null;
    private Connection con;
    public static MemCachedClient mc = new MemCachedClient();
   
   protected mccon() {
      // Exists only to defeat instantiation.
   }
   public static mccon getInstance() {
      if(instance == null) {
         instance = new mccon();
      }
      return instance;
   }
   
   static {
        // server list and weights
        String[] servers = {"localhost:11211"};
        Integer[] weights = {1};
        SockIOPool pool = SockIOPool.getInstance();
        pool.setServers( servers );
        pool.setWeights( weights );
        pool.setInitConn( 10 );
        pool.setMinConn( 10 );
        pool.setMaxConn( 250 );
        pool.setMaxIdle( 1000 * 60 * 60 * 6 );
        pool.setMaintSleep( 30 );
        pool.setNagle( false );
        pool.setSocketTO( 500 );
        pool.setSocketConnectTO( 0 );
        pool.initialize();
        //mc.setCompressEnable( true );
        //mc.setCompressThreshold( 64 * 1024 );
   }
   
   
}

