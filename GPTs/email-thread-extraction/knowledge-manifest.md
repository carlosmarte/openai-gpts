# Knowledge File Manifest: email-thread-extraction

## File Manifest

| # | File Name | Format | Purpose | Size Est. |
|---|-----------|--------|---------|-----------|
| 1 | raci-matrix-guide.md | MD | RACI role definitions, linguistic indicators, and inference logic | ~4 KB |
| 2 | extraction-schemas.md | MD | Structured output schemas and field definitions for all artifact types | ~6 KB |
| 3 | email-preprocessing-rules.md | MD | Deduplication heuristics, entity resolution patterns, and email parsing rules | ~3 KB |

## File Details

### 1. raci-matrix-guide.md

- **Purpose:** Provides the GPT with a detailed reference for inferring RACI roles from email thread content. Includes linguistic markers, metadata signals (CC/BCC patterns), and deduction rules that the system instructions reference but cannot fully contain within the 8000-character limit.
- **Content:**
  - RACI role definitions with enterprise context
  - Table of linguistic indicators mapped to each role (Responsible, Accountable, Consulted, Informed)
  - Deduction logic rules: how to resolve ambiguous ownership, enforce single-Accountable constraint, handle delegation chains
  - Edge cases: shared responsibility patterns, escalation indicators, proxy assignments
  - Examples of correct and incorrect RACI inference from sample email excerpts
- **Source:** Synthesized from research document Section "RACI Matrix Inference" and standard project management frameworks (PMI, PRINCE2)
- **Prep Instructions:** Write as a structured reference document with clear headings. Use tables for indicator-to-role mappings. Include 3-4 worked examples showing inference from sample email text. Keep language directive — this is a reference the GPT consults, not a behavioral prompt.
- **Update Frequency:** Stable — update only when extraction logic or RACI inference rules are refined.

### 2. extraction-schemas.md

- **Purpose:** Defines the exact field structure, data types, and validation rules for each of the eight artifact types the GPT produces. Serves as the canonical schema reference ensuring consistent, structured outputs.
- **Content:**
  - Schema definition for each artifact type:
    - Executive Summary (fields: subject, purpose, participants, roles, key_topics)
    - Decisions Log (fields: id, decision, made_by, date, rationale)
    - Action Items (fields: id, description, owner, deadline, status, dependencies)
    - RACI Matrix (fields: task, responsible, accountable, consulted, informed)
    - Chronological Timeline (fields: date, event, source_participant, message_ref)
    - Risk Flags (fields: id, risk, severity, indicator, mitigation)
    - Plus/Delta (fields: plus_items[], delta_items[])
    - Parking Lot (fields: id, item, raised_by, context, suggested_revisit)
  - Field-level validation rules (e.g., deadline must be absolute date, severity must be High/Medium/Low)
  - Required vs. optional fields per artifact
  - Enum values for constrained fields (status, severity)
- **Source:** Derived from research document artifact descriptions and standard PM tool import formats
- **Prep Instructions:** Structure as a schema reference document. Use code blocks for field definitions. Include a validation rules section per artifact type. Keep it purely structural — no behavioral instructions.
- **Update Frequency:** Update when new artifact types are added or field definitions change.

### 3. email-preprocessing-rules.md

- **Purpose:** Provides heuristic rules and patterns for the GPT to mentally preprocess email threads before extraction — handling quoted text, signature blocks, entity resolution, and thread structure identification.
- **Content:**
  - Quoted text identification patterns (blockquote markers, "On [date], [person] wrote:" patterns, ">" prefix lines)
  - Signature block detection heuristics (delimiter patterns like "-- ", "Sent from my iPhone", corporate disclaimer phrases)
  - Entity resolution rules: mapping common alias patterns (first name, nickname, email prefix, formal name) to canonical identifiers
  - Thread structure patterns: how to identify message boundaries, branching conversations, forwarded vs. replied messages
  - Facilitator detection heuristics: procedural language patterns, agenda-setting indicators, consensus-summarizing behavior
  - Common noise patterns to ignore: auto-generated calendar text, email client artifacts, tracking pixels descriptions
- **Source:** Synthesized from research document Sections "NLP Preprocessing" and "Entity Resolution"
- **Prep Instructions:** Write as a pattern reference with clear categories. Use example patterns with explanations. Format as a lookup reference the GPT can consult when encountering ambiguous thread structures. Avoid behavioral prompting — keep it factual and pattern-based.
- **Update Frequency:** Update when new email client patterns or edge cases are identified.
