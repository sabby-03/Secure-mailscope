-- SecureMailScope database schema (PostgreSQL)
-- Matches the JSON contract used by frontend/index.html's DEMO object.

CREATE TABLE analyses (
    id              SERIAL PRIMARY KEY,
    pcap_name       VARCHAR(255) NOT NULL,
    capture_size    VARCHAR(50),
    packet_count    INTEGER,
    protocols       TEXT[],           -- e.g. {SMTP,IMAP,POP3,TLS}
    session_count   INTEGER,
    status          VARCHAR(50) DEFAULT 'pending',   -- pending | running | complete | failed
    posture_score   INTEGER,
    created_at      TIMESTAMP DEFAULT now()
);

CREATE TABLE sessions (
    id              SERIAL PRIMARY KEY,
    analysis_id     INTEGER REFERENCES analyses(id) ON DELETE CASCADE,
    session_label   VARCHAR(20),      -- e.g. S-01
    protocol        VARCHAR(10),      -- SMTP | IMAP | POP3
    src_ip_port     VARCHAR(50),
    dst_ip_port     VARCHAR(50),
    starttls_status VARCHAR(100),
    tls_version     VARCHAR(20),
    cipher_suite    VARCHAR(100),
    key_exchange    VARCHAR(50),
    forward_secrecy BOOLEAN,          -- NULL = not determinable
    anomaly_score   NUMERIC(4,3)      -- AI-assisted, 0.000–1.000
);

CREATE TABLE certificates (
    id              SERIAL PRIMARY KEY,
    session_id      INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    subject         VARCHAR(255),
    issuer          VARCHAR(255),
    valid_from      DATE,
    valid_to        DATE,
    expiry_status   VARCHAR(50),      -- Valid | Expires soon | EXPIRED
    public_key_algo VARCHAR(50),
    key_bits        INTEGER,
    signature_algo  VARCHAR(50),
    chain_status    VARCHAR(100)
);

CREATE TABLE auth_events (
    id              SERIAL PRIMARY KEY,
    session_id      INTEGER REFERENCES sessions(id) ON DELETE CASCADE,
    mechanism       VARCHAR(50),      -- AUTH LOGIN | AUTH PLAIN | XOAUTH2 | SCRAM-SHA-256 | USER/PASS
    protected_by_tls BOOLEAN,
    note            TEXT
    -- Usernames, passwords and tokens are intentionally never stored.
);

CREATE TABLE findings (
    id              SERIAL PRIMARY KEY,
    analysis_id     INTEGER REFERENCES analyses(id) ON DELETE CASCADE,
    session_id      INTEGER REFERENCES sessions(id),
    severity        VARCHAR(20),      -- Critical | High | Medium | Low | Informational
    protocol        VARCHAR(10),
    issue           TEXT,
    evidence        TEXT,
    reason          TEXT,
    remediation     TEXT,
    risk_score      INTEGER,
    basis           VARCHAR(20),      -- OBSERVED | INFERRED | NOT DETERMINABLE
    confidence      VARCHAR(20)       -- High | Medium | Low | n/a
);

CREATE INDEX idx_sessions_analysis   ON sessions(analysis_id);
CREATE INDEX idx_findings_analysis   ON findings(analysis_id);
CREATE INDEX idx_findings_severity   ON findings(severity);
