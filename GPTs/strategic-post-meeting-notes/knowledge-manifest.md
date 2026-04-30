# Strategic Post-Meeting Notes — Knowledge File Manifest

## File Manifest

| # | File Name | Format | Purpose | Size Est. | Update Frequency |
|---|-----------|--------|---------|-----------|------------------|
| 1 | post-meeting-frameworks.md | MD | Core frameworks: 3 W's, SMART, DRI, RACI, Plus/Delta, decision log anatomy, post-mortem structure | ~12 KB | Rarely — stable organizational methodology |
| 2 | follow-up-cadences.md | MD | Internal 1-3-7 rule, external Pulse strategy, sales cadence timelines, three-tiered escalation | ~8 KB | Rarely — update when cadence research evolves |
| 3 | document-templates.md | MD | Section templates for meeting summaries, decision logs, action tables, RACI, post-mortems | ~10 KB | Occasionally — refine based on user feedback patterns |

---

## File Details

### 1. post-meeting-frameworks.md

- **Purpose:** Provides the GPT with structured knowledge of the organizational frameworks used to classify, structure, and validate post-meeting artifacts. Enables the GPT to apply the correct framework based on context.
- **Content:** Complete definitions and application rules for: the 3 W's (Who, What, When), SMART criteria (Specific, Measurable, Achievable, Relevant, Time-bound), DRI model (Directly Responsible Individual), RACI matrix (Responsible, Accountable, Consulted, Informed), Plus/Delta micro-assessment, Decision Log anatomy (ID, rationale, alternatives, ownership, review trigger), Post-Mortem structure (blameless culture, timeline construction, improvement items), meeting type classification, project lifecycle phase mapping.
- **Source:** Compiled from the research document at `research/strategic-post-meeting/research.md`, sections 2-4 and 6-7.
- **Prep Instructions:**
  1. Extract all framework definitions with their component breakdowns.
  2. Organize by category: Action Item Frameworks (3 W's, SMART, DRI), Responsibility Frameworks (RACI), Decision Frameworks (Decision Log), Reflection Frameworks (Plus/Delta, Post-Mortem, Retrospective Patterns).
  3. Add clear section headings and a table of contents for retrieval.
  4. Include the meeting type classification taxonomy (status update, strategy session, kickoff, retrospective, 1:1, client/external, training).
  5. Include the project lifecycle phase mapping table (Initiation through Closure with expected post-meeting products).
  6. Add a "Framework Selection Guide" section matching meeting types to applicable frameworks.

### 2. follow-up-cadences.md

- **Purpose:** Provides day-by-day follow-up schedules for different meeting contexts. Enables the GPT to recommend the correct timing, channel, and escalation pattern.
- **Content:** Internal spaced repetition cadence (1-3-7 rule with channel recommendations), external event Pulse strategy (6-pulse sequence with timing and messaging guidance), sales cadence (6-8 touchpoints over 2-3 weeks with value drop integration), three-tiered data collection follow-up (email, phone, in-person escalation), operating rhythm frameworks (priority trackers, KPI review meetings, commitment follow-up).
- **Source:** Compiled from the research document, sections 5 and 8.2.
- **Prep Instructions:**
  1. Extract all cadence timelines with their day-by-day breakdowns.
  2. Create comparison tables showing parallel timelines (Event Pulse vs. Sales Cadence).
  3. Include channel recommendations for each touchpoint (email, Slack/Teams, phone, in-person).
  4. Add the owner designation for each follow-up step.
  5. Include the "20% daily engagement drop" statistic and other key data points as context anchors.
  6. Add a "Cadence Selection Guide" matching meeting types to the correct follow-up pattern.

### 3. document-templates.md

- **Purpose:** Provides section-by-section templates for each post-meeting deliverable. The GPT uses these as starting frameworks and adapts them to the user's specific meeting context.
- **Content:** Complete templates for: Post-Meeting Summary (header, classification, participants), Decision Log (table format with all required fields), Action Items Table (SMART-validated format), RACI Matrix (cross-functional mapping), Follow-Up Schedule (day/date/action/channel/owner), Parking Lot (item/owner/timeframe), Plus/Delta Assessment (structured reflection), Progress Report (for follow-up meetings comparing against original action items).
- **Source:** Compiled from the system instructions output format section and research document templates.
- **Prep Instructions:**
  1. Create each template as a self-contained section with placeholder markers (e.g., `[Meeting Name]`, `[DRI Name]`, `[YYYY-MM-DD]`).
  2. Include inline guidance comments explaining what each field should contain.
  3. Add example entries for each template (one complete row showing ideal content).
  4. Include the vague-item flagging format (`**[VAGUE]**`, `**[NEEDS CONFIRMATION]**`, `**[FLAG]**`).
  5. Add the SMART validation checklist as an inline reference within the action items template.
