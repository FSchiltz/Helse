ALTER TABLE
    health.Event
ADD
    COLUMN NotificationSent boolean NOT NULL DEFAULT FALSE;

ALTER TABLE
    health.Event
ADD
    COLUMN NotificationTime timestamp NULL;