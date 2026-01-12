-- Création du rôle dev en lecture seule
CREATE ROLE dev LOGIN PASSWORD 'dev';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO dev;

-- Application de l'anonymisation sur le role
SECURITY LABEL FOR anon ON ROLE dev IS 'MASKED';

-- Activation du masquage dynamique sur la base
ALTER DATABASE postgres
  SET anon.transparent_dynamic_masking TO true;
