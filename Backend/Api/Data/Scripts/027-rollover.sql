ALTER TABLE
    health.MetricType
ADD
    COLUMN TimeDifference INTERVAL NULL;

ALTER TABLE
    health.EventType
ADD
    COLUMN TimeDifference INTERVAL NULL;