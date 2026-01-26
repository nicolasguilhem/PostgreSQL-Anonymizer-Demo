-- Création du rôle dev en lecture seule
CREATE ROLE dev LOGIN PASSWORD 'dev';

-- Application de l'anonymisation sur le role
SECURITY LABEL FOR anon ON ROLE dev IS 'MASKED';

-- Activation du masquage dynamique sur la base
ALTER DATABASE postgres
  SET anon.transparent_dynamic_masking TO true;

-- Schéma pour les fonctions de masquage personnalisées
CREATE SCHEMA custom_masks;
GRANT USAGE ON SCHEMA custom_masks TO dev;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA custom_masks TO dev;
