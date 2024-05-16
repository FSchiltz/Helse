	
DROP INDEX health.metric_date_type_personid_idx;


CREATE INDEX IF NOT EXISTS metric_date_type_personid_idx
    ON health.metric USING btree
    (date ASC NULLS LAST)
    INCLUDE(type, personid, value);