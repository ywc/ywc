/*
 Navicat Premium Data Transfer

 Source Server         : ywccore
 Source Server Type    : SQLite
 Source Server Version : 3008001
 Source Database       : main

 Target Server Type    : SQLite
 Target Server Version : 3008001
 File Encoding         : utf-8

 Date: 12/12/2013 22:37:30 PM
*/

PRAGMA foreign_keys = false;

-- ----------------------------
--  Table structure for data_cache
-- ----------------------------
DROP TABLE IF EXISTS "data_cache";
CREATE TABLE "data_cache" (
	 "cache_id" text(6,0) NOT NULL,
	 "name" TEXT(512,0) NOT NULL,
	 "title" TEXT(512,0) NOT NULL,
	 "type" TEXT(255,0) NOT NULL,
	 "url" text(1024,0) NOT NULL,
	 "properties" TEXT(255,0),
	 "params" TEXT(255,0),
	 "last_updated" REAL NOT NULL,
	 "count_updated" INTEGER NOT NULL,
	 "scope" TEXT(255,0) NOT NULL,
	PRIMARY KEY("cache_id")
);

-- ----------------------------
--  Table structure for data_include
-- ----------------------------
DROP TABLE IF EXISTS "data_include";
CREATE TABLE "data_include" ("include_id" TEXT(6,0),"name" TEXT(1024,0),"title" TEXT(2048,0),"version" TEXT(255,0),"uri" TEXT(2048,0),"content_type" TEXT(255,0),"require" TEXT(1024,0),"conditional" TEXT(255,0),"ordering" INTEGER,"force_update" INTEGER,"async" INTEGER,"params" TEXT(1024,0),"position" TEXT(255,0),"scope" TEXT(255,0),primary key("include_id"));

-- ----------------------------
--  Records of data_include
-- ----------------------------
BEGIN;
INSERT INTO "data_include" VALUES ('aaaaaa', 'browser-detect', 'Detect Browser/Flash', 1.0, 'vendor/browser-detect/1.0/browser-detect.js', 'text/javascript', '-', '-', 1, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaaab', 'css-reset', 'CSS Reset', 2.0, 'vendor/css-reset/2.0/css-reset.css', 'text/css', '-', '-', 1, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaaac', 'jquery', 'jQuery Core', '1.10.2', 'vendor/jquery/jquery/1.10.2/jquery.min.js', 'text/javascript', '-', '-', 2, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaaae', 'jquery-hoverintent', 'jQuery Plugin: HoverIntent', 'r6', 'vendor/jquery/jquery-hoverintent/r6/jquery-hoverintent.modified.min.js', 'text/javascript', 'jquery;', '-', 3, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaaaf', 'jquery-list-attributes', 'jQuery Plugin: List Attributes', '1.1.0.mod', 'vendor/jquery/jquery-list-attributes/1.1.0.mod/jquery-list-attributes.js', 'text/javascript', 'jquery;', '-', 3, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaaba', 'ywc-core', 'YWC Core', 1.0, 'ywc/1.0/js/ywc-core.js', 'text/javascript', 'css-reset; browser-detect; jquery; ywc-social; ywc-popup; ywc-input; ywc-utils; ywc-api; ywc-asset;', '-', 5, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaabb', 'ywc-core', 'YWC Core', 1.0, 'ywc/1.0/css/ywc-core.css', 'text/css', 'css-reset; browser-detect; jquery; ywc-social; ywc-popup; ywc-input; ywc-utils; ywc-api; ywc-asset;', '-', 5, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaabc', 'ywc-api', 'YWC Plugin: External API', 1.0, 'ywc/1.0/js/ywc-api.js', 'text/javascript', 'ywc-core;', '-', 6, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaabd', 'ywc-asset', 'YWC Plugin: Asset List', 1.0, 'ywc/1.0/js/ywc-asset.js', 'text/javascript', 'ywc-core; jquery-list-attributes; jquery-hoverintent;', '-', 6, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaabe', 'ywc-asset', 'YWC Plugin: Asset List', 1.0, 'ywc/1.0/css/ywc-asset.css', 'text/css', 'ywc-core; jquery-list-attributes; jquery-hoverintent;', '-', 6, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaabg', 'ywc-gradient', 'YWC Plugin: Gradient, IE9 Override', 1.0, 'ywc/1.0/css/ywc-gradient-ie.css', 'text/css', '-', 'browser:ie 9', 6, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaabh', 'ywc-gradient', 'YWC Plugin: Gradient', 1.0, 'ywc/1.0/css/ywc-gradient.css', 'text/css', '-', '-', 6, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaabi', 'ywc-input', 'YWC Plugin: Input', 1.0, 'ywc/1.0/js/ywc-input.js', 'text/javascript', 'ywc-core; ywc-gradient;', '-', 6, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaabj', 'ywc-input', 'YWC Plugin: Input', 1.0, 'ywc/1.0/css/ywc-input.css', 'text/css', 'ywc-core; ywc-gradient;', '-', 6, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaabk', 'ywc-popup', 'YWC Plugin: Popups', 1.0, 'ywc/1.0/css/ywc-popup.css', 'text/css', 'ywc-core;', '-', 6, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaabl', 'ywc-popup', 'YWC Plugin: Popups', 1.0, 'ywc/1.0/js/ywc-popup.js', 'text/javascript', 'ywc-core;', '-', 6, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaabm', 'ywc-social', 'YWC Plugin: Social', 1.0, 'ywc/1.0/js/ywc-social.js', 'text/javascript', 'ywc-core;', '-', 6, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaabn', 'ywc-utils', 'YWC Plugin: Javascript Utilities', 1.0, 'ywc/1.0/js/ywc-utils.js', 'text/javascript', 'ywc-core;', '-', 6, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaabo', 'ywc-maps', 'YWC Plugin: Maps', 1.0, 'ywc/1.0/js/ywc-map.js', 'text/javascript', 'ywc-core;', '-', 6, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaabq', 'ywc-intranet', 'YWC Plugin: Intranet', 1.0, 'ywc/1.0/js/ywc-intranet.js', 'text/javascript', 'ywc-core; font-awesome;', '-', 6, 0, 0, '', 'bottom', 'all');
INSERT INTO "data_include" VALUES ('aaaabr', 'ywc-intranet', 'YWC Plugin: Intranet', 1.0, 'ywc/1.0/css/ywc-intranet.css', 'text/css', 'ywc-core; font-awesome;', '-', 6, 0, 0, '', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaaag', 'font-awesome', 'Font Awesome, IE 7', '3.2.1', 'vendor/font-awesome/3.2.1/css/font-awesome.min.css', 'text/css', '-', 'browser:ie 7', 3, 0, 0, ' ', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaaah', 'font-awesome', 'Font Awesome, IE7 Override', '3.2.1', 'vendor/font-awesome/3.2.1/css/font-awesome-ie7.min.css', 'text/css', '-', 'browser:ie 7', 4, 0, 0, ' ', 'top', 'all');
INSERT INTO "data_include" VALUES ('aaaaai', 'font-awesome', 'Font Awesome', '4.0.3', 'vendor/font-awesome/4.0.3/css/font-awesome.min.css', 'text/css', '-', '-', 3, 0, 0, ' ', 'top', 'all');
COMMIT;

-- ----------------------------
--  Table structure for data_placeholder
-- ----------------------------
DROP TABLE IF EXISTS "data_placeholder";
CREATE TABLE "data_placeholder" ("placeholder_id" TEXT(6,0),"template_id" TEXT(6,0),"title" TEXT(1024,0),"top_left_x" INTEGER,"top_left_y" INTEGER,"bttm_right_x" INTEGER,"bttm_right_y" INTEGER,"default_xml" TEXT(1024,0),"default_xsl" TEXT(1024,0),"placement" TEXT(255,0),"default_classes" TEXT(255,0),"inline_styles" TEXT(2048,0),"scope" TEXT(255,0),primary key("placeholder_id"));

-- ----------------------------
--  Records of data_placeholder
-- ----------------------------
BEGIN;
INSERT INTO "data_placeholder" VALUES ('aaaaaa', 'aaaaaa', 'Default Placeholder', 0, 0, 100, 100, '', '', 'body', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaab', 'aaaaab', 'JSON Generic', 0, 0, 0, 0, '', '', 'body', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaac', 'aaaaac', 'Generic E-mail Header', 0, 0, 100, 100, '', 'ywc/1.0/ui-email/ywc-email-header.xsl', 'head', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaad', 'aaaaac', 'Generic E-mail Body', 0, 0, 100, 100, '', 'ywc/1.0/ui-email/ywc-email-body.xsl', 'body', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaae', 'aaaaag', 'AJAX Shell', 0, 0, 100, 600, '', '', 'body', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaag', 'aaaaah', 'Javascript Generic', 0, 0, 0, 0, '', '', 'body', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaah', 'aaaaaf', 'Single Placeholder', 0, 0, 100, 100, '', '', 'body', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaai', 'aaaaai', 'YWC Intranet: Background', 0, 0, 100, 100, '', '', 'bg', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaaj', 'aaaaai', 'YWC Intranet: Banner (Top)', 0, 0, 100, 40, '', '', 'body', 'ywc-intranet-plh-banner', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaak', 'aaaaai', 'YWC Intranet: Global Nav', 0, 40, 100, 70, '', '', 'body', 'ywc-intranet-plh-nav-global', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaal', 'aaaaai', 'YWC Intranet: Footer', 0, 230, 100, 280, '', '', 'body', 'ywc-intranet-plh-nav-footer', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaam', 'aaaaai', 'YWC Intranet: Left Column', 0, 70, 18, 230, '', '', 'body', 'ywc-intranet-plh-clmn-side ywc-intranet-plh-clmn-side-left', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaan', 'aaaaai', 'YWC Intranet: Left Middle Column', 18, 70, 50, 230, '', '', 'body', 'ywc-intranet-plh-clmn-mddl ywc-intranet-plh-clmn-mddl-left', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaao', 'aaaaai', 'YWC Intranet: Right Middle Column', 50, 70, 82, 230, '', '', 'body', 'ywc-intranet-plh-clmn-mddl ywc-intranet-plh-clmn-mddl-right', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaap', 'aaaaai', 'YWC Intranet: Right Column', 82, 70, 100, 230, '', '', 'body', 'ywc-intranet-plh-clmn-side ywc-intranet-plh-clmn-side-right', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaaq', 'aaaaai', 'YWC Intranet: Favicon', 0, 0, 100, 100, '', '', 'head', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaar', 'aaaaad', 'Generic XML', 0, 0, 0, 0, '', '', 'body', '', '', 'all');
INSERT INTO "data_placeholder" VALUES ('aaaaas', 'aaaaaj', 'Plain Text Generic', 0, 0, 0, 0, '', '', 'body', '', '', 'all');
COMMIT;

-- ----------------------------
--  Table structure for data_scope
-- ----------------------------
DROP TABLE IF EXISTS "data_scope";
CREATE TABLE "data_scope" (
	 "scope_id" TEXT(6,0) NOT NULL,
	 "scope" TEXT(64,0) NOT NULL,
	 "title" TEXT(1024,0) NOT NULL,
	 "icon" TEXT(6,0),
	PRIMARY KEY("scope_id")
);

-- ----------------------------
--  Table structure for data_template
-- ----------------------------
DROP TABLE IF EXISTS "data_template";
CREATE TABLE "data_template" ("template_id" TEXT(6,0),"title" TEXT(1024,0),"content_type" TEXT(255,0),"width" INTEGER,"onload" TEXT(1024,0),"includes" TEXT(1024,0),"default_classes" TEXT(255,0),"disable_javascript" INTEGER,"disable_includes" INTEGER,"scope" TEXT(255,0),primary key("template_id"));

-- ----------------------------
--  Records of data_template
-- ----------------------------
BEGIN;
INSERT INTO "data_template" VALUES ('aaaaaa', 'Default Template', 'text/html', 980, '', 'ywc-core;', '', 0, 0, 'all');
INSERT INTO "data_template" VALUES ('aaaaab', 'Generic JSON', 'application/json', 0, '', '', '', 0, 0, 'all');
INSERT INTO "data_template" VALUES ('aaaaac', 'Generic E-mail', 'text/html', 0, '', '', '', 1, 1, 'all');
INSERT INTO "data_template" VALUES ('aaaaad', 'Generic XML', 'text/xml', 0, '', '', '', 0, 0, 'all');
INSERT INTO "data_template" VALUES ('aaaaaf', 'Generic HTML (1 Placeholder)', 'text/html', 0, '', '', '', 1, 0, 'all');
INSERT INTO "data_template" VALUES ('aaaaag', 'Generic AJAX (HTML)', 'text/html*ajax', 600, '', '', '', 0, 0, 'all');
INSERT INTO "data_template" VALUES ('aaaaah', 'Generic Javascript', 'text/javascript', 0, '', '', '', 0, 0, 'all');
INSERT INTO "data_template" VALUES ('aaaaai', 'YWC Intranet Landing Page', 'text/html', 0, '', 'ywc-intranet;', 'ywc-intranet-template', 0, 0, 'all');
INSERT INTO "data_template" VALUES ('aaaaaj', 'Generic Text', 'text/plain', 0, '', '', '', 0, 0, 'all');
COMMIT;

-- ----------------------------
--  Table structure for data_transform
-- ----------------------------
DROP TABLE IF EXISTS "data_transform";
CREATE TABLE "data_transform" (
	 "transform_id" TEXT(6,0) NOT NULL,
	 "placeholder_id" TEXT(6,0),
	 "uri_id" TEXT(6,0),
	 "title" TEXT(1024,0),
	 "ordering" INTEGER,
	 "xml" TEXT(1024,0),
	 "xsl" TEXT(1024,0),
	 "scope" TEXT(255,0),
	PRIMARY KEY("transform_id")
);

-- ----------------------------
--  Records of data_transform
-- ----------------------------
BEGIN;
INSERT INTO "data_transform" VALUES ('aaaaaa', 'aaaaaa', 'aaaaaa', 'Default Transform', 1, '', '', 'all');
INSERT INTO "data_transform" VALUES ('aaaaab', 'aaaaab', 'aaaaah', 'JSON List Countries', 1, '', '', 'all');
INSERT INTO "data_transform" VALUES ('aaaaac', 'aaaaab', 'aaaaac', 'CSS Wrapped as JSONP', 1, '', 'ywc/1.0/generic/css-as-jsonp.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaad', 'aaaaae', 'aaaaaj', 'YWC Intranet: Asset Detail Utilities', 1, 'data/cache.xml', 'ywc-intranet/1.0/popup/ywc-intranet-popup-utility.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaae', 'aaaaae', 'aaaaab', 'YWC Inputs', 1, '', 'ywc/1.0/ui-input/ywc-input-all-standalone.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaaf', 'aaaaae', 'aaaaad', 'YWC Intranet: Asset Detail Popup', 1, 'data/cache.xml', 'ywc-intranet/1.0/popup/ywc-intranet-popup-detail.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaag', 'aaaaae', 'aaaaak', 'YWC Intranet: Subscribe Popup', 1, 'data/cache.xml', 'ywc-intranet/1.0/popup/ywc-intranet-popup-subscribe.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaah', 'aaaaae', 'aaaaal', 'YWC Intranet: Authentication Popup', 1, '', 'ywc-intranet/1.0/popup/ywc-intranet-popup-auth.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaai', 'aaaaae', 'aaaaan', 'YWC Intranet: Asset Archive Popup', 1, 'data/cache.xml', 'ywc-intranet/1.0/list/ywc-intranet-list-archive.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaaj', 'aaaaag', 'aaaaao', 'YWC Intranet: Asset Paging', 1, 'data/cache.xml', 'ywc-intranet/1.0/list/ywc-intranet-list-data.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaak', 'aaaaae', 'aaaaap', 'YWC Intranet: Directory Popup', 1, 'data/cache.xml', 'ywc-intranet/1.0/list/ywc-intranet-list-directory.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaal', 'aaaaae', 'aaaaar', 'YWC Intranet: News Article Popup', 1, 'data/cache.xml', 'ywc-intranet/1.0/news/ywc-intranet-news-full-popup.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaam', 'aaaaae', 'aaaaam', 'YWC Intranet: Asset Edit Popup', 1, 'data/cache.xml', 'ywc-intranet/1.0/popup/ywc-intranet-popup-edit.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaan', 'aaaaad', 'aaaaas', 'YWC Intranet: Posting E-mail', 1, 'data/cache.xml', 'ywc-intranet/1.0/detail/ywc-intranet-detail-link.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaao', 'aaaaaa', 'aaaaat', 'YWC Intranet: Posting Permalink', 1, 'data/cache.xml', 'ywc-intranet/1.0/detail/ywc-intranet-detail-link.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaap', 'aaaaae', 'aaaaaq', 'YWC Intranet: Quick Links Popup', 1, 'data/cache.xml', '', 'all');
INSERT INTO "data_transform" VALUES ('aaaaaq', 'aaaaas', 'aaaaav', 'YWC Intranet: Posting Title', 1, 'data/cache.xml', 'ywc-intranet/1.0/detail/ywc-intranet-detail-title.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaar', 'aaaaar', 'aaaaau', 'YWC Intranet: Who Am I', 1, '', 'ywc-intranet/1.0/auth/ywc-intranet-whoami.xsl', 'all');
INSERT INTO "data_transform" VALUES ('aaaaas', 'aaaaar', 'aaaaaw', 'YWC Intranet: Cache ID', 1, 'data/cache.xml', 'ywc-intranet/1.0/list/ywc-intranet-list-cacheid.xsl', 'all');
INSERT INTO "data_transform" VALUES ('tttttt', 'aaaaaa', 'tttttt', 'YWC Input Test', 1, '', 'ywc/1.0/ui-input/ywc-input-all-test.xsl', 'all');
COMMIT;

-- ----------------------------
--  Table structure for data_uri
-- ----------------------------
DROP TABLE IF EXISTS "data_uri";
CREATE TABLE "data_uri" (
	 "uri_id" TEXT(6,0) NOT NULL,
	 "type" TEXT(64,0),
	 "pattern" TEXT(1024,0),
	 "asset_type" TEXT(64,0),
	 "asset_id" TEXT(6,0),
	 "title" TEXT(1024,0),
	 "onload" TEXT(1024,0),
	 "includes" TEXT(1024,0),
	 "required_params" TEXT(1024,0),
	 "scope" TEXT(255,0),
	PRIMARY KEY("uri_id")
);

-- ----------------------------
--  Records of data_uri
-- ----------------------------
BEGIN;
INSERT INTO "data_uri" VALUES ('aaaaaa', 'media', '/favicon.ico', 'media', 'aaaaab', 'Site Icon', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaab', 'regex', '^/ywc/ui-input/(text|select|hidden|button)$', 'template', 'aaaaag', 'YWC Inputs', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaac', 'regex', '/ywc/css-as-jsonp/', 'template', 'aaaaab', 'CSS Wrapped as JSONP', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaad', 'page', '/ywc/intranet/popup/detail', 'template', 'aaaaag', 'YWC Intranet: Asset Detail Popup', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaah', 'page', '/ywc/data/countries', 'template', 'aaaaab', 'Countries as JSON', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaaj', 'page', '/ywc/intranet/popup/utility', 'template', 'aaaaag', 'YWC Intranet: Asset Detail Utilities', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaak', 'page', '/ywc/intranet/popup/subscribe', 'template', 'aaaaag', 'YWC Intranet: Subscribe Popup', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaal', 'page', '/ywc/intranet/popup/auth', 'template', 'aaaaag', 'YWC Intranet: Authentication Popup', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaam', 'page', '/ywc/intranet/popup/edit', 'template', 'aaaaag', 'YWC Intranet: Asset Edit Popup', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaan', 'page', '/ywc/intranet/popup/archive', 'template', 'aaaaag', 'YWC Intranet: Asset Archive Popup', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaao', 'page', '/ywc/intranet/asset/list', 'template', 'aaaaah', 'YWC Intranet: Asset Paging', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaap', 'page', '/ywc/intranet/popup/directory', 'template', 'aaaaag', 'YWC Intranet: Directory Popup', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaar', 'page', '/ywc/intranet/popup/news', 'template', 'aaaaag', 'YWC Intranet: News Article Popup', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaas', 'regex', '^/ywc/intranet/email/', 'template', 'aaaaac', 'YWC Intranet: Email', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaat', 'regex', '^/ywc/intranet/link/', 'template', 'aaaaaa', 'YWC Intranet: Permalink', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaau', 'page', '/ywc/intranet/whoami', 'template', 'aaaaad', 'YWC Intranet: Who Am I', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaav', 'regex', '^/ywc/intranet/title/', 'template', 'aaaaaj', 'YWC Intranet: Title', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('aaaaaw', 'page', '/ywc/intranet/cache', 'template', 'aaaaad', 'YWC Intranet: Cache ID', '', '', '', 'all');
INSERT INTO "data_uri" VALUES ('tttttt', 'page', '/ywc/ui-input/test', 'template', 'aaaaaa', 'YWC Input Test', '', '', '', 'all');
COMMIT;

-- ----------------------------
--  Table structure for data_user
-- ----------------------------
DROP TABLE IF EXISTS "data_user";
CREATE TABLE "data_user" (
	 "user_id" TEXT(6,0) NOT NULL,
	 "user_alt_id" TEXT(255,0),
	 "title" TEXT(1024,0),
	 "thmb_id" TEXT(6,0),
	 "created_time" REAL,
	 "scope" TEXT(255,0),
	PRIMARY KEY("user_id")
);

-- ----------------------------
--  Records of data_user
-- ----------------------------
BEGIN;
INSERT INTO "data_user" VALUES ('aaaaaa', '-', 'YWC Internal', 'aaaaab', 2440857.5, 'all');
COMMIT;

PRAGMA foreign_keys = true;
