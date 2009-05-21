CREATE TABLE `entries` (
  `id` int(11) NOT NULL auto_increment,
  `feed_id` int(11) default NULL,
  `title` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `author` varchar(255) default NULL,
  `summary` text,
  `content` text,
  `published` datetime default NULL,
  `categories` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `feeds` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `title` varchar(255) default NULL,
  `url` varchar(255) default NULL,
  `feed_url` varchar(255) default NULL,
  `etag` varchar(255) default NULL,
  `last_modified` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `blog_url` varchar(255) default NULL,
  `twitter_url` varchar(255) default NULL,
  `github_url` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=977805240 DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('20090520134455');

INSERT INTO schema_migrations (version) VALUES ('20090520145728');

INSERT INTO schema_migrations (version) VALUES ('20090520155946');