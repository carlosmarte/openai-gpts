# PRD & Design Spec Builder — Knowledge File Manifest

## File Manifest

| # | File Name | Format | Purpose | Size Est. | Update Frequency |
|---|-----------|--------|---------|-----------|------------------|
| 1 | requirement-formats-reference.md | MD | Comprehensive reference on document types, structures, and when to use each | ~8 KB | Rarely — update when new industry standards emerge |
| 2 | requirement-classification-guide.md | MD | FR/NFR classification templates, ID schemes, priority systems, Gherkin criteria | ~5 KB | Rarely — stable reference material |
| 3 | document-templates.md | MD | Ready-to-use section templates for PRD, HLD, API Spec, UX Flows | ~10 KB | Occasionally — refine templates based on usage patterns |

---

## File Details

### 1. requirement-formats-reference.md

- **Purpose:** Provides the GPT with structured knowledge about different requirement document formats (SRS, FRD, PRD, BRD, MRD, etc.), their audiences, structures, and selection criteria. Enables the GPT to recommend the right format for the user's context.
- **Content:** Document type descriptions, comparison tables (formality, machine-readability, agile-friendliness), audience mappings, and structural outlines for each format. Also covers technical design spec types (HLD, LLD, ADR, API Spec, Data Design, etc.).
- **Source:** Compiled from the research reference material in `research/requirement-docs/references/research.md`.
- **Prep Instructions:**
  1. Extract all document type descriptions and comparison tables from the research file.
  2. Organize by category: business documents (BRD, PRD, MRD), technical documents (SRS, FRD, HLD, LLD), and specialized specs (API, Data, Security, etc.).
  3. Add clear section headings and a table of contents for retrieval.
  4. Remove emoji prefixes and normalize formatting to clean markdown.
  5. Add a "Selection Guide" section with a decision tree for choosing the right format.

### 2. requirement-classification-guide.md

- **Purpose:** Provides templates and frameworks for classifying, identifying, and prioritizing requirements. Ensures consistent formatting across all generated documents.
- **Content:** Functional requirement (FR) template, non-functional requirement (NFR) template with category taxonomy, unique ID scheme conventions, MoSCoW and P0-P3 priority systems, Given-When-Then acceptance criteria format, user story format.
- **Source:** Compiled from the SKILL.md requirement classification section and research reference material.
- **Prep Instructions:**
  1. Extract the FR and NFR templates from the skill definition.
  2. Add examples for each NFR category (Performance, Reliability, Security, Usability, Maintainability, Scalability).
  3. Include a section on ID scheme conventions with examples (FR-001, NFR-012, API-003).
  4. Add a priority comparison table (MoSCoW vs P0-P3 mapping).
  5. Include 3-4 complete Gherkin acceptance criteria examples across different domains.

### 3. document-templates.md

- **Purpose:** Provides section-by-section templates for each core deliverable. The GPT uses these as starting frameworks and adapts them to the user's domain.
- **Content:** Complete section structures for PRD (Product Overview, Tasks, Sub-tasks, Build Validation, Constraints, Assumptions, Stakeholders), HLD (System Architecture, Data Flow, Integrations, Infrastructure, Tech Stack, Design Decisions), API Spec (Endpoints, Models, Auth, Status Codes, Rate Limits, Examples), and UX Flows (User Journeys, Screen Inventory, Interaction Patterns, Edge Cases, Accessibility).
- **Source:** Compiled from the SKILL.md core deliverables section and research reference material.
- **Prep Instructions:**
  1. Create each template as a self-contained section with placeholder markers (e.g., `[Project Name]`, `[Feature Description]`).
  2. Include inline guidance comments explaining what each section should contain.
  3. Add Mermaid diagram templates for common patterns (system architecture, data flow, sequence diagrams).
  4. Include the extended deliverables table with "When to Include" triggers.
  5. Add a cross-reference checklist template for traceability validation.
