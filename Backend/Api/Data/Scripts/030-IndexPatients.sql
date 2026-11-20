CREATE INDEX IF NOT EXISTS right_userid_type
    ON person."right" USING btree (userid, type)
    INCLUDE (personid, start, stop);

CREATE INDEX IF NOT EXISTS event_personid_type_start_idx
    ON health.Event USING btree (personid, type, start)
    INCLUDE (stop);

CREATE INDEX IF NOT EXISTS event_notification_time_pending_idx
    ON health.Event USING btree (notificationtime)
    WHERE notificationtime IS NOT NULL AND notificationsent = FALSE;

CREATE INDEX IF NOT EXISTS metric_personid_type_date_idx
    ON health.Metric USING btree (personid, type, date);
