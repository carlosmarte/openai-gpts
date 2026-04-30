# Strategic Post-Meeting Notes — GPT Configuration Spec

## Identity

**Name:** Strategic Post-Meeting Notes

**Description:** Transforms raw meeting notes into structured post-meeting documentation with SMART action items, decision logs, RACI matrices, and timed follow-up cadences. For project managers, team leads, and anyone who runs meetings.

**Profile Image Concept:** A clean, modern icon featuring a clipboard with checkboxes transforming into connected arrows and nodes — representing the transition from raw notes to structured action. Color palette: deep teal and white with warm amber accents for action items. Geometric, minimal line-art style. No text on the image.

---

## System Instructions

See [system-instructions.md](./system-instructions.md) for the full copy-paste-ready instructions prompt.

---

## Conversation Starters

1. "Here are my notes from today's team standup — turn them into structured action items"
2. "Process these strategy meeting notes into a decision log with rationale and review triggers"
3. "I just finished a project kickoff — generate a RACI matrix and follow-up schedule from my notes"
4. "Run a Plus/Delta analysis on this retrospective and extract improvement action items"

---

## Knowledge Files

See [knowledge-manifest.md](./knowledge-manifest.md) for the full file inventory and preparation guide.

| # | File Name | Format | Purpose | Size Est. |
|---|-----------|--------|---------|-----------|
| 1 | post-meeting-frameworks.md | MD | Core frameworks: 3 W's, SMART, DRI, RACI, Plus/Delta, decision logs, post-mortems | ~12 KB |
| 2 | follow-up-cadences.md | MD | Internal 1-3-7 rule, external Pulse strategy, sales cadence day-by-day schedules | ~8 KB |
| 3 | document-templates.md | MD | Ready-to-use templates for summaries, decision logs, action tables, post-mortems | ~10 KB |

---

## Recommended Model

**Model:** GPT-4o
**Rationale:** Balanced speed and quality for structured document generation. The task requires strong reasoning to extract implicit decisions and commitments from unstructured notes, but not the deep multi-step logic that would warrant o1/o3. GPT-4o handles long-form markdown output well and supports the iterative refinement workflow via Canvas.

---

## Capabilities

| Capability | Enabled | Rationale |
|------------|---------|-----------|
| Web Search | No | Works entirely with user-provided meeting notes and uploaded knowledge |
| Image Generation | No | Output is structured text and markdown tables |
| Canvas | Yes | Ideal for drafting and iteratively editing meeting summaries and action item lists |
| Code Interpreter | No | No data analysis or computation required |
| Apps | No | No external tool connections needed |

---

## Actions

No actions required. This GPT operates entirely on conversation input and uploaded knowledge files. Users paste their meeting notes directly in the chat or upload note files.
