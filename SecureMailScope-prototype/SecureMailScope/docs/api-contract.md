# API Contract

This is the JSON shape every layer must agree on. It matches the `DEMO`
object already used in `frontend/index.html`, so swapping demo data for
real data is a drop-in replacement.

```json
{
  "pcap": {
    "name": "capture.pcapng",
    "size": "4.8 MB",
    "packets": 12874,
    "protocols": ["TCP", "SMTP", "IMAP", "POP3", "TLS"],
    "sessions": 8,
    "ts": "2026-09-29 10:00:00"
  },
  "sessions": [
    {
      "id": "S-01",
      "proto": "SMTP",
      "src": "10.0.0.14:51322",
      "dst": "203.0.113.25:587",
      "st": "STARTTLS ok",
      "tls": "TLS 1.3",
      "cipher": "TLS_AES_256_GCM_SHA384",
      "kex": "ECDHE (x25519)",
      "fs": true,
      "cert": 0,
      "anom": 0.08
    }
  ],
  "certs": [
    {
      "subj": "mail.example.org",
      "iss": "Example Trust CA R3",
      "from": "2026-03-01",
      "to": "2027-03-01",
      "exp": "Valid",
      "pk": "ECDSA P-256",
      "bits": 256,
      "sig": "ecdsa-with-SHA256",
      "chain": "Complete"
    }
  ],
  "auth": [
    {
      "sess": "S-05",
      "proto": "POP3",
      "mech": "USER/PASS",
      "prot": false,
      "note": "Credentials sent in cleartext on port 110"
    }
  ],
  "findings": [
    {
      "id": "F-01",
      "sev": "Critical",
      "proto": "POP3",
      "sess": "S-05",
      "issue": "Cleartext POP3, no STARTTLS offered",
      "ev": "Server replied to CAPA without STLS; no TLS ClientHello in stream.",
      "why": "Credentials and mail traverse the network unencrypted.",
      "fix": "Enable STLS or move to POP3S (995); disable port 110.",
      "score": 96,
      "st": "OBSERVED",
      "conf": "High"
    }
  ]
}
```

## Field notes
- `fs` (forward secrecy): `true` / `false` / `null` if not determinable.
- `cert`: index into the `certs` array, or `null` if no certificate was
  visible (e.g. TLS 1.3 without a supplied key log).
- `st` (basis) on findings: one of `OBSERVED`, `INFERRED`, `NOT DETERMINABLE`.
  Never mark something OBSERVED unless it was literally visible in the
  packet capture.
- `anom`: 0–1 anomaly score from the ML layer. Always described in the UI
  as "AI-assisted analysis," never as proof of compromise.

## Endpoints (planned)
| Method | Path                          | Purpose |
|--------|-------------------------------|---------|
| POST   | `/api/analyses`               | Upload a PCAP, kick off analysis |
| GET    | `/api/analyses/{id}`          | Fetch the result in the shape above |
| GET    | `/api/analyses/{id}/report`   | Generate JSON/HTML report |
| POST   | `/engine/analyze` (Python)    | Internal: backend → engine |
