CREATE TABLE "admins" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "salt" varchar(255), "email" varchar(255), "hashed_password" varchar(255), "token" varchar(255), "tournament_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "inscription_players" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "inscription_id" integer, "player_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "inscriptions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tournament_id" integer, "licence" integer, "name" varchar(255), "email" varchar(255), "token" varchar(255), "created_at" datetime, "updated_at" datetime, "salt" varchar(255), "secret" varchar(255));
CREATE TABLE "play_series" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "inscription_player_id" integer, "series_id" integer, "created_at" datetime, "updated_at" datetime, "partner_id" integer);
CREATE TABLE "players" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "licence" integer, "name" varchar(255), "first_name" varchar(255), "club" varchar(255), "ranking" integer, "woman_ranking" integer, "created_at" datetime, "updated_at" datetime, "category" varchar(255) DEFAULT '-', "rank" integer, "woman_rank" integer);
CREATE TABLE "quarks" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "age" integer, "price" decimal, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "series" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "series_name" varchar(255), "long_name" varchar(255), "start_time" time, "min_ranking" integer, "max_ranking" integer, "category" varchar(255), "sex" varchar(255), "created_at" datetime, "updated_at" datetime, "tournament_day_id" integer DEFAULT 1, "use_rank" integer, "type" varchar(255));
CREATE TABLE "tournament_days" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tournament_id" integer, "day" date, "max_inscriptions" integer, "created_at" datetime, "updated_at" datetime, "series_per_day" integer, "max_single_series" integer, "max_double_series" integer, "max_age_series" integer, "last_inscription_time" datetime);
CREATE TABLE "tournaments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tour_id" varchar(255), "name" varchar(255), "date" varchar(255), "info_link" varchar(255), "organiser" varchar(255), "created_at" datetime, "updated_at" datetime, "logo" varchar(255), "stylesheet" varchar(255), "sender_email" varchar(255), "bcc_email" varchar(255), "facebook_link" varchar(255), "layout_parser" varchar(255), "favicon" text, "last_inscription_time" datetime);
CREATE TABLE "waiting_list_entries" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tournament_day_id" integer, "inscription_player_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "waiting_list_series" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "waiting_list_entry_id" integer, "series_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20091225153518');

INSERT INTO schema_migrations (version) VALUES ('20091228213237');

INSERT INTO schema_migrations (version) VALUES ('20100101182711');

INSERT INTO schema_migrations (version) VALUES ('20100102121007');

INSERT INTO schema_migrations (version) VALUES ('20100102213824');

INSERT INTO schema_migrations (version) VALUES ('20100204013148');

INSERT INTO schema_migrations (version) VALUES ('20100214164316');

INSERT INTO schema_migrations (version) VALUES ('20100331224237');

INSERT INTO schema_migrations (version) VALUES ('20100501124614');

INSERT INTO schema_migrations (version) VALUES ('20100506020210');

INSERT INTO schema_migrations (version) VALUES ('20100511062438');

INSERT INTO schema_migrations (version) VALUES ('20100511091738');

INSERT INTO schema_migrations (version) VALUES ('20100529233535');

INSERT INTO schema_migrations (version) VALUES ('20100605152742');

INSERT INTO schema_migrations (version) VALUES ('20100606163647');

INSERT INTO schema_migrations (version) VALUES ('20100620150206');

INSERT INTO schema_migrations (version) VALUES ('20100623171207');

INSERT INTO schema_migrations (version) VALUES ('20100626015234');

INSERT INTO schema_migrations (version) VALUES ('20120109154240');

INSERT INTO schema_migrations (version) VALUES ('20120120151553');

INSERT INTO schema_migrations (version) VALUES ('20120120154508');

INSERT INTO schema_migrations (version) VALUES ('20120123142026');

INSERT INTO schema_migrations (version) VALUES ('20120126110817');

INSERT INTO schema_migrations (version) VALUES ('20120710224804');

INSERT INTO schema_migrations (version) VALUES ('20130701000406');

INSERT INTO schema_migrations (version) VALUES ('20130917182014');

INSERT INTO schema_migrations (version) VALUES ('20130918065320');

INSERT INTO schema_migrations (version) VALUES ('20130918065600');