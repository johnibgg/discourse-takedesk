# Takedesk Removal Requests for Discourse

A theme component that gives your community a clear way to request removal of content, with the information required by the US TAKE IT DOWN Act, the EU Digital Services Act, the UK Online Safety Act and the DMCA. Requests are received and tracked in [Takedesk](https://takedesk.marginapp.workers.dev/).

## What it adds

- A **"Report content" link** at the bottom of every page and in the sidebar, as a clear and conspicuous notice of your removal process.
- A **"Report for removal" button** on each post (behind the "…" menu by default) that opens the request form with the address of the post filled in.

Your Takedesk inbox then tracks the 48-hour deadline, sends reminders and keeps records of every decision. No images are uploaded; personal data is encrypted.

## Install

1. Create a free desk at https://takedesk.marginapp.workers.dev/dashboard/#signup and copy the address of your request page.
2. In Discourse, go to **Admin → Appearance → Themes and components → Components → Install**, choose **From a git repository** and paste this repository's address, or choose **From your device** and upload `takedesk-discourse.zip`.
3. Add the component to your active theme(s).
4. In the component settings, paste your request page address into **desk_url**.

Requires Discourse 3.4 or later.

## Settings

| Setting | Default | Description |
| --- | --- | --- |
| `desk_url` | empty | Your Takedesk request page address. Nothing is shown until it is set. |
| `footer_link` | on | Link at the bottom of every page. |
| `footer_label` | Report content | Text of the footer and sidebar links. |
| `sidebar_link` | on | Link in the sidebar Community section. |
| `post_menu_button` | on | Button on each post. |
| `post_menu_label` | Report for removal | Label and tooltip of the post button. |
| `post_menu_collapsed` | on | Keep the post button behind the "…" menu. |

Takedesk provides software to receive and document removal requests. It is not a law firm and does not provide legal advice.
