ALTER TABLE health.MetricType ADD COLUMN IF NOT EXISTS summaryType  BIGINT NOT NULL DEFAULT 0;
ALTER TABLE health.MetricType ALTER COLUMN summaryType DROP DEFAULT;

ALTER TABLE health.MetricType ADD COLUMN IF NOT EXISTS Type BIGINT NOT NULL DEFAULT 0;
ALTER TABLE health.MetricType ALTER COLUMN Type DROP DEFAULT;
