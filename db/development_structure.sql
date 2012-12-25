CREATE TABLE "players" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "licence" integer, "name" varchar(255), "first_name" varchar(255), "club" varchar(255), "ranking" integer, "woman_ranking" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20091225153518');