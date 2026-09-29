"""
Thin FastAPI wrapper so the Spring Boot backend can call the Python
engine over HTTP instead of shelling out to a script.

Run with: uvicorn api:app --reload --port 8000
"""

from fastapi import FastAPI, UploadFile
from analysis.pipeline import analyze_pcap
import shutil
import os

app = FastAPI(title="SecureMailScope Python Engine")


@app.post("/engine/analyze")
async def analyze(file: UploadFile):
    """
    Accepts a .pcap/.pcapng upload from the Spring Boot backend,
    saves it temporarily, runs the pipeline, and returns the result
    as JSON matching docs/api-contract.md.
    """
    tmp_path = f"/tmp/{file.filename}"
    with open(tmp_path, "wb") as f:
        shutil.copyfileobj(file.file, f)

    try:
        result = analyze_pcap(tmp_path)  # TODO: implement pipeline first
    finally:
        os.remove(tmp_path)

    return result


@app.get("/engine/health")
async def health():
    return {"status": "ok"}
