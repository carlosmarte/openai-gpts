# Email Preprocessing Rules

Reference guide for identifying thread structure, deduplicating quoted text, resolving participant identities, and filtering noise from raw email thread content.

## Quoted Text Identification

### Common Quote Patterns

| Pattern | Example | Action |
|---------|---------|--------|
| Line-prefix quotes | Lines starting with `>` or `>>` | Treat as historical context, deprioritize |
| Attribution headers | "On [Date], [Name] wrote:" | Marks boundary of quoted block |
| Outlook-style headers | "From: ... Sent: ... To: ... Subject: ..." | Marks forwarded or replied message boundary |
| Gmail-style collapse | "---------- Forwarded message ----------" | Marks forwarded content boundary |
| Indented blocks | Visually indented paragraphs following attribution | Likely quoted content |

### Deduplication Logic

1. Identify all message boundaries using attribution headers and quote markers
2. Assign each message a sequence number based on chronological order (oldest = 1)
3. When the same message content appears multiple times (quoted in replies), reference only the first occurrence
4. Focus extraction attention on the most recent messages while using earlier messages as context
5. If a participant modifies quoted text (inline replies), treat the modifications as new content

## Signature Block Detection

### Common Signature Delimiters

| Delimiter | Notes |
|-----------|-------|
| `-- ` (dash-dash-space) | RFC standard signature delimiter |
| `—` (em dash on its own line) | Common in Mac/iOS clients |
| `_____` (underscore line) | Outlook separator |
| `Sent from my iPhone/iPad` | Mobile client auto-signature |
| `Get Outlook for iOS/Android` | Mobile Outlook signature |

### Signature Content Patterns (Ignore)
- Job titles, company names, phone numbers following a delimiter
- Corporate legal disclaimers and confidentiality notices
- Social media links and marketing taglines
- "This email and any attachments are confidential..."

### Rule
Strip all content after a detected signature delimiter. If no delimiter is found but the final lines contain only contact information, treat them as signature content.

## Entity Resolution

### Alias Patterns to Resolve

| Source | Example Variations | Resolution Strategy |
|--------|-------------------|---------------------|
| From header | "Sarah Chen <s.chen@company.com>" | Extract full name as canonical |
| Inline first name | "Sarah mentioned..." | Match against participant list by first name |
| Nickname | "Can you ask SC about this?" | Match initials or known nicknames |
| Email-only reference | "Loop in s.chen@company.com" | Resolve via email-to-name mapping |
| Role reference | "Check with the PM" | Map role to individual if unambiguous from context |
| Reply attribution | "Sarah wrote:" | Match to known participant |

### Resolution Rules

1. **Canonical name** = the most complete version of the name found in the thread (typically from the From header)
2. When a first name alone is used, match to the participant whose full name contains that first name. If ambiguous (multiple Sarahs), flag with [Ambiguous].
3. Initials (e.g., "SC", "DP") resolve to participants whose first and last initials match
4. Role-based references ("the PM", "our designer") resolve only when a single participant clearly holds that role in context
5. External participants mentioned but not in the thread headers should be noted as "[External - not in thread]"

## Thread Structure Identification

### Message Boundary Markers
- **Reply indicators:** "Re:" prefix in subject, attribution lines
- **Forward indicators:** "Fwd:" or "FW:" prefix, forwarded message headers
- **Inline replies:** Responses interspersed within quoted text (often marked by different color or prefix)

### Branching Detection
- When a reply addresses only part of the previous message, note the subtopic
- When a new participant is added mid-thread, note the expansion point
- When the subject line changes within a thread, flag as a potential topic branch

### Chronological Ordering
1. Use explicit timestamps from message headers when available
2. If timestamps are absent, use reply-chain ordering (deepest quote = oldest)
3. Note timezone differences between participants if timestamps include timezone info

## Facilitator Detection

### Behavioral Indicators

| Behavior | Example Phrases | Confidence |
|----------|----------------|------------|
| Agenda-setting | "Let's cover three items today..." | High |
| Time management | "We need to move on to the next topic" | High |
| Consensus-checking | "Are we all aligned on this?" | High |
| Summarizing | "To recap what we agreed..." | High |
| Action assignment | "Can I get volunteers for..." | Medium |
| Redirecting | "Let's take that offline" | Medium |
| Opening/closing | "Thanks everyone, here are next steps..." | Medium |

### Rule
The facilitator is the participant who exhibits the highest concentration of these behaviors. If no participant exhibits facilitation behavior, mark facilitator as "[Not identified]".

## Noise Patterns to Ignore

- Auto-generated meeting invites and calendar updates embedded in thread
- Read receipts and delivery notifications
- Out-of-office auto-replies (unless they contain project-relevant information like delegation)
- Email client UI artifacts ("Show quoted text", "View entire message")
- Tracking pixel descriptions or hidden content markers
- Thread subscription notifications
