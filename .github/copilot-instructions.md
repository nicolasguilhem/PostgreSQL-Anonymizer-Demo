# Repository-Wide Copilot Instructions

## Overview
- Purpose: This repository demonstrates the PostgreSQL Anonymizer extension using a containerized PostgreSQL 17 instance and a small demo schema.
- Copilot goals: Assist with SQL and shell snippets, container commands, anonymization policies, and small documentation updates that align with this repo’s structure. Keep changes minimal and focused; avoid broad restructuring.

## Environment
- Database: PostgreSQL 17 (required).
- Runtime: Containerized database built from sources under [container/Dockerfile](container/Dockerfile) and initialized by scripts in [container](container).
- Tools: Docker.
- Extension: PostgreSQL Anonymizer (`anon`). Favor declarative masking policies and privacy-preserving defaults.

## Setup & Run
Build and run the container from the `container` directory.

```bash
# Docker
docker build -t pg-anon-demo ./container
docker run --name pg-anon-demo -p 5432:5432 pg-anon-demo
```

Connect to the database:

```bash
psql -h localhost -U postgres -d postgres
```

Notes:
- Initialization scripts and schema DDL are located under [container](container). Adjust commands/env vars to match your local setup if they differ.
- The anonymizer extension should be installed and configured by the container’s init logic (see [container/init_anon.sh](container/init_anon.sh) if present).

## Schema & Files
- Container sources: [container/Dockerfile](container/Dockerfile), [container/init_anon.sh](container/init_anon.sh)
- Schema DDL: [container/sql/0-schema/01_create_adresse_table.sql](container/sql/0-schema/01_create_adresse_table.sql), [container/sql/0-schema/02_create_joueur_table.sql](container/sql/0-schema/02_create_joueur_table.sql), [container/sql/0-schema/03_create_evenement_table.sql](container/sql/0-schema/03_create_evenement_table.sql), [container/sql/0-schema/04_create_sponsor_table.sql](container/sql/0-schema/04_create_sponsor_table.sql), [container/sql/0-schema/05_create_participant_table.sql](container/sql/0-schema/05_create_participant_table.sql), [container/sql/0-schema/06_create_financement_table.sql](container/sql/0-schema/06_create_financement_table.sql)
- Documentation: [doc/database_schema.puml](doc/database_schema.puml)
- Top-level readme: [README.md](README.md)

## Coding & Editing Guidelines
- Minimal diffs: Keep changes small, focused, and consistent with existing style.
- No license headers: Do not add copyright/license headers unless explicitly requested.
- Comments: Avoid inline code comments unless asked.
- File placement:
	- SQL DDL and schema changes go under [container/sql/0-schema](container/sql/0-schema).
	- Initialization and anonymizer-related setup belong in [container/init_anon.sh](container/init_anon.sh) or equivalent init scripts.
	- Do not restructure directories or introduce new frameworks/services.
- Anonymizer usage:
	- Prefer declarative masking policies (e.g., `SECURITY LABEL FOR anon` on columns) rather than ad-hoc transformations.
	- Focus masking on personally identifiable information (PII), such as names, birthdates, emails, phone numbers, and addresses.
	- Use realistic yet privacy-preserving examples; never include real personal data.

## Copilot Behavior
- PostgreSQL 17 compatibility: Generate SQL and shell snippets compatible with PostgreSQL 17.
- Anonymizer best practices: Favor policy-based masking and minimal exposure of sensitive data.

## Conventions
- SQL style:
	- Snake_case identifiers; keep naming consistent with existing files.
	- Uppercase SQL keywords; one statement per line.
	- Use types already present in the schema files when extending (e.g., `JSONB`, `BYTEA`, numeric types).
	- Prefer explicit constraints, indexes, and `COMMENT ON` where helpful.
- Container commands:
	- Primary patterns: `docker build -t pg-anon-demo ./container` and `docker run --name pg-anon-demo -p 5432:5432 pg-anon-demo`.

## Testing & Validation
Don't add formal tests. Validate changes by:
- Running the container and connecting via `psql`.
- Testing presence of anonymization policies.

## Scope & Non-Goals
- In scope: SQL adjustments, anonymization policies, container tweaks aligned with current setup, small doc updates.
- Out of scope: Changing the PostgreSQL version, adding third-party services, broad directory restructuring, or massive refactors.

## Useful Commands
```bash
# Stop/remove the container
docker stop pg-anon-demo && docker rm pg-anon-demo

# Connect using psql inside the container (Docker)
docker exec -it pg-anon-demo psql -U postgres -d postgres
```

## Links & Paths
- Container: [container/Dockerfile](container/Dockerfile), [container/init_anon.sh](container/init_anon.sh)
- Schema DDL: [container/sql/0-schema](container/sql/0-schema)
- Documentation: [doc/database_schema.puml](doc/database_schema.puml)
- Readme: [README.md](README.md)
