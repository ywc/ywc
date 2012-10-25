
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ywccore` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `ywccore`;
DROP TABLE IF EXISTS `data_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_cache` (
  `cache_id` char(6) COLLATE utf8_bin NOT NULL,
  `name` varchar(512) COLLATE utf8_bin NOT NULL DEFAULT 'untitled',
  `title` varchar(512) COLLATE utf8_bin NOT NULL DEFAULT 'Untitled',
  `type` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `url` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `properties` varchar(255) COLLATE utf8_bin DEFAULT '',
  `params` varchar(255) COLLATE utf8_bin DEFAULT '',
  `last_updated` double NOT NULL DEFAULT '0',
  `count_updated` int(11) NOT NULL DEFAULT '0',
  `scope` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'all',
  PRIMARY KEY (`cache_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `data_cache` WRITE;
/*!40000 ALTER TABLE `data_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_cache` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `data_include`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_include` (
  `include_id` char(6) NOT NULL,
  `name` varchar(1024) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '-',
  `title` varchar(2048) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '-',
  `version` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '1.0',
  `uri` varchar(2048) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'lib/ywc/1.0/js/core.js',
  `content_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'text/javascript',
  `require` varchar(1024) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '-',
  `conditional` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '-',
  `ordering` int(11) NOT NULL DEFAULT '20',
  `force_update` int(11) NOT NULL DEFAULT '0',
  `async` int(11) NOT NULL DEFAULT '0',
  `params` varchar(1024) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `position` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'top',
  `scope` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'all',
  PRIMARY KEY (`include_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `data_include` WRITE;
/*!40000 ALTER TABLE `data_include` DISABLE KEYS */;
INSERT INTO `data_include` VALUES ('aaaaaa','browser-detect','Detect Browser/Flash','1.0','lib/browser-detect/1.0/browser-detect.js','text/javascript','-','-',1,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaaab','css-reset','CSS Reset','2.0','lib/css-reset/2.0/css-reset.css','text/css','-','-',1,0,0,'','top','all');
INSERT INTO `data_include` VALUES ('aaaaac','jquery','jQuery Core','1.7.2','lib/jquery/jquery/1.7.2/jquery.min.js','text/javascript','-','-',2,0,0,'','top','all');
INSERT INTO `data_include` VALUES ('aaaaad','jquery-history','jQuery Plugin: History','1.0','lib/jquery/jquery-history/1.0/jquery-history.js','text/javascript','jquery;','-',3,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaaae','jquery-hoverintent','jQuery Plugin: HoverIntent','r6','lib/jquery/jquery-hoverintent/r6/jquery-hoverintent.modified.min.js','text/javascript','jquery;','-',3,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaaaf','jquery-list-attributes','jQuery Plugin: List Attributes','1.1.0.mod','lib/jquery/jquery-list-attributes/1.1.0.mod/jquery-list-attributes.js','text/javascript','jquery;','-',3,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaaba','ywc-core','YWC Core','1.0','lib/ywc/1.0/js/ywc-core.js','text/javascript','css-reset; browser-detect; jquery; jquery-history; ywc-social; ywc-popup; ywc-input; ywc-utils; ywc-api; ywc-asset;','-',5,0,0,'','top','all');
INSERT INTO `data_include` VALUES ('aaaabb','ywc-core','YWC Core','1.0','lib/ywc/1.0/css/ywc-core.css','text/css','css-reset; browser-detect; jquery; jquery-history; ywc-social; ywc-popup; ywc-input; ywc-utils; ywc-api; ywc-asset;','-',5,0,0,'','top','all');
INSERT INTO `data_include` VALUES ('aaaabc','ywc-api','YWC Plugin: External API','1.0','lib/ywc/1.0/js/ywc-api.js','text/javascript','ywc-core;','-',6,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaabd','ywc-asset','YWC Plugin: Asset List','1.0','lib/ywc/1.0/js/ywc-asset.js','text/javascript','ywc-core; jquery-list-attributes; jquery-hoverintent;','-',6,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaabe','ywc-asset','YWC Plugin: Asset List','1.0','lib/ywc/1.0/css/ywc-asset.css','text/css','ywc-core; jquery-list-attributes; jquery-hoverintent;','-',6,0,0,'','top','all');
INSERT INTO `data_include` VALUES ('aaaabg','ywc-gradient','YWC Plugin: Gradient, IE9 Override','1.0','lib/ywc/1.0/css/ywc-gradient-ie.css','text/css','-','browser:ie 9',6,0,0,'','top','all');
INSERT INTO `data_include` VALUES ('aaaabh','ywc-gradient','YWC Plugin: Gradient','1.0','lib/ywc/1.0/css/ywc-gradient.css','text/css','-','-',6,0,0,'','top','all');
INSERT INTO `data_include` VALUES ('aaaabi','ywc-input','YWC Plugin: Input','1.0','lib/ywc/1.0/js/ywc-input.js','text/javascript','ywc-core; ywc-gradient;','-',6,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaabj','ywc-input','YWC Plugin: Input','1.0','lib/ywc/1.0/css/ywc-input.css','text/css','ywc-core; ywc-gradient;','-',6,0,0,'','top','all');
INSERT INTO `data_include` VALUES ('aaaabk','ywc-popup','YWC Plugin: Popups','1.0','lib/ywc/1.0/css/ywc-popup.css','text/css','ywc-core;','-',6,0,0,'','top','all');
INSERT INTO `data_include` VALUES ('aaaabl','ywc-popup','YWC Plugin: Popups','1.0','lib/ywc/1.0/js/ywc-popup.js','text/javascript','ywc-core;','-',6,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaabm','ywc-social','YWC Plugin: Social','1.0','lib/ywc/1.0/js/ywc-social.js','text/javascript','ywc-core;','-',6,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaabn','ywc-utils','YWC Plugin: Javascript Utilities','1.0','lib/ywc/1.0/js/ywc-utils.js','text/javascript','ywc-core;','-',6,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaabo','ywc-maps','YWC Plugin: Maps','1.0','lib/ywc/1.0/js/ywc-map.js','text/javascript','ywc-core;','-',6,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaabq','ywc-intranet','YWC Plugin: Intranet','1.0','lib/ywc/1.0/js/ywc-intranet.js','text/javascript','ywc-core;','-',6,0,0,'','bottom','all');
INSERT INTO `data_include` VALUES ('aaaabr','ywc-intranet','YWC Plugin: Intranet','1.0','lib/ywc/1.0/css/ywc-intranet.css','text/css','ywc-core;','-',6,0,0,'','top','all');
/*!40000 ALTER TABLE `data_include` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `data_placeholder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_placeholder` (
  `placeholder_id` char(6) COLLATE utf8_bin NOT NULL,
  `template_id` char(6) COLLATE utf8_bin NOT NULL DEFAULT 'aaaaaa',
  `title` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '-',
  `top_left_x` int(11) NOT NULL DEFAULT '0',
  `top_left_y` int(11) NOT NULL DEFAULT '0',
  `bttm_right_x` int(11) NOT NULL DEFAULT '100',
  `bttm_right_y` int(11) NOT NULL DEFAULT '100',
  `default_xml` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `default_xsl` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `placement` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'body',
  `default_classes` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '',
  `inline_styles` varchar(2048) COLLATE utf8_bin NOT NULL DEFAULT '',
  `scope` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'all',
  PRIMARY KEY (`placeholder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `data_placeholder` WRITE;
/*!40000 ALTER TABLE `data_placeholder` DISABLE KEYS */;
INSERT INTO `data_placeholder` VALUES ('aaaaaa','aaaaaa','Default Placeholder',0,0,100,100,'','','body','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaab','aaaaab','JSON Generic',0,0,0,0,'','','body','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaac','aaaaac','Generic E-mail Header',0,0,100,100,'','ywc/1.0/ui-email/ywc-email-header.xsl','head','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaad','aaaaac','Generic E-mail Body',0,0,100,100,'','ywc/1.0/ui-email/ywc-email-body.xsl','body','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaae','aaaaag','AJAX Shell',0,0,100,600,'','','body','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaag','aaaaah','Javascript Generic',0,0,0,0,'','','body','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaah','aaaaaf','Single Placeholder',0,0,100,100,'','','body','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaai','aaaaai','YWC Intranet: Background',0,0,100,100,'','','bg','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaaj','aaaaai','YWC Intranet: Banner (Top)',0,0,100,40,'','','body','ywc-intranet-plh-banner','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaak','aaaaai','YWC Intranet: Global Nav',0,40,100,80,'','','body','ywc-intranet-plh-nav-global','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaal','aaaaai','YWC Intranet: Footer',0,240,100,280,'','','body','ywc-intranet-plh-nav-footer','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaam','aaaaai','YWC Intranet: Left Column',0,80,18,240,'','','body','ywc-intranet-plh-clmn-side ywc-intranet-plh-clmn-side-left','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaan','aaaaai','YWC Intranet: Left Middle Column',18,80,50,240,'','','body','ywc-intranet-plh-clmn-mddl ywc-intranet-plh-clmn-mddl-left','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaao','aaaaai','YWC Intranet: Right Middle Column',50,80,82,240,'','','body','ywc-intranet-plh-clmn-mddl ywc-intranet-plh-clmn-mddl-right','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaap','aaaaai','YWC Intranet: Right Column',82,80,100,240,'','','body','ywc-intranet-plh-clmn-side ywc-intranet-plh-clmn-side-right','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaaq','aaaaai','YWC Intranet: Favicon',0,0,100,100,'','','head','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaar','aaaaad','Generic XML',0,0,0,0,'','','body','','','all');
INSERT INTO `data_placeholder` VALUES ('aaaaas','aaaaaj','Plain Text Generic',0,0,0,0,'','','body','','','all');
/*!40000 ALTER TABLE `data_placeholder` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `data_scope`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_scope` (
  `scope_id` char(6) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `scope` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '-',
  `title` varchar(1024) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '-',
  `icon` char(6) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '------',
  PRIMARY KEY (`scope_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `data_scope` WRITE;
/*!40000 ALTER TABLE `data_scope` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_scope` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `data_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_template` (
  `template_id` char(6) COLLATE utf8_bin NOT NULL,
  `title` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '-',
  `content_type` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'text/html',
  `width` int(11) NOT NULL DEFAULT '100',
  `onload` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `includes` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `default_classes` varchar(255) COLLATE utf8_bin NOT NULL,
  `disable_javascript` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `disable_includes` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `scope` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'all',
  PRIMARY KEY (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `data_template` WRITE;
/*!40000 ALTER TABLE `data_template` DISABLE KEYS */;
INSERT INTO `data_template` VALUES ('aaaaaa','Default Template','text/html',980,'','ywc-core;','',0,0,'all');
INSERT INTO `data_template` VALUES ('aaaaab','Generic JSON','application/json',0,'','','',0,0,'all');
INSERT INTO `data_template` VALUES ('aaaaac','Generic E-mail','text/html',0,'','','',1,1,'all');
INSERT INTO `data_template` VALUES ('aaaaad','Generic XML','text/xml',0,'','','',0,0,'all');
INSERT INTO `data_template` VALUES ('aaaaaf','Generic HTML (1 Placeholder)','text/html',0,'','','',1,0,'all');
INSERT INTO `data_template` VALUES ('aaaaag','Generic AJAX (HTML)','text/html*ajax',600,'','','',0,0,'all');
INSERT INTO `data_template` VALUES ('aaaaah','Generic Javascript','text/javascript',0,'','','',0,0,'all');
INSERT INTO `data_template` VALUES ('aaaaai','YWC Intranet Landing Page','text/html',0,'','ywc-intranet;','ywc-intranet-template',0,0,'all');
INSERT INTO `data_template` VALUES ('aaaaaj','Generic Text','text/plain',0,'','','',0,0,'all');
/*!40000 ALTER TABLE `data_template` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `data_transform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_transform` (
  `transform_id` char(6) COLLATE utf8_bin NOT NULL,
  `placeholder_id` char(6) COLLATE utf8_bin NOT NULL DEFAULT 'aaaaaa',
  `uri_id` char(6) COLLATE utf8_bin NOT NULL DEFAULT 'aaaaaa',
  `title` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '-',
  `ordering` int(11) NOT NULL DEFAULT '1',
  `xml` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `xsl` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `scope` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'all',
  PRIMARY KEY (`transform_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `data_transform` WRITE;
/*!40000 ALTER TABLE `data_transform` DISABLE KEYS */;
INSERT INTO `data_transform` VALUES ('aaaaaa','aaaaaa','aaaaaa','Default Transform',1,'','','all');
INSERT INTO `data_transform` VALUES ('aaaaab','aaaaab','aaaaah','JSON List Countries',1,'','','all');
INSERT INTO `data_transform` VALUES ('aaaaac','aaaaab','aaaaac','CSS Wrapped as JSONP',1,'','ywc/1.0/generic/css-as-jsonp.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaad','aaaaae','aaaaaj','YWC Intranet: Asset Detail Utilities',1,'data/cache.xml','ywc-intranet/1.0/popup/ywc-intranet-popup-utility.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaae','aaaaae','aaaaab','YWC Inputs',1,'','ywc/1.0/ui-input/ywc-input-all-standalone.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaaf','aaaaae','aaaaad','YWC Intranet: Asset Detail Popup',1,'data/cache.xml','ywc-intranet/1.0/popup/ywc-intranet-popup-detail.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaag','aaaaae','aaaaak','YWC Intranet: Subscribe Popup',1,'data/cache.xml','ywc-intranet/1.0/popup/ywc-intranet-popup-subscribe.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaah','aaaaae','aaaaal','YWC Intranet: Authentication Popup',1,'','ywc-intranet/1.0/popup/ywc-intranet-popup-auth.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaai','aaaaae','aaaaan','YWC Intranet: Asset Archive Popup',1,'data/cache.xml','ywc-intranet/1.0/list/ywc-intranet-list-archive.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaaj','aaaaag','aaaaao','YWC Intranet: Asset Paging',1,'data/cache.xml','ywc-intranet/1.0/list/ywc-intranet-list-data.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaak','aaaaae','aaaaap','YWC Intranet: Directory Popup',1,'data/cache.xml','ywc-intranet/1.0/list/ywc-intranet-list-directory.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaal','aaaaae','aaaaar','YWC Intranet: News Article Popup',1,'data/cache.xml','ywc-intranet/1.0/news/ywc-intranet-news-full-popup.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaam','aaaaae','aaaaam','YWC Intranet: Asset Edit Popup',1,'data/cache.xml','ywc-intranet/1.0/popup/ywc-intranet-popup-edit.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaan','aaaaad','aaaaas','YWC Intranet: Posting E-mail',1,'data/cache.xml','ywc-intranet/1.0/detail/ywc-intranet-detail-link.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaao','aaaaaa','aaaaat','YWC Intranet: Posting Permalink',1,'data/cache.xml','ywc-intranet/1.0/detail/ywc-intranet-detail-link.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaap','aaaaae','aaaaaq','YWC Intranet: Quick Links Popup',1,'data/cache.xml','','all');
INSERT INTO `data_transform` VALUES ('aaaaaq','aaaaas','aaaaav','YWC Intranet: Posting Title',1,'data/cache.xml','ywc-intranet/1.0/detail/ywc-intranet-detail-title.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaar','aaaaar','aaaaau','YWC Intranet: Who Am I',1,'','ywc-intranet/1.0/auth/ywc-intranet-whoami.xsl','all');
INSERT INTO `data_transform` VALUES ('aaaaas','aaaaar','aaaaaw','YWC Intranet: Cache ID',1,'data/cache.xml','ywc-intranet/1.0/list/ywc-intranet-list-cacheid.xsl','all');
INSERT INTO `data_transform` VALUES ('tttttt','aaaaaa','tttttt','YWC Input Test',1,'','ywc/1.0/ui-input/ywc-input-all-test.xsl','all');
/*!40000 ALTER TABLE `data_transform` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `data_uri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_uri` (
  `uri_id` char(6) COLLATE utf8_bin NOT NULL,
  `type` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT 'page',
  `pattern` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '-',
  `asset_type` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT 'template',
  `asset_id` char(6) COLLATE utf8_bin NOT NULL DEFAULT 'aaaaaa',
  `title` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '-',
  `onload` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `includes` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `required_params` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '',
  `scope` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'all',
  PRIMARY KEY (`uri_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `data_uri` WRITE;
/*!40000 ALTER TABLE `data_uri` DISABLE KEYS */;
INSERT INTO `data_uri` VALUES ('aaaaaa','media','/favicon.ico','media','aaaaab','Site Icon','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaab','regex','^/ywc/ui-input/(text|select|hidden|button)$','template','aaaaag','YWC Inputs','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaac','regex','/ywc/css-as-jsonp/','template','aaaaab','CSS Wrapped as JSONP','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaad','page','/ywc/intranet/popup/detail','template','aaaaag','YWC Intranet: Asset Detail Popup','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaah','page','/ywc/data/countries','template','aaaaab','Countries as JSON','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaaj','page','/ywc/intranet/popup/utility','template','aaaaag','YWC Intranet: Asset Detail Utilities','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaak','page','/ywc/intranet/popup/subscribe','template','aaaaag','YWC Intranet: Subscribe Popup','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaal','page','/ywc/intranet/popup/auth','template','aaaaag','YWC Intranet: Authentication Popup','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaam','page','/ywc/intranet/popup/edit','template','aaaaag','YWC Intranet: Asset Edit Popup','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaan','page','/ywc/intranet/popup/archive','template','aaaaag','YWC Intranet: Asset Archive Popup','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaao','page','/ywc/intranet/asset/paging','template','aaaaah','YWC Intranet: Asset Paging','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaap','page','/ywc/intranet/popup/directory','template','aaaaag','YWC Intranet: Directory Popup','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaar','page','/ywc/intranet/popup/news','template','aaaaag','YWC Intranet: News Article Popup','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaas','regex','^/ywc/intranet/email/','template','aaaaac','YWC Intranet: Email','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaat','regex','^/ywc/intranet/link/','template','aaaaaa','YWC Intranet: Permalink','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaau','page','/ywc/intranet/whoami','template','aaaaad','YWC Intranet: Who Am I','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaav','regex','^/ywc/intranet/title/','template','aaaaaj','YWC Intranet: Title','','','','all');
INSERT INTO `data_uri` VALUES ('aaaaaw','page','/ywc/intranet/cache','template','aaaaad','YWC Intranet: Cache ID','','','','all');
INSERT INTO `data_uri` VALUES ('tttttt','page','/ywc/ui-input/test','template','aaaaaa','YWC Input Test','','','','all');
/*!40000 ALTER TABLE `data_uri` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `data_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_user` (
  `user_id` char(6) COLLATE utf8_bin NOT NULL,
  `user_alt_id` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '-',
  `title` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '-',
  `thmb_id` char(6) COLLATE utf8_bin NOT NULL DEFAULT 'aaaaaa',
  `created_time` double NOT NULL DEFAULT '2440857.5',
  `scope` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT 'all',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `data_user` WRITE;
/*!40000 ALTER TABLE `data_user` DISABLE KEYS */;
INSERT INTO `data_user` VALUES ('aaaaaa','-','YWC Internal','aaaaab',2440857.5,'all');
/*!40000 ALTER TABLE `data_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

