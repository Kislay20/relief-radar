BEGIN;

--
-- CREATE VECTOR EXTENSION IF AVAILABLE
--
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'vector') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS vector';
  ELSE
    RAISE EXCEPTION 'Required extension "vector" is not available on this instance. Please install pgvector. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-pgvector.';
  END IF;
END
$$;

--
-- CREATE POSTGIS EXTENSION IF AVAILABLE
--
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'postgis') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS postgis';
  ELSE
    RAISE EXCEPTION 'Required extension "postgis" is not available on this instance. Please install PostGIS. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-postgis.';
  END IF;
END
$$;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "assignment" (
    "id" bigserial PRIMARY KEY,
    "incidentId" bigint NOT NULL,
    "responderId" bigint NOT NULL,
    "status" text NOT NULL,
    "offeredAtLevel" bigint NOT NULL,
    "offeredAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "respondedAt" timestamp without time zone,
    "etaMinutes" bigint
);

-- Indexes
CREATE UNIQUE INDEX "assignment_incident_responder_uq" ON "assignment" USING btree ("incidentId", "responderId");
CREATE INDEX "assignment_responder_status_idx" ON "assignment" USING btree ("responderId", "status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "disaster_zone" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "kind" text NOT NULL,
    "center" geography(Point,4326) NOT NULL,
    "bounds" geography(Polygon,4326),
    "active" boolean NOT NULL DEFAULT true,
    "timeScale" double precision NOT NULL DEFAULT 1.0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "disaster_zone_center_idx" ON "disaster_zone" USING gist ("center");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "event" (
    "id" bigserial PRIMARY KEY,
    "streamId" text NOT NULL,
    "seq" bigint NOT NULL,
    "type" text NOT NULL,
    "incidentId" bigint,
    "payload" jsonb NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "event_stream_seq_uq" ON "event" USING btree ("streamId", "seq");
CREATE INDEX "event_incident_idx" ON "event" USING btree ("incidentId");
CREATE INDEX "event_payload_gin_idx" ON "event" USING gin ("payload" jsonb_path_ops);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "incident" (
    "id" bigserial PRIMARY KEY,
    "zoneId" bigint NOT NULL,
    "needType" text NOT NULL,
    "status" text NOT NULL,
    "severity" bigint NOT NULL,
    "headcount" bigint,
    "vulnerabilities" json NOT NULL,
    "summary" text NOT NULL,
    "centroid" geography(Point,4326) NOT NULL,
    "centroidEmbedding" vector(768),
    "accuracyRadiusM" double precision NOT NULL,
    "reportCount" bigint NOT NULL DEFAULT 1,
    "firstReportAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastReportAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "baseSlaSeconds" bigint NOT NULL,
    "escalationLevel" bigint NOT NULL DEFAULT 0,
    "dispatchRadiusM" double precision NOT NULL,
    "levelStartedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "nextEscalationAt" timestamp without time zone,
    "assignedResponderId" bigint,
    "acceptedAt" timestamp without time zone,
    "resolvedAt" timestamp without time zone,
    "mergedIntoId" bigint,
    "version" bigint NOT NULL DEFAULT 0
);

-- Indexes
CREATE INDEX "incident_centroid_gist_idx" ON "incident" USING gist ("centroid");
CREATE INDEX "incident_embedding_hnsw_idx" ON "incident" USING hnsw ("centroidEmbedding" vector_cosine_ops) WITH (m=16, ef_construction=64);
CREATE INDEX "incident_zone_status_idx" ON "incident" USING btree ("zoneId", "status");
CREATE INDEX "incident_next_escalation_idx" ON "incident" USING btree ("nextEscalationAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "report" (
    "id" bigserial PRIMARY KEY,
    "zoneId" bigint NOT NULL,
    "clientReportId" uuid NOT NULL,
    "reporterKey" text NOT NULL,
    "rawText" text NOT NULL,
    "hasImage" boolean NOT NULL DEFAULT false,
    "clientLocation" geography(Point,4326),
    "locationAccuracyM" double precision,
    "clientCreatedAt" timestamp without time zone NOT NULL,
    "receivedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" text NOT NULL,
    "failureReason" text,
    "structured" jsonb,
    "embedding" vector(768),
    "incidentId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "report_client_id_uq" ON "report" USING btree ("clientReportId");
CREATE INDEX "report_zone_status_idx" ON "report" USING btree ("zoneId", "status");
CREATE INDEX "report_incident_idx" ON "report" USING btree ("incidentId");
CREATE INDEX "report_location_idx" ON "report" USING gist ("clientLocation");
CREATE INDEX "report_structured_gin_idx" ON "report" USING gin ("structured" jsonb_path_ops);
CREATE INDEX "report_embedding_hnsw_idx" ON "report" USING hnsw ("embedding" vector_cosine_ops) WITH (m=16, ef_construction=64);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "report_media" (
    "id" bigserial PRIMARY KEY,
    "reportId" bigint NOT NULL,
    "mime" text NOT NULL,
    "bytes" bytea NOT NULL,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "report_media_report_idx" ON "report_media" USING btree ("reportId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "responder" (
    "id" bigserial PRIMARY KEY,
    "authUserId" uuid NOT NULL,
    "displayName" text NOT NULL,
    "capabilities" json NOT NULL,
    "capacity" bigint NOT NULL DEFAULT 1,
    "status" text NOT NULL,
    "location" geography(Point,4326),
    "lastSeenAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "responder_auth_user_uq" ON "responder" USING btree ("authUserId");
CREATE INDEX "responder_location_gist_idx" ON "responder" USING gist ("location");
CREATE INDEX "responder_status_idx" ON "responder" USING btree ("status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "stream_head" (
    "id" bigserial PRIMARY KEY,
    "streamId" text NOT NULL,
    "headSeq" bigint NOT NULL DEFAULT 0,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "stream_head__streamId__unique_idx" ON "stream_head" USING btree ("streamId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "assignment"
    ADD CONSTRAINT "assignment_fk_0"
    FOREIGN KEY("incidentId")
    REFERENCES "incident"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "assignment"
    ADD CONSTRAINT "assignment_fk_1"
    FOREIGN KEY("responderId")
    REFERENCES "responder"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "incident"
    ADD CONSTRAINT "incident_fk_0"
    FOREIGN KEY("zoneId")
    REFERENCES "disaster_zone"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "incident"
    ADD CONSTRAINT "incident_fk_1"
    FOREIGN KEY("assignedResponderId")
    REFERENCES "responder"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "report"
    ADD CONSTRAINT "report_fk_0"
    FOREIGN KEY("zoneId")
    REFERENCES "disaster_zone"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "report"
    ADD CONSTRAINT "report_fk_1"
    FOREIGN KEY("incidentId")
    REFERENCES "incident"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "report_media"
    ADD CONSTRAINT "report_media_fk_0"
    FOREIGN KEY("reportId")
    REFERENCES "report"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR relief_radar
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('relief_radar', '20261001142523897', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261001142523897', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
