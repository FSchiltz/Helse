BEGIN;

ALTER TABLE health.Event
    ADD COLUMN NotificationSent boolean NOT NULL DEFAULT FALSE;

COMMIT;
