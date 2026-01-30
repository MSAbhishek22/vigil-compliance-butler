-- Vigil Database Schema

CREATE TABLE IF NOT EXISTS source_documents (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  url TEXT,
  file_path TEXT,
  file_type TEXT NOT NULL,
  status TEXT NOT NULL,
  title TEXT,
  raw_content TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS requirements (
  id SERIAL PRIMARY KEY,
  source_document_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  deadline TIMESTAMP WITHOUT TIME ZONE,
  is_mandatory BOOLEAN NOT NULL DEFAULT FALSE,
  status TEXT NOT NULL,
  proof_url TEXT,
  depends_on_id INTEGER,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

CREATE TABLE IF NOT EXISTS vigil_jobs (
  id SERIAL PRIMARY KEY,
  requirement_id INTEGER NOT NULL,
  reminder_type TEXT NOT NULL,
  scheduled_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  executed_at TIMESTAMP WITHOUT TIME ZONE,
  status TEXT NOT NULL,
  notification_sent BOOLEAN NOT NULL DEFAULT FALSE,
  error_message TEXT
);
