
CREATE INDEX healthMetricSourcid ON health.Metric (PersonId, Source,SourceId, Type);
CREATE INDEX healthEventSourcid ON health.Event (PersonId, Source,SourceId, Type);
