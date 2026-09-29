package com.securemailscope.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * Skeleton REST controller for SecureMailScope.
 *
 * Intended flow:
 *   1. POST /api/analyses          -> save the uploaded PCAP, create an
 *                                      "analyses" row (status=pending),
 *                                      forward the file to the Python
 *                                      engine (FastAPI on :8000), store
 *                                      the returned JSON into Postgres.
 *   2. GET  /api/analyses/{id}     -> return the stored analysis result,
 *                                      in the same JSON shape the
 *                                      frontend's DEMO constant uses
 *                                      (see docs/api-contract.md).
 *   3. GET  /api/analyses/{id}/report?format=json|html
 *                                   -> return a generated report.
 *
 * None of the logic below is implemented yet — this is the scaffold
 * the real service/repository layers plug into.
 */
@RestController
@RequestMapping("/api/analyses")
public class AnalysisController {

    @PostMapping
    public Map<String, Object> uploadAndAnalyze(@RequestParam("file") MultipartFile file) {
        // TODO: 1) store file, 2) call Python engine at /engine/analyze,
        //       3) persist sessions/certificates/findings via JPA repos,
        //       4) return {"analysisId": ..., "status": "pending"}
        throw new UnsupportedOperationException("Not implemented yet");
    }

    @GetMapping("/{id}")
    public Map<String, Object> getAnalysis(@PathVariable Long id) {
        // TODO: load from repository and shape into the frontend's JSON contract
        throw new UnsupportedOperationException("Not implemented yet");
    }

    @GetMapping("/{id}/report")
    public Object getReport(@PathVariable Long id, @RequestParam(defaultValue = "json") String format) {
        // TODO: build JSON/HTML report from stored findings
        throw new UnsupportedOperationException("Not implemented yet");
    }
}
