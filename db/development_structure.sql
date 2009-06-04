CREATE TABLE "entries" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "feed_id" integer, "title" varchar(255), "url" varchar(255), "author" varchar(255), "summary" text, "content" text, "published" datetime, "categories" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "feeds" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "title" varchar(255), "url" varchar(255), "feed_url" varchar(255), "etag" varchar(255), "last_modified" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "projects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "description" text, "url" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "projects_users" ("project_id" integer, "user_id" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "email" varchar(255), "blog_url" varchar(255), "twitter_url" varchar(255), "github_url" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090520134455');

INSERT INTO schema_migrations (version) VALUES ('20090520145728');

INSERT INTO schema_migrations (version) VALUES ('20090520155946');

INSERT INTO schema_migrations (version) VALUES ('20090528214708');