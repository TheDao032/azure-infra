CREATE ROLE ntucreadonly WITH ENCRYPTED PASSWORD '${ntucreadonlyPassword}';
CREATE ROLE ntucadmin WITH ENCRYPTED PASSWORD '${ntucadminPassword}';

CREATE ROLE ${dumpuserServiceDatabaseUsername} WITH ENCRYPTED PASSWORD '${dumpuserServiceDatabasePassword}';
GRANT ${dumpuserServiceDatabaseUsername} TO ${databaseMasterUsername};
CREATE DATABASE ${dumpuserServiceDatabase} OWNER ${dumpuserServiceDatabaseUsername};

\\\c ${dumpuserServiceDatabase}
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ntucreadonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO ntucreadonly;
