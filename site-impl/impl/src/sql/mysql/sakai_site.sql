-----------------------------------------------------------------------------
-- SAKAI_SITE_PROPERTY
-----------------------------------------------------------------------------

CREATE TABLE SAKAI_SITE_PROPERTY (
       SITE_ID              VARCHAR (99) NOT NULL,
       NAME                 VARCHAR (99) NOT NULL,
       VALUE                LONGTEXT NULL
);


ALTER TABLE SAKAI_SITE_PROPERTY
       ADD  ( PRIMARY KEY (SITE_ID, NAME) ) ;

-----------------------------------------------------------------------------
-- SAKAI_SITE
-----------------------------------------------------------------------------

CREATE TABLE SAKAI_SITE (
       SITE_ID              VARCHAR (99) NOT NULL,
       TITLE                VARCHAR (99) NULL,
       TYPE                 VARCHAR (99) NULL,
       SHORT_DESC           LONGTEXT NULL,
       DESCRIPTION          LONGTEXT NULL,
       ICON_URL             VARCHAR (255) NULL,
       INFO_URL             VARCHAR (255) NULL,
       SKIN                 VARCHAR (255) NULL,
       PUBLISHED            INTEGER NULL
                                   CHECK (PUBLISHED IN (0, 1)),
       JOINABLE             CHAR(1) NULL
                                   CHECK (JOINABLE IN (1, 0)),
       PUBVIEW              CHAR(1) NULL
                                   CHECK (PUBVIEW IN (1, 0)),
       JOIN_ROLE            VARCHAR (99) NULL,
       CREATEDBY            VARCHAR (99) NULL,
       MODIFIEDBY           VARCHAR (99) NULL,
       CREATEDON            DATETIME NULL,
       MODIFIEDON           DATETIME NULL,
       IS_SPECIAL           CHAR(1) NULL
                                   CHECK (IS_SPECIAL IN (1, 0)),
       IS_USER              CHAR(1) NULL
                                   CHECK (IS_USER IN (1, 0)),
       CUSTOM_PAGE_ORDERED  CHAR(1) NULL
                                   CHECK (CUSTOM_PAGE_ORDERED IN (1, 0))
);

ALTER TABLE SAKAI_SITE
       ADD  ( PRIMARY KEY (SITE_ID) ) ;


ALTER TABLE SAKAI_SITE_PROPERTY
       ADD  ( FOREIGN KEY (SITE_ID)
                             REFERENCES SAKAI_SITE (SITE_ID) ) ;

CREATE INDEX IE_SAKAI_SITE_CREATED ON SAKAI_SITE
(
       CREATEDBY                      ASC,
       CREATEDON                      ASC
);

CREATE INDEX IE_SAKAI_SITE_MODDED ON SAKAI_SITE
(
       MODIFIEDBY                     ASC,
       MODIFIEDON                     ASC
);

CREATE INDEX IE_SAKAI_SITE_FLAGS ON SAKAI_SITE
(
       SITE_ID,
       IS_SPECIAL,       
       IS_USER
);

-----------------------------------------------------------------------------
-- SAKAI_SITE_PAGE
-----------------------------------------------------------------------------

CREATE TABLE SAKAI_SITE_PAGE (
       PAGE_ID              VARCHAR (99) NOT NULL,
       SITE_ID              VARCHAR (99) NOT NULL,
       TITLE                VARCHAR (99) NULL,
       LAYOUT               CHAR(1) NULL,
       SITE_ORDER           INTEGER NOT NULL,
       POPUP                CHAR(1) NULL
                                   CHECK (POPUP IN (1, 0))
);

ALTER TABLE SAKAI_SITE_PAGE
       ADD  ( PRIMARY KEY (PAGE_ID) ) ;

ALTER TABLE SAKAI_SITE_PAGE
       ADD  ( FOREIGN KEY (SITE_ID)
                             REFERENCES SAKAI_SITE (SITE_ID) ) ;

-----------------------------------------------------------------------------
-- SAKAI_SITE_PAGE_PROPERTY
-----------------------------------------------------------------------------

CREATE TABLE SAKAI_SITE_PAGE_PROPERTY (
       SITE_ID              VARCHAR (99) NOT NULL,
       PAGE_ID              VARCHAR (99) NOT NULL,
       NAME                 VARCHAR (99) NOT NULL,
       VALUE                LONGTEXT NULL
);

ALTER TABLE SAKAI_SITE_PAGE_PROPERTY
       ADD  ( PRIMARY KEY (PAGE_ID, NAME) ) ;

ALTER TABLE SAKAI_SITE_PAGE_PROPERTY
       ADD  ( FOREIGN KEY (PAGE_ID)
                             REFERENCES SAKAI_SITE_PAGE (PAGE_ID) ) ;

ALTER TABLE SAKAI_SITE_PAGE_PROPERTY
       ADD  ( FOREIGN KEY (SITE_ID)
                             REFERENCES SAKAI_SITE (SITE_ID) ) ;

CREATE INDEX IE_SAKAI_SITE_PAGE_PROP_SITE ON SAKAI_SITE_PAGE_PROPERTY
(
       SITE_ID                       ASC
);

-----------------------------------------------------------------------------
-- SAKAI_SITE_TOOL
-----------------------------------------------------------------------------

CREATE TABLE SAKAI_SITE_TOOL (
       TOOL_ID              VARCHAR (99) NOT NULL,
       PAGE_ID              VARCHAR (99) NOT NULL,
       SITE_ID              VARCHAR (99) NOT NULL,
       REGISTRATION         VARCHAR (99) NOT NULL,
       PAGE_ORDER           INTEGER NOT NULL,
       TITLE                VARCHAR (99) NULL,
       LAYOUT_HINTS         VARCHAR (99) NULL
);

ALTER TABLE SAKAI_SITE_TOOL
       ADD  ( PRIMARY KEY (TOOL_ID) ) ;

ALTER TABLE SAKAI_SITE_TOOL
       ADD  ( FOREIGN KEY (PAGE_ID)
                             REFERENCES SAKAI_SITE_PAGE (PAGE_ID) ) ;
ALTER TABLE SAKAI_SITE_TOOL
       ADD  ( FOREIGN KEY (SITE_ID)
                             REFERENCES SAKAI_SITE (SITE_ID) ) ;

-----------------------------------------------------------------------------
-- SAKAI_SITE_TOOL_PROPERTY
-----------------------------------------------------------------------------

CREATE TABLE SAKAI_SITE_TOOL_PROPERTY (
       SITE_ID              VARCHAR (99) NOT NULL,
       TOOL_ID              VARCHAR (99) NOT NULL,
       NAME                 VARCHAR (99) NOT NULL,
       VALUE                LONGTEXT NULL
);

ALTER TABLE SAKAI_SITE_TOOL_PROPERTY
       ADD  ( PRIMARY KEY (TOOL_ID, NAME) ) ;

ALTER TABLE SAKAI_SITE_TOOL_PROPERTY
       ADD  ( FOREIGN KEY (TOOL_ID)
                             REFERENCES SAKAI_SITE_TOOL (TOOL_ID) ) ;

ALTER TABLE SAKAI_SITE_TOOL_PROPERTY
       ADD  ( FOREIGN KEY (SITE_ID)
                             REFERENCES SAKAI_SITE (SITE_ID) ) ;

CREATE INDEX IE_SAKAI_SITE_TOOL_PROP_SITE ON SAKAI_SITE_TOOL_PROPERTY
(
       SITE_ID                       ASC
);

-----------------------------------------------------------------------------
-- SAKAI_SITE_USER
-- PERMISSION is -1 for write, 0 for read unpublished, 1 for read published
-- This table is a complete compilation of a user's site read/write capabilities
-----------------------------------------------------------------------------

CREATE TABLE SAKAI_SITE_USER (
       SITE_ID              VARCHAR (99) NOT NULL,
       USER_ID              VARCHAR (99) NOT NULL,
       PERMISSION           INTEGER NOT NULL
);

ALTER TABLE SAKAI_SITE_USER
       ADD  ( PRIMARY KEY (SITE_ID, USER_ID) ) ;

ALTER TABLE SAKAI_SITE_USER
       ADD  ( FOREIGN KEY (SITE_ID)
                             REFERENCES SAKAI_SITE (SITE_ID) ) ;

CREATE INDEX IE_SAKAI_SITE_USER_USER ON SAKAI_SITE_USER
(
       USER_ID                       ASC
);

-- Create sites for the administrator.

INSERT INTO SAKAI_SITE VALUES('~admin', 'Administration Workspace', null, null, 'Administration Workspace', null, null, null, 1, 0, 0, '', 'admin', 'admin', NOW(), NOW(), 0, 1, 0);
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-100', '~admin', 'Home', '0', 1, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-110', '~admin-100', '~admin', 'sakai.motd', 1, 'Message of the Day', NULL );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-120', '~admin-100', '~admin', 'sakai.iframe.myworkspace', 2, 'My Workspace Information', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-200', '~admin', 'Users', '0', 2, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-210', '~admin-200', '~admin', 'sakai.users', 1, 'Users', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-250', '~admin', 'Aliases', '0', 3, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-260', '~admin-250', '~admin', 'sakai.aliases', 1, 'Aliases', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-300', '~admin', 'Sites', '0', 4, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-310', '~admin-300', '~admin', 'sakai.sites', 1, 'Sites', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-350', '~admin', 'Realms', '0', 5, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-355', '~admin-350', '~admin', 'sakai.realms', 1, 'Realms', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-360', '~admin', 'Worksite Setup', '0', 6, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-365', '~admin-360', '~admin', 'sakai.sitesetup', 1, 'Worksite Setup', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-400', '~admin', 'MOTD', '0', 7, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-410', '~admin-400', '~admin', 'sakai.announcements', 1, 'MOTD', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('~admin', '~admin-410', 'channel', '/announcement/channel/!site/motd' );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-500', '~admin', 'Resources', '0', 8, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-510', '~admin-500', '~admin', 'sakai.resources', 1, 'Resources', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('~admin', '~admin-510', 'home', '/' );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-600', '~admin', 'On-Line', '0', 9, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-610', '~admin-600', '~admin', 'sakai.online', 1, 'On-Line', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-700', '~admin', 'Memory', '0', 10, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-710', '~admin-700', '~admin', 'sakai.memory', 1, 'Memory', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('~admin-900', '~admin', 'Site Archive', '0', 11, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('~admin-910', '~admin-900', '~admin', 'sakai.archive', 1, 'Site Archive / Import', NULL );

INSERT INTO SAKAI_SITE VALUES('!admin', 'Administration Workspace', null, null, 'Administration Workspace', null, null, null, 1, 0, 0, '', 'admin', 'admin', NOW(), NOW(), 0, 0, 0);
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-100', '!admin', 'Home', '0', 1, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-110', '!admin-100', '!admin', 'sakai.motd', 1, 'Message of the Day', NULL );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-120', '!admin-100', '!admin', 'sakai.iframe.myworkspace', 2, 'My Workspace Information', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-200', '!admin', 'Users', '0', 2, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-210', '!admin-200', '!admin', 'sakai.users', 1, 'Users', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-250', '!admin', 'Aliases', '0', 3, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-260', '!admin-250', '!admin', 'sakai.aliases', 1, 'Aliases', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-300', '!admin', 'Sites', '0', 4, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-310', '!admin-300', '!admin', 'sakai.sites', 1, 'Sites', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-350', '!admin', 'Realms', '0', 5, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-355', '!admin-350', '!admin', 'sakai.realms', 1, 'Realms', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-360', '!admin', 'Worksite Setup', '0', 6, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-365', '!admin-360', '!admin', 'sakai.sitesetup', 1, 'Worksite Setup', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-400', '!admin', 'MOTD', '0', 7, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-410', '!admin-400', '!admin', 'sakai.announcements', 1, 'MOTD', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!admin', '!admin-410', 'channel', '/announcement/channel/!site/motd' );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-500', '!admin', 'Resources', '0', 8, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-510', '!admin-500', '!admin', 'sakai.resources', 1, 'Resources', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!admin', '!admin-510', 'home', '/' );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-600', '!admin', 'On-Line', '0', 9, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-610', '!admin-600', '!admin', 'sakai.online', 1, 'On-Line', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-700', '!admin', 'Memory', '0', 10, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-710', '!admin-700', '!admin', 'sakai.memory', 1, 'Memory', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!admin-900', '!admin', 'Site Archive', '0', 11, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!admin-910', '!admin-900', '!admin', 'sakai.archive', 1, 'Site Archive / Import', NULL );
INSERT INTO SAKAI_SITE_USER VALUES('!admin', 'admin', -1);

-- Create the !error site to be displayed when there is a problem accessing a site.

INSERT INTO SAKAI_SITE VALUES('!error', 'Site Unavailable', null, null, 'The site you requested is not available.', null, null, null, 1, 0, 0, '', 'admin', 'admin', NOW(), NOW(), 1, 0, 0);
INSERT INTO SAKAI_SITE_PAGE VALUES('!error-100', '!error', 'Site Unavailable', '1', 1, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!error-110', '!error-100', '!error', 'sakai.iframe.site', 1, 'Site Unavailable', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!error', '!error-110', 'height', '400px' );

-- Create the !urlError site to be used when there is a problem understanding the user's request url.

INSERT INTO SAKAI_SITE VALUES('!urlError', 'Invalid URL', null, null, 'The URL you entered is invalid.  SOLUTIONS: Please check for spelling errors or typos.  Make sure you are using the right URL.  Type a URL to try again.', null, null, null, 1, 0, 0, '', 'admin', 'admin', NOW(), NOW(), 1, 0, 0);
INSERT INTO SAKAI_SITE_PAGE VALUES('!urlError-100', '!urlError', 'Invalid URL', '1', 1, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!urlError-110', '!urlError-100', '!urlError', 'sakai.iframe.site', 1, 'Invalid URL', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!urlError', '!urlError-110', 'height', '400px' );

-- Create the !gateway site to be used for the user's initial view of Sakai.

INSERT INTO SAKAI_SITE VALUES('!gateway', 'Gateway', null, null, 'The Gateway Site', null, null, null, 1, 0, 0, '', 'admin', 'admin', NOW(), NOW(), 1, 0, 0);
INSERT INTO SAKAI_SITE_PAGE VALUES('!gateway-100', '!gateway', 'Welcome', '0', 1, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!gateway-110', '!gateway-100', '!gateway', 'sakai.motd', 1, 'Message of the day', NULL );
INSERT INTO SAKAI_SITE_TOOL VALUES('!gateway-120', '!gateway-100', '!gateway', 'sakai.iframe.service', 2, 'Welcome!', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!gateway-200', '!gateway', 'About', '0', 2, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!gateway-210', '!gateway-200', '!gateway', 'sakai.iframe', 1, 'About', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!gateway', '!gateway-210', 'height', '500px' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!gateway', '!gateway-210', 'source', '/library/content/gateway/about.html' );
INSERT INTO SAKAI_SITE_PAGE VALUES('!gateway-300', '!gateway', 'Features', '0', 3, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!gateway-310', '!gateway-300', '!gateway', 'sakai.iframe', 1, 'Features', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!gateway', '!gateway-310', 'height', '500px' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!gateway', '!gateway-310', 'source', '/library/content/gateway/features.html' );
INSERT INTO SAKAI_SITE_PAGE VALUES('!gateway-400', '!gateway', 'Sites', '0', 4, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!gateway-410', '!gateway-400', '!gateway', 'sakai.sitebrowser', 1, 'Sites', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!gateway-500', '!gateway', 'Training', '0', 5, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!gateway-510', '!gateway-500', '!gateway', 'sakai.iframe', 1, 'Training', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!gateway', '!gateway-510', 'height', '500px' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!gateway', '!gateway-510', 'source', '/library/content/gateway/training.html' );
INSERT INTO SAKAI_SITE_PAGE VALUES('!gateway-600', '!gateway', 'Acknowledgements', '0', 6, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!gateway-610', '!gateway-600', '!gateway', 'sakai.iframe', 1, 'Acknowledgments', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!gateway', '!gateway-610', 'height', '500px' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!gateway', '!gateway-610', 'source', '/library/content/gateway/acknowledgments.html' );
INSERT INTO SAKAI_SITE_PAGE VALUES('!gateway-700', '!gateway', 'New Account', '0', 7, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!gateway-710', '!gateway-700', '!gateway', 'sakai.createuser', 1, 'New Account', NULL );

-- Create the !user site to be used as the template for a new user's site.

INSERT INTO SAKAI_SITE VALUES('!user', 'My Workspace', null, null, 'My Workspace Site', null, null, null, 1, 0, 0, '', 'admin', 'admin', NOW(), NOW(), 1, 0, 0);
INSERT INTO SAKAI_SITE_PAGE VALUES('!user-100', '!user', 'Home', '0', 1, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-110', '!user-100', '!user', 'sakai.motd', 1, 'Message of the Day', NULL );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-120', '!user-100', '!user', 'sakai.iframe.myworkspace', 2, 'My Workspace Information', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!user-150', '!user', 'Profile', '0', 2, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-165', '!user-150', '!user', 'sakai.profile', 1, 'Profile', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!user-200', '!user', 'Membership', '0', 3, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-210', '!user-200', '!user', 'sakai.membership', 1, 'Membership', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!user-300', '!user', 'Schedule', '0', 4, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-310', '!user-300', '!user', 'sakai.schedule', 1, 'Schedule', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!user-400', '!user', 'Resources', '0', 5, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-410', '!user-400', '!user', 'sakai.resources', 1, 'Resources', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!user-450', '!user', 'Announcements', '0', 6, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-455', '!user-450', '!user', 'sakai.announcements', 1, 'Announcements', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!user-500', '!user', 'Worksite Setup', '0', 7, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-510', '!user-500', '!user', 'sakai.sitesetup', 1, 'Worksite Setup', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!user-600', '!user', 'Preferences', '0', 8, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-610', '!user-600', '!user', 'sakai.preferences', 1, 'Preferences', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!user-700', '!user', 'Account', '0', 9, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!user-710', '!user-700', '!user', 'sakai.singleuser', 1, 'Account', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!user', '!user-710', 'include-password', 'true' );
-- sakai.rwiki currently stealthed
-- INSERT INTO SAKAI_SITE_PAGE VALUES('!user-800', '!user', 'Wiki', '0', 10, '0' );
-- INSERT INTO SAKAI_SITE_TOOL VALUES('!user-810', '!user-800', '!user', 'sakai.rwiki', 1, 'Wiki', NULL );

-- Create the !worksite site.

INSERT INTO SAKAI_SITE VALUES('!worksite', 'worksite', null, null, null, '', '', null, 0, 0, 0, 'access', 'admin', 'admin', NOW(), NOW(), 1, 0, 0);
INSERT INTO SAKAI_SITE_PAGE VALUES('!worksite-100', '!worksite', 'Home', '1', 1, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-110', '!worksite-100', '!worksite', 'sakai.iframe.site', 1, 'My Workspace Information', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-110', 'height', '100px' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-120', '!worksite-100', '!worksite', 'sakai.synoptic.announcement', 2, 'Recent Announcements', NULL );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-130', '!worksite-100', '!worksite', 'sakai.synoptic.discussion', 3, 'Recent Discussion Items', NULL );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-140', '!worksite-100', '!worksite', 'sakai.synoptic.chat', 4, 'Recent Chat Messages', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!worksite-200', '!worksite', 'Schedule', '0', 2, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-210', '!worksite-200', '!worksite', 'sakai.schedule', 1, 'Schedule', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!worksite-300', '!worksite', 'Announcements', '0', 3, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-310', '!worksite-300', '!worksite', 'sakai.announcements', 1, 'Announcements', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!worksite-400', '!worksite', 'Resources', '0', 4, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-410', '!worksite-400', '!worksite', 'sakai.resources', 1, 'Resources', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!worksite-500', '!worksite', 'Discussion', '0', 5, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-510', '!worksite-500', '!worksite', 'sakai.discussion', 1, 'Discussion', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-510', 'category', 'false' );
INSERT INTO SAKAI_SITE_PAGE VALUES('!worksite-600', '!worksite', 'Assignments', '0', 6, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-610', '!worksite-600', '!worksite', 'sakai.assignment', 1, 'Assignments', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('!worksite-700', '!worksite', 'Drop Box', '0', 7, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-710', '!worksite-700', '!worksite', 'sakai.dropbox', 1, 'Drop Box', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-710', 'resources_mode', 'dropbox' );
INSERT INTO SAKAI_SITE_PAGE VALUES('!worksite-800', '!worksite', 'Chat', '0', 8, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-810', '!worksite-800', '!worksite', 'sakai.chat', 1, 'Chat', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-810', 'display-date', 'true' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-810', 'filter-param', '3' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-810', 'display-time', 'true' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-810', 'sound-alert', 'true' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-810', 'filter-type', 'SelectMessagesByTime' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('!worksite', '!worksite-810', 'display-user', 'true' );
INSERT INTO SAKAI_SITE_PAGE VALUES('!worksite-900', '!worksite', 'Email Archive', '0', 9, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('!worksite-910', '!worksite-900', '!worksite', 'sakai.mailbox', 1, 'Email Archive', NULL );

-- Create the mercury site.

INSERT INTO SAKAI_SITE VALUES('mercury', 'mercury site', null, null, null, '', '', null, 1, 1, 1, 'access', 'admin', 'admin', NOW(), NOW(), 0, 0, 0);
INSERT INTO SAKAI_SITE_PAGE VALUES('mercury-100', 'mercury', 'Home', '1', 1, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-110', 'mercury-100', 'mercury', 'sakai.iframe.site', 1, 'My Workspace Information', NULL );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-120', 'mercury-100', 'mercury', 'sakai.synoptic.announcement', 2, 'Recent Announcements', NULL );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-130', 'mercury-100', 'mercury', 'sakai.synoptic.discussion', 3, 'Recent Discussion Items', NULL );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-140', 'mercury-100', 'mercury', 'sakai.synoptic.chat', 4, 'Recent Chat Messages', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('mercury-200', 'mercury', 'Schedule', '0', 2, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-210', 'mercury-200', 'mercury', 'sakai.schedule', 1, 'Schedule', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('mercury-300', 'mercury', 'Announcements', '0', 3, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-310', 'mercury-300', 'mercury', 'sakai.announcements', 1, 'Announcements', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('mercury-400', 'mercury', 'Resources', '0', 4, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-410', 'mercury-400', 'mercury', 'sakai.resources', 1, 'Resources', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('mercury-500', 'mercury', 'Discussion', '0', 5, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-510', 'mercury-500', 'mercury', 'sakai.discussion', 1, 'Discussion', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('mercury', 'mercury-510', 'category', 'false' );
INSERT INTO SAKAI_SITE_PAGE VALUES('mercury-600', 'mercury', 'Assignments', '0', 6, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-610', 'mercury-600', 'mercury', 'sakai.assignment', 1, 'Assignments', NULL );
INSERT INTO SAKAI_SITE_PAGE VALUES('mercury-700', 'mercury', 'Drop Box', '0', 7, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-710', 'mercury-700', 'mercury', 'sakai.dropbox', 1, 'Drop Box', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('mercury', 'mercury-710', 'resources_mode', 'dropbox' );
INSERT INTO SAKAI_SITE_PAGE VALUES('mercury-800', 'mercury', 'Chat', '0', 8, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-810', 'mercury-800', 'mercury', 'sakai.chat', 1, 'Chat', NULL );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('mercury', 'mercury-810', 'display-date', 'true' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('mercury', 'mercury-810', 'filter-param', '3' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('mercury', 'mercury-810', 'display-time', 'true' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('mercury', 'mercury-810', 'sound-alert', 'true' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('mercury', 'mercury-810', 'filter-type', 'SelectMessagesByTime' );
INSERT INTO SAKAI_SITE_TOOL_PROPERTY VALUES('mercury', 'mercury-810', 'display-user', 'true' );
INSERT INTO SAKAI_SITE_PAGE VALUES('mercury-900', 'mercury', 'Email Archive', '0', 9, '0' );
INSERT INTO SAKAI_SITE_TOOL VALUES('mercury-910', 'mercury-900', 'mercury', 'sakai.mailbox', 1, 'Email Archive', NULL );
