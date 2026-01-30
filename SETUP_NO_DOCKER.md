# Setting Up Vigil Without Docker (Manual Mode)

Since we are not using Docker and encountered issues with Serverpod's automatic generation tools, we have configured the project manually.

## 1. Database Setup (Completed)
- PostgreSQL 16 is installed and running.
- Database `vigil` exists.
- User `postgres` / password `postgres`.
- Tables `source_documents`, `requirements`, `vigil_jobs` created manually via `schema.sql`.

## 2. Server Setup (Completed)
- Dart SDK 3.5.4 installed.
- Dependencies installed.
- **IMPORTANT**: Do NOT run `serverpod generate` unless you backup the `lib/src/generated` folder.
- Server is running on `http://localhost:8080`.
- Manual SQL queries are used instead of Serverpod ORM for reliability in this specific environment.

## 3. Client Setup (Completed)
- `vigil_client` code generated manually to match the server.
- Dependencies installed.

## 4. Flutter App (Running)
- Flutter SDK 3.24.0 installed.
- App configured to connect to localhost:8080.
- Theme: Dark "Butler" theme.

## Troubleshooting
If the server stops or crashes:
1. Verify PostgreSQL is running: `pg_isready -h localhost -p 5432`
2. Run server: `cd vigil_server && dart run bin/main.dart`
3. If database errors occur, ensure tables exist using `psql`.

If the Flutter app fails to connect:
- Ensure server is running.
- Check if firewall blocks port 8080.
- Restart the app.

## Development Notes
- The models `SourceDocument`, `Requirement`, `VigilJob` are defined in `vigil_server/lib/src/generated/`.
- If you change the database schema, you must manually update these files AND the `vigil_client/lib/src/protocol/` files.
