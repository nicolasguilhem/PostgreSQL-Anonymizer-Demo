ALTER DATABASE postgres SET session_preload_libraries = 'anon';
CREATE EXTENSION anon;
SELECT anon.init();