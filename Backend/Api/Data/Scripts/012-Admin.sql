
-- User move to the new flag
UPDATE person.User SET Type = 4 where Type = 1;

-- Caregiver move to the new flag
UPDATE person.User SET Type = 6 where Type = 3;

-- Admin move to the new flag
UPDATE person.User SET Type = 1 where Type = 2;