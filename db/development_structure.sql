CREATE TABLE "allocations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "employee_id" integer, "workplace_id" integer, "start" datetime, "end" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "employees" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "last_name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "workplaces" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090621144700');

INSERT INTO schema_migrations (version) VALUES ('20090808093505');

INSERT INTO schema_migrations (version) VALUES ('20090808094212');