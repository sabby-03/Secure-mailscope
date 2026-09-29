# SecureMailScope
AI-Assisted Cryptographic Security Posture Assessment for Secure Email Communications
(Final-Year CSE Project — Prototype)

## What this is
SecureMailScope is a prototype for **passive** security analysis of PCAP files
containing SMTP, IMAP and POP3 traffic. It never attacks, modifies, decrypts or
probes a live mail server — it only reads evidence already captured in a
network recording (a `.pcap` / `.pcapng` file) and reports on the cryptographic
health of the email sessions inside it.

## Current status
This package contains:

| Folder            | Status                | What's inside |
|-------------------|-----------------------|---------------|
| `frontend/`       | ✅ Working prototype  | Single-file HTML/CSS/JS UI, runs entirely in the browser using demo data |
| `backend/`        | 🚧 Starter scaffold   | Spring Boot skeleton (controllers + models), not wired to a real database yet |
| `python-engine/`  | 🚧 Starter scaffold   | Python module stubs for the PCAP → findings pipeline, with TODOs |
| `database/`       | ✅ Ready to run        | PostgreSQL schema matching the JSON shape the frontend expects |
| `docs/`           | ✅ Reference           | Architecture notes and the JSON contract between all layers |

The `frontend/index.html` file is a **complete, self-contained demo** — open
it directly in any browser, no install needed. Everything else in this
package is the starting skeleton for turning the demo into the real system
described in the project brief.

## Quick start (demo only)
```
Open frontend/index.html in any browser.
```
No server, no build step, no dependencies.

## Planned architecture
```
React + Tailwind  ──▶  Spring Boot API  ──▶  Python Engine  ──▶  PostgreSQL
 (frontend/)             (backend/)          (python-engine/)     (database/)
                                │
                    TShark / PyShark / Scapy
                    OpenSSL / python-cryptography
                    scikit-learn (AI-assisted risk scoring)
```

## Forensic design principle
Every finding the system reports is labeled one of:
- **OBSERVED** — directly supported by captured packet evidence
- **INFERRED** — derived from extracted features or ML analysis
- **NOT DETERMINABLE** — insufficient evidence in the PCAP (e.g. certificate
  fields inside a TLS 1.3 session, or login contents inside any TLS session)

The system never claims an attack occurred just because a weak configuration
was found.

## Next steps to make this a real (non-demo) system
1. Implement `python-engine/analysis/` functions against real PCAPs (see TODOs).
2. Stand up PostgreSQL using `database/schema.sql`.
3. Wire `backend/` controllers to call the Python engine and persist to Postgres.
4. Replace the `DEMO` constant in `frontend/index.html` with real `fetch()` calls
   to the Spring Boot API.
5. See `docs/api-contract.md` for the exact JSON shape every layer must agree on.

## Disclaimer
This is a final-year academic prototype for education/demonstration purposes.
It is not a certified security tool and should not be used to assess
production systems without proper authorization.
