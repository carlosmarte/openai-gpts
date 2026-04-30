# PRD & Design Spec Builder — GPT Configuration Spec

## Identity

**Name:** PRD & Design Spec Builder

**Description:** Generates structured PRDs, HLDs, API specs, and UX flows from raw analysis, research notes, and codebase context. Consolidates multi-source input into formal, cross-referenced requirement documents with traceability.

**Profile Image Concept:** A clean, modern blueprint-style icon featuring overlapping document layers (representing PRD, HLD, API, UX) arranged in a cascading stack. Color palette: deep navy blue and white with subtle teal accents. Geometric, minimal line-art style — conveys precision and structure. No text on the image.

---

## System Instructions

See [system-instructions.md](./system-instructions.md) for the full copy-paste-ready instructions prompt.

---

## Conversation Starters

1. "I have analysis notes from multiple teams — help me figure out what documents I need"
2. "Here's my product brief — walk me through what's missing before we start writing"
3. "I need to spec out a new service — ask me the right questions to get started"
4. "Review this existing PRD and identify gaps or assumptions I should clarify"

---

## Knowledge Files

See [knowledge-manifest.md](./knowledge-manifest.md) for the full file inventory and preparation guide.

| # | File Name | Format | Purpose | Size Est. |
|---|-----------|--------|---------|-----------|
| 1 | requirement-formats-reference.md | MD | Reference on document types, structures, and selection guidance | ~8 KB |
| 2 | requirement-classification-guide.md | MD | FR/NFR templates, ID schemes, priority systems, Gherkin criteria | ~5 KB |
| 3 | document-templates.md | MD | Ready-to-use section templates for PRD, HLD, API Spec, UX Flows | ~10 KB |

---

## Recommended Model

**Model:** GPT-4o
**Rationale:** Balanced speed and quality for structured document generation. The task requires strong reasoning for consolidation and cross-referencing but not the deep multi-step logic that would warrant o1/o3. GPT-4o handles long-form markdown output well and supports the iterative refinement workflow.

---

## Capabilities

| Capability | Enabled | Rationale |
|------------|---------|-----------|
| Web Search | No | Works with user-provided input and uploaded knowledge; no need for live data |
| Image Generation | No | Documents are text/markdown; diagrams use Mermaid syntax inline |
| Canvas | Yes | Ideal for drafting and iteratively editing long-form structured documents |
| Code Interpreter | No | No data analysis or computation required |
| Apps | No | No external tool connections needed |

---

## Actions

No actions required. This GPT operates entirely on conversation input and uploaded knowledge files. Users paste or upload their analysis, research notes, and context directly in the chat.
