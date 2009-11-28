CREATE TABLE "accounts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "assignments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "requirement_id" integer, "assignee_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "employee_qualifications" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "employee_id" integer, "qualification_id" integer);
CREATE TABLE "employees" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account_id" integer, "first_name" varchar(255), "last_name" varchar(255), "initials" varchar(10), "birthday" date, "active" boolean DEFAULT 't', "email" varchar(255), "phone" varchar(255), "street" varchar(255), "zipcode" varchar(255), "city" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "locations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account_id" integer, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "memberships" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "account_id" integer, "admin" boolean DEFAULT 'f', "created_at" datetime, "updated_at" datetime);
CREATE TABLE "plans" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account_id" integer, "name" varchar(255), "start_date" date, "end_date" date, "created_at" datetime, "updated_at" datetime, "start_time" time, "end_time" time);
CREATE TABLE "qualifications" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account_id" integer, "name" varchar(255), "color" varchar(6), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "requirements" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "shift_id" integer, "qualification_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "shifts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "plan_id" integer, "workplace_id" integer, "start" datetime, "end" datetime, "duration" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "statuses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "employee_id" integer, "day_of_week" integer(1), "start" time, "end" time, "created_at" datetime, "updated_at" datetime, "day" date, "status" varchar(20));
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "encrypted_password" varchar(128), "salt" varchar(128), "confirmation_token" varchar(128), "remember_token" varchar(128), "email_confirmed" boolean DEFAULT 'f' NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "workplace_qualifications" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "workplace_id" integer, "qualification_id" integer);
CREATE TABLE "workplace_requirements" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "workplace_id" integer, "qualification_id" integer, "quantity" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "workplaces" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "account_id" integer, "location_id" integer, "name" varchar(255), "color" varchar(6), "default_shift_length" integer, "active" boolean DEFAULT 't', "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "index_memberships_on_user_id_and_account_id" ON "memberships" ("user_id", "account_id");
CREATE INDEX "index_users_on_email" ON "users" ("email");
CREATE INDEX "index_users_on_id_and_confirmation_token" ON "users" ("id", "confirmation_token");
CREATE INDEX "index_users_on_remember_token" ON "users" ("remember_token");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20090621144700');

INSERT INTO schema_migrations (version) VALUES ('20090808093505');

INSERT INTO schema_migrations (version) VALUES ('20090906151345');

INSERT INTO schema_migrations (version) VALUES ('20090920153145');

INSERT INTO schema_migrations (version) VALUES ('20090920155007');

INSERT INTO schema_migrations (version) VALUES ('20090920155743');

INSERT INTO schema_migrations (version) VALUES ('20090926154617');

INSERT INTO schema_migrations (version) VALUES ('20090926155713');

INSERT INTO schema_migrations (version) VALUES ('20090926161450');

INSERT INTO schema_migrations (version) VALUES ('20090926162545');

INSERT INTO schema_migrations (version) VALUES ('20090927165849');

INSERT INTO schema_migrations (version) VALUES ('20091003161415');

INSERT INTO schema_migrations (version) VALUES ('20091003161422');

INSERT INTO schema_migrations (version) VALUES ('20091003161427');

INSERT INTO schema_migrations (version) VALUES ('20091108140858');

INSERT INTO schema_migrations (version) VALUES ('20091115151733');

INSERT INTO schema_migrations (version) VALUES ('20091122152444');

INSERT INTO schema_migrations (version) VALUES ('20091128145750');