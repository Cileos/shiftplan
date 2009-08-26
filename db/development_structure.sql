CREATE TABLE "allocations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "requirement_id" integer, "employee_id" integer, "workplace_id" integer, "start" datetime, "end" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "employees" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "last_name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "requirements" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "workplace_id" integer, "start" datetime, "end" datetime, "quantity" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "workplaces" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "color" varchar(6), "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090621144700');

INSERT INTO schema_migrations (version) VALUES ('20090808093505');

INSERT INTO schema_migrations (version) VALUES ('20090808094212');

INSERT INTO schema_migrations (version) VALUES ('20090808170413');