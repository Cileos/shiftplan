CREATE TABLE "allocations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "requirement_id" integer, "employee_id" integer, "workplace_id" integer, "start" datetime, "end" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "employees" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "last_name" varchar(255), "birthday" date, "active" boolean DEFAULT 't', "email" varchar(255), "phone" varchar(255), "street" varchar(255), "zipcode" varchar(255), "city" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "requirements" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "workplace_id" integer, "start" datetime, "end" datetime, "quantity" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "taggings" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tag_id" integer, "taggable_id" integer, "tagger_id" integer, "tagger_type" varchar(255), "taggable_type" varchar(255), "context" varchar(255), "created_at" datetime);
CREATE TABLE "tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255));
CREATE TABLE "workplace_requirements" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "workplace_id" integer, "qualification_id" integer, "quantity" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "workplaces" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "color" varchar(6), "active" boolean DEFAULT 't', "created_at" datetime, "updated_at" datetime);
CREATE INDEX "index_taggings_on_tag_id" ON "taggings" ("tag_id");
CREATE INDEX "index_taggings_on_taggable_id_and_taggable_type_and_context" ON "taggings" ("taggable_id", "taggable_type", "context");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090621144700');

INSERT INTO schema_migrations (version) VALUES ('20090808093505');

INSERT INTO schema_migrations (version) VALUES ('20090808094212');

INSERT INTO schema_migrations (version) VALUES ('20090808170413');

INSERT INTO schema_migrations (version) VALUES ('20090905154438');

INSERT INTO schema_migrations (version) VALUES ('20090906151345');