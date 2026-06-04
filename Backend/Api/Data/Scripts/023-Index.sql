
CREATE INDEX healthMetricSourcid ON health.Metric (SourceId) INCLUDE (PersonId, Source, Type);
CREATE INDEX healthEventSourcid ON health.Event (SourceId) INCLUDE (PersonId, Source, Type);
