SECURITY LABEL FOR anon ON COLUMN sponsor.logo
IS 'MASKED WITH FUNCTION anon.image_blur(logo, 7.0)';

SECURITY LABEL FOR anon ON COLUMN sponsor.id
IS 'NOT MASKED';
