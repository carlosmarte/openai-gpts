# Actions Specification — PDF to Post Communication

## Status: Not Enabled in v1

This GPT does not use Actions in v1. Output is text-only and users copy-paste each generated post into the destination channel manually.

### Why deferred

- **Privacy surface.** Channel-posting Actions (Slack, LinkedIn, Gmail) require OAuth scopes that grant write access to user accounts. For a GPT Store distribution targeting knowledge workers and PMs, the trust threshold is high; v1 stays read-only by default.
- **Privacy-policy requirement.** The GPT Builder requires a published privacy-policy URL for any public GPT with Actions. Deferring removes this gate from the v1 launch.
- **Apps mutual exclusivity.** Actions and Apps cannot coexist on the same GPT. Keeping Actions off preserves the option to enable Apps later for users who already have linked tools (Slack, Gmail, LinkedIn) in their ChatGPT account.
- **Failure mode hygiene.** A draft post the user reviews and pastes is auditable; an Action-posted message is not. v1 prefers user-in-the-loop posting until the extraction quality is validated against a real-world corpus.

## v2 Design Sketch

If/when Actions are enabled, the following endpoints are the candidate set. None are implemented yet.

### Action 1: Post to Slack

- **Method:** `POST`
- **URL:** `https://slack.com/api/chat.postMessage`
- **Auth:** OAuth 2.0 (Slack user scope `chat:write`)
- **Description:** Post the generated Slack message to a user-selected channel.
- **Parameters:**

  | Name | Type | Required | Description |
  |------|------|----------|-------------|
  | `channel` | string | yes | Channel ID (`C…`) or name |
  | `text` | string | yes | The Slack-formatted message body |
  | `unfurl_links` | bool | no | Defaults to `false` to avoid noise |

- **Response:** `{ ok, ts, channel }`
- **Error Handling:** Surface Slack error codes (`channel_not_found`, `not_in_channel`) as readable user messages; never retry silently.

### Action 2: Draft a LinkedIn Post

- **Method:** `POST`
- **URL:** `https://api.linkedin.com/v2/ugcPosts`
- **Auth:** OAuth 2.0 (LinkedIn `w_member_social`)
- **Description:** Create a LinkedIn post as a **draft** (not public) for user review before publishing.
- **Parameters:**

  | Name | Type | Required | Description |
  |------|------|----------|-------------|
  | `author` | string | yes | Member URN (`urn:li:person:…`) |
  | `text` | string | yes | The LinkedIn-formatted post body |
  | `visibility` | enum | yes | Hard-coded to `CONNECTIONS` for v2; never `PUBLIC` without explicit user confirmation |

- **Response:** `{ id }`
- **Error Handling:** Always show the draft URL on success so the user verifies before publishing.

### Action 3: Compose Gmail Draft

- **Method:** `POST`
- **URL:** `https://gmail.googleapis.com/gmail/v1/users/me/drafts`
- **Auth:** OAuth 2.0 (Google `gmail.compose`)
- **Description:** Create a Gmail draft (not send) with the generated subject and body.
- **Parameters:**

  | Name | Type | Required | Description |
  |------|------|----------|-------------|
  | `to` | string[] | no | Recipient list (omit to leave blank for user fill-in) |
  | `subject` | string | yes | Subject line |
  | `body` | string | yes | Email body in plain text or HTML |

- **Response:** `{ id, message: { id, threadId } }`
- **Error Handling:** On `insufficient_scope`, prompt the user to re-authenticate. Never auto-send.

## Privacy Policy

A privacy policy URL is required before any of the above can ship. v1 defers the requirement entirely.

## OpenAPI Schema

A full OpenAPI 3.1 schema covering the three actions above is **not generated** in v1. When v2 work begins, generate a single `actions.yaml` that bundles all three endpoints under one Action with shared OAuth flows.
