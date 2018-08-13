-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 13, 2018 at 11:20 AM
-- Server version: 5.5.61-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ficlatte`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group__permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=63 ;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can add permission', 2, 'add_permission'),
(5, 'Can change permission', 2, 'change_permission'),
(6, 'Can delete permission', 2, 'delete_permission'),
(7, 'Can add group', 3, 'add_group'),
(8, 'Can change group', 3, 'change_group'),
(9, 'Can delete group', 3, 'delete_group'),
(10, 'Can add user', 4, 'add_user'),
(11, 'Can change user', 4, 'change_user'),
(12, 'Can delete user', 4, 'delete_user'),
(13, 'Can add content type', 5, 'add_contenttype'),
(14, 'Can change content type', 5, 'change_contenttype'),
(15, 'Can delete content type', 5, 'delete_contenttype'),
(16, 'Can add session', 6, 'add_session'),
(17, 'Can change session', 6, 'change_session'),
(18, 'Can delete session', 6, 'delete_session'),
(19, 'Can add profile', 7, 'add_profile'),
(20, 'Can change profile', 7, 'change_profile'),
(21, 'Can delete profile', 7, 'delete_profile'),
(22, 'User can make blog posts', 7, 'post_blog'),
(23, 'User can see dashboard, etc.', 7, 'admin'),
(24, 'Can add prompt', 8, 'add_prompt'),
(25, 'Can change prompt', 8, 'change_prompt'),
(26, 'Can delete prompt', 8, 'delete_prompt'),
(27, 'Can add challenge', 9, 'add_challenge'),
(28, 'Can change challenge', 9, 'change_challenge'),
(29, 'Can delete challenge', 9, 'delete_challenge'),
(30, 'Can add story', 10, 'add_story'),
(31, 'Can change story', 10, 'change_story'),
(32, 'Can delete story', 10, 'delete_story'),
(33, 'Can add tag', 11, 'add_tag'),
(34, 'Can change tag', 11, 'change_tag'),
(35, 'Can delete tag', 11, 'delete_tag'),
(36, 'Can add blog', 12, 'add_blog'),
(37, 'Can change blog', 12, 'change_blog'),
(38, 'Can delete blog', 12, 'delete_blog'),
(39, 'Can add rating', 13, 'add_rating'),
(40, 'Can change rating', 13, 'change_rating'),
(41, 'Can delete rating', 13, 'delete_rating'),
(42, 'Can add comment', 14, 'add_comment'),
(43, 'Can change comment', 14, 'change_comment'),
(44, 'Can delete comment', 14, 'delete_comment'),
(45, 'Can add comment like', 15, 'add_commentlike'),
(46, 'Can change comment like', 15, 'change_commentlike'),
(47, 'Can delete comment like', 15, 'delete_commentlike'),
(48, 'Can add story log', 16, 'add_storylog'),
(49, 'Can change story log', 16, 'change_storylog'),
(50, 'Can delete story log', 16, 'delete_storylog'),
(51, 'Can add site log', 17, 'add_sitelog'),
(52, 'Can change site log', 17, 'change_sitelog'),
(53, 'Can delete site log', 17, 'delete_sitelog'),
(54, 'Can add misc', 18, 'add_misc'),
(55, 'Can change misc', 18, 'change_misc'),
(56, 'Can delete misc', 18, 'delete_misc'),
(57, 'Can add subscription', 19, 'add_subscription'),
(58, 'Can change subscription', 19, 'change_subscription'),
(59, 'Can delete subscription', 19, 'delete_subscription'),
(60, 'Can add note', 20, 'add_note'),
(61, 'Can change note', 20, 'change_note'),
(62, 'Can delete note', 20, 'delete_note');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$20000$ijvvZ2IkrKn9$Ia3U9/Lmh5ph8zKu9JugFp5Kbz3DccbnYxQnfnZkJRA=', '2018-08-13 15:04:05', 1, 'superuser', '', '', 'jimstitzel@gmail.com', 1, 1, '2018-08-13 14:34:48'),
(2, 'pbkdf2_sha256$20000$e9JaqoQuSKZr$LOZzCFyVkgIvBuWX84r3HImWRkyPX1IhT+Fjn5LF8/o=', NULL, 0, 'Jim', 'Jim', 'Stitzel', 'stitzelj@gmail.com', 0, 1, '2018-08-13 15:04:39');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_u_permission_id_384b62483d7071f0_fk_auth_permission_id` (`permission_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=27 ;

--
-- Dumping data for table `auth_user_user_permissions`
--

INSERT INTO `auth_user_user_permissions` (`id`, `user_id`, `permission_id`) VALUES
(1, 2, 20),
(2, 2, 21),
(3, 2, 24),
(4, 2, 25),
(5, 2, 27),
(6, 2, 28),
(7, 2, 29),
(8, 2, 30),
(9, 2, 31),
(10, 2, 32),
(11, 2, 33),
(12, 2, 34),
(13, 2, 39),
(14, 2, 40),
(15, 2, 42),
(16, 2, 43),
(17, 2, 44),
(18, 2, 45),
(19, 2, 46),
(20, 2, 47),
(21, 2, 57),
(22, 2, 58),
(23, 2, 59),
(24, 2, 60),
(25, 2, 61),
(26, 2, 62);

-- --------------------------------------------------------

--
-- Table structure for table `castle_blog`
--

CREATE TABLE IF NOT EXISTS `castle_blog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(256) NOT NULL,
  `body` varchar(20480) NOT NULL,
  `draft` tinyint(1) NOT NULL,
  `bbcode` tinyint(1) NOT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `ptime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `castle_blog`
--

INSERT INTO `castle_blog` (`id`, `user_id`, `title`, `body`, `draft`, `bbcode`, `ctime`, `mtime`, `ptime`) VALUES
(1, 1, 'Hi', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sollicitudin tellus nibh, quis pulvinar felis sodales quis. Aliquam nec euismod sem. Fusce ut justo vestibulum arcu laoreet ultrices et vel ipsum. Quisque a porta libero. Phasellus non mauris fermentum tellus placerat laoreet. Cras egestas mauris quis dolor tempus, sed bibendum justo dapibus. Fusce dui quam, aliquam non pharetra at, suscipit eget lorem. Nulla semper mi sed erat vulputate, sed eleifend mauris imperdiet. Nunc tempus consequat enim posuere ultrices. Aenean scelerisque pellentesque turpis vel bibendum. Duis euismod nibh eget elit tempor tempor. Integer justo augue, porttitor pellentesque velit eu, aliquet vestibulum nisl. Etiam augue sapien, ullamcorper eget tempor tempor, rhoncus nec lacus. ', 0, 0, '2018-08-13 15:09:31', '2018-08-13 15:09:31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `castle_challenge`
--

CREATE TABLE IF NOT EXISTS `castle_challenge` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(128) NOT NULL,
  `body` varchar(1024) NOT NULL,
  `mature` tinyint(1) NOT NULL,
  `activity` double DEFAULT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `stime` date NOT NULL,
  `etime` date NOT NULL,
  `ftime` datetime DEFAULT NULL,
  `winner_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `castle_challenge`
--

INSERT INTO `castle_challenge` (`id`, `user_id`, `title`, `body`, `mature`, `activity`, `ctime`, `mtime`, `stime`, `etime`, `ftime`, `winner_id`) VALUES
(1, 1, 'Challenge', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sollicitudin tellus nibh, quis pulvinar felis sodales quis. Aliquam nec euismod sem. Fusce ut justo vestibulum arcu laoreet ultrices et vel ipsum. Quisque a porta libero. Phasellus non mauris fermentum tellus placerat laoreet. Cras egestas mauris quis dolor tempus, sed bibendum justo dapibus. Fusce dui quam, aliquam non pharetra at, suscipit eget lorem. Nulla semper mi sed erat vulputate, sed eleifend mauris imperdiet. Nunc tempus consequat enim posuere ultrices. Aenean scelerisque pellentesque turpis vel bibendum. Duis euismod nibh eget elit tempor tempor. Integer justo augue, porttitor pellentesque velit eu, aliquet vestibulum nisl. Etiam augue sapien, ullamcorper eget tempor tempor, rhoncus nec lacus. ', 0, NULL, '2018-08-13 15:08:50', '2018-08-13 15:08:50', '2018-08-13', '2018-08-31', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `castle_comment`
--

CREATE TABLE IF NOT EXISTS `castle_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `body` varchar(1024) NOT NULL,
  `story_id` int(11) DEFAULT NULL,
  `prompt_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `blog_id` int(11) DEFAULT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `spam` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `castle_commentlike`
--

CREATE TABLE IF NOT EXISTS `castle_commentlike` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `comment_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `castle_misc`
--

CREATE TABLE IF NOT EXISTS `castle_misc` (
  `key` varchar(32) NOT NULL,
  `s_val` varchar(128) DEFAULT NULL,
  `i_val` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `castle_misc`
--

INSERT INTO `castle_misc` (`key`, `s_val`, `i_val`) VALUES
('featured', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `castle_profile`
--

CREATE TABLE IF NOT EXISTS `castle_profile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `pen_name` varchar(64) NOT NULL,
  `pen_name_uc` varchar(64) NOT NULL,
  `site_url` varchar(254) DEFAULT NULL,
  `site_name` varchar(1024) DEFAULT NULL,
  `facebook_username` varchar(64) DEFAULT NULL,
  `twitter_username` varchar(64) DEFAULT NULL,
  `wattpad_username` varchar(64) DEFAULT NULL,
  `biography` varchar(1024) NOT NULL,
  `mature` tinyint(1) NOT NULL,
  `email_addr` varchar(254) NOT NULL,
  `email_flags` int(11) NOT NULL,
  `email_auth` bigint(20) NOT NULL,
  `email_time` datetime DEFAULT NULL,
  `old_auth` varchar(64) DEFAULT NULL,
  `old_salt` varchar(16) DEFAULT NULL,
  `prefs` int(11) NOT NULL,
  `flags` int(11) NOT NULL,
  `stored_id` int(11) DEFAULT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `atime` datetime NOT NULL,
  `spambot` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `pen_name_uc` (`pen_name_uc`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `castle_profile`
--

INSERT INTO `castle_profile` (`id`, `user_id`, `pen_name`, `pen_name_uc`, `site_url`, `site_name`, `facebook_username`, `twitter_username`, `wattpad_username`, `biography`, `mature`, `email_addr`, `email_flags`, `email_auth`, `email_time`, `old_auth`, `old_salt`, `prefs`, `flags`, `stored_id`, `ctime`, `mtime`, `atime`, `spambot`) VALUES
(1, 2, 'Jim', 'Jim', '', '', '', '', '', 'Just me', 0, 'stitzelj@gmail.com', 0, 0, NULL, '', '', 0, 0, NULL, '2018-08-13 15:07:14', '2018-08-13 15:07:14', '2018-08-13 15:07:14', 0),
(2, 1, 'superuser', 'superuser', '', '', '', '', '', 'The man in the moon', 0, 'jimstitzel@gmail.com', 0, 0, NULL, '', '', 0, 0, NULL, '2018-08-13 15:12:56', '2018-08-13 15:12:56', '2018-08-13 15:12:56', 0);

-- --------------------------------------------------------

--
-- Table structure for table `castle_profile_friends`
--

CREATE TABLE IF NOT EXISTS `castle_profile_friends` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_profile_id` int(11) NOT NULL,
  `to_profile_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `from_profile_id` (`from_profile_id`,`to_profile_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `castle_prompt`
--

CREATE TABLE IF NOT EXISTS `castle_prompt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(128) NOT NULL,
  `body` varchar(256) NOT NULL,
  `mature` tinyint(1) NOT NULL,
  `activity` double DEFAULT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `ftime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `castle_prompt`
--

INSERT INTO `castle_prompt` (`id`, `user_id`, `title`, `body`, `mature`, `activity`, `ctime`, `mtime`, `ftime`) VALUES
(1, 2, 'Prompt 1', 'Fear and torment blast the badlands and suddenly there is fire in the sky.', 0, NULL, '2018-08-13 15:14:20', '2018-08-13 15:14:20', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `castle_rating`
--

CREATE TABLE IF NOT EXISTS `castle_rating` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `story_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`story_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `castle_sitelog`
--

CREATE TABLE IF NOT EXISTS `castle_sitelog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` char(39) NOT NULL,
  `url` varchar(254) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `castle_story`
--

CREATE TABLE IF NOT EXISTS `castle_story` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(256) NOT NULL,
  `body` varchar(2048) NOT NULL,
  `prequel_to_id` int(11) DEFAULT NULL,
  `sequel_to_id` int(11) DEFAULT NULL,
  `prompt_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `mature` tinyint(1) NOT NULL,
  `draft` tinyint(1) NOT NULL,
  `ficly` tinyint(1) NOT NULL,
  `activity` double DEFAULT NULL,
  `prompt_text` varchar(256) DEFAULT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `ptime` datetime DEFAULT NULL,
  `ftime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `castle_story`
--

INSERT INTO `castle_story` (`id`, `user_id`, `title`, `body`, `prequel_to_id`, `sequel_to_id`, `prompt_id`, `challenge_id`, `mature`, `draft`, `ficly`, `activity`, `prompt_text`, `ctime`, `mtime`, `ptime`, `ftime`) VALUES
(1, 1, 'Default', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sollicitudin tellus nibh, quis pulvinar felis sodales quis. Aliquam nec euismod sem. Fusce ut justo vestibulum arcu laoreet ultrices et vel ipsum. Quisque a porta libero. Phasellus non mauris fermentum tellus placerat laoreet. Cras egestas mauris quis dolor tempus, sed bibendum justo dapibus. Fusce dui quam, aliquam non pharetra at, suscipit eget lorem. Nulla semper mi sed erat vulputate, sed eleifend mauris imperdiet. Nunc tempus consequat enim posuere ultrices. Aenean scelerisque pellentesque turpis vel bibendum. Duis euismod nibh eget elit tempor tempor. Integer justo augue, porttitor pellentesque velit eu, aliquet vestibulum nisl. Etiam augue sapien, ullamcorper eget tempor tempor, rhoncus nec lacus. ', NULL, NULL, NULL, NULL, 0, 0, 0, 1, '', '2018-08-13 15:07:48', '2018-08-13 15:07:48', NULL, '2018-08-13 15:19:07');

-- --------------------------------------------------------

--
-- Table structure for table `castle_storylog`
--

CREATE TABLE IF NOT EXISTS `castle_storylog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `story_id` int(11) DEFAULT NULL,
  `log_type` int(11) NOT NULL,
  `comment_id` int(11) DEFAULT NULL,
  `quel_id` int(11) DEFAULT NULL,
  `prompt_id` int(11) DEFAULT NULL,
  `ignore_me` tinyint(1) NOT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `ctime` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `castle_storylog`
--

INSERT INTO `castle_storylog` (`id`, `user_id`, `story_id`, `log_type`, `comment_id`, `quel_id`, `prompt_id`, `ignore_me`, `challenge_id`, `ctime`) VALUES
(1, 2, NULL, 8, NULL, NULL, 1, 0, NULL, '2018-08-13 15:14:20'),
(2, 2, NULL, 1, NULL, NULL, 1, 0, NULL, '2018-08-13 15:14:20'),
(3, 2, 1, 1, NULL, NULL, NULL, 0, NULL, '2018-08-13 15:16:55');

-- --------------------------------------------------------

--
-- Table structure for table `castle_subscription`
--

CREATE TABLE IF NOT EXISTS `castle_subscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `story_id` int(11) DEFAULT NULL,
  `blog_id` int(11) DEFAULT NULL,
  `prompt_id` int(11) DEFAULT NULL,
  `challenge_id` int(11) DEFAULT NULL,
  `prequel_to_id` int(11) DEFAULT NULL,
  `sequel_to_id` int(11) DEFAULT NULL,
  `ch_entry_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `castle_tag`
--

CREATE TABLE IF NOT EXISTS `castle_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `story_id` int(11) NOT NULL,
  `tag` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `story_id` (`story_id`,`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `djang_content_type_id_697914295151027a_fk_django_content_type_id` (`content_type_id`),
  KEY `django_admin_log_user_id_52fdd58701c5f563_fk_auth_user_id` (`user_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `django_admin_log`
--

INSERT INTO `django_admin_log` (`id`, `action_time`, `object_id`, `object_repr`, `action_flag`, `change_message`, `content_type_id`, `user_id`) VALUES
(1, '2018-08-13 15:04:39', '2', 'Jim', 1, '', 4, 1),
(2, '2018-08-13 15:06:38', '2', 'Jim', 2, 'Changed first_name, last_name, email and user_permissions.', 4, 1),
(3, '2018-08-13 15:07:41', '1', 'Jim', 1, '', 7, 1),
(4, '2018-08-13 15:08:42', '1', 'Default', 1, '', 10, 1),
(5, '2018-08-13 15:09:17', '1', 'Challenge', 1, '', 9, 1),
(6, '2018-08-13 15:09:42', '1', 'Hi', 1, '', 12, 1),
(7, '2018-08-13 15:13:19', '2', 'superuser', 1, '', 7, 1);

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_45f3b1d93ec8c61c_uniq` (`app_label`,`model`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(12, 'castle', 'blog'),
(9, 'castle', 'challenge'),
(14, 'castle', 'comment'),
(15, 'castle', 'commentlike'),
(18, 'castle', 'misc'),
(7, 'castle', 'profile'),
(8, 'castle', 'prompt'),
(13, 'castle', 'rating'),
(17, 'castle', 'sitelog'),
(10, 'castle', 'story'),
(16, 'castle', 'storylog'),
(19, 'castle', 'subscription'),
(11, 'castle', 'tag'),
(5, 'contenttypes', 'contenttype'),
(20, 'notes', 'note'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2018-08-13 14:33:10'),
(2, 'auth', '0001_initial', '2018-08-13 14:33:12'),
(3, 'admin', '0001_initial', '2018-08-13 14:33:13'),
(4, 'contenttypes', '0002_remove_content_type_name', '2018-08-13 14:33:14'),
(5, 'auth', '0002_alter_permission_name_max_length', '2018-08-13 14:33:14'),
(6, 'auth', '0003_alter_user_email_max_length', '2018-08-13 14:33:14'),
(7, 'auth', '0004_alter_user_username_opts', '2018-08-13 14:33:14'),
(8, 'auth', '0005_alter_user_last_login_null', '2018-08-13 14:33:14'),
(9, 'auth', '0006_require_contenttypes_0002', '2018-08-13 14:33:14'),
(10, 'notes', '0001_initial', '2018-08-13 14:33:16'),
(11, 'sessions', '0001_initial', '2018-08-13 14:33:17');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_de54fa62` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('qviul6ol6iqamd9dp71z91m4ygc35tq5', 'OTllNDdkYzg3MDg1NWE0MzkwZGNiZjJlM2NlZjNlNjA4MGFjOTVkNzp7Il9hdXRoX3VzZXJfaGFzaCI6IjE0NDUwZDI5ZDUxOWE4ZjQ5MzEwNDNjZTVkNzQ3ZDdiMzdkOTllNzYiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=', '2018-08-27 15:04:05');

-- --------------------------------------------------------

--
-- Table structure for table `notes_note`
--

CREATE TABLE IF NOT EXISTS `notes_note` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(140) NOT NULL,
  `body` varchar(2048) NOT NULL,
  `sent_date` datetime DEFAULT NULL,
  `read_date` datetime DEFAULT NULL,
  `replied_date` datetime DEFAULT NULL,
  `sender_deleted_date` datetime DEFAULT NULL,
  `recipient_deleted_date` datetime DEFAULT NULL,
  `parent_msg_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notes_note_parent_msg_id_1308052a63e69d8a_fk_notes_note_id` (`parent_msg_id`),
  KEY `notes_note_recipient_id_68dc83e07e8d3b6e_fk_castle_profile_id` (`recipient_id`),
  KEY `notes_note_sender_id_6dbdd3e8ea7b8fd5_fk_castle_profile_id` (`sender_id`),
  KEY `notes_note_user_id_2aa1ff88fd937cb3_fk_castle_profile_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group__permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permission_group_id_689710a9a73b7457_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth__content_type_id_508cf46651277a81_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_4b5ed4ffdb8fd9b0_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_u_permission_id_384b62483d7071f0_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissi_user_id_7f0938558328534a_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_user_id_52fdd58701c5f563_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `djang_content_type_id_697914295151027a_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `notes_note`
--
ALTER TABLE `notes_note`
  ADD CONSTRAINT `notes_note_user_id_2aa1ff88fd937cb3_fk_castle_profile_id` FOREIGN KEY (`user_id`) REFERENCES `castle_profile` (`id`),
  ADD CONSTRAINT `notes_note_parent_msg_id_1308052a63e69d8a_fk_notes_note_id` FOREIGN KEY (`parent_msg_id`) REFERENCES `notes_note` (`id`),
  ADD CONSTRAINT `notes_note_recipient_id_68dc83e07e8d3b6e_fk_castle_profile_id` FOREIGN KEY (`recipient_id`) REFERENCES `castle_profile` (`id`),
  ADD CONSTRAINT `notes_note_sender_id_6dbdd3e8ea7b8fd5_fk_castle_profile_id` FOREIGN KEY (`sender_id`) REFERENCES `castle_profile` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;