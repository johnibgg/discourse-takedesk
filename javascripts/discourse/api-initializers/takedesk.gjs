import Component from "@glimmer/component";
import { htmlSafe } from "@ember/template";
import { apiInitializer } from "discourse/lib/api";
import { iconHTML } from "discourse/lib/icon-library";

// The request page address shown in the Takedesk dashboard, e.g. https://…/r/my-forum.
// Plain HTTP is only accepted on a local machine, for development.
const DESK_URL =
  /^(https:\/\/[a-z0-9.-]+(?::\d+)?|http:\/\/(?:localhost|127\.0\.0\.1)(?::\d+)?)\/r\/([a-z0-9-]{3,40})\/?$/i;

export function takedeskRequestUrl(deskUrl, itemUrl) {
  const match = DESK_URL.exec((deskUrl || "").trim());
  if (!match) {
    return null;
  }
  const base = `${match[1]}/r/${match[2].toLowerCase()}`;
  return itemUrl ? `${base}?url=${encodeURIComponent(itemUrl)}` : base;
}

const flagIcon = htmlSafe(iconHTML("flag"));

class TakedeskFooterLink extends Component {
  get href() {
    return takedeskRequestUrl(settings.desk_url);
  }

  get label() {
    return settings.footer_label;
  }

  <template>
    {{#if this.href}}
      <div class="takedesk-footer">
        <a
          class="takedesk-link"
          href={{this.href}}
          target="_blank"
          rel="noopener nofollow"
        >{{this.label}}</a>
      </div>
    {{/if}}
  </template>
}

class TakedeskReportButton extends Component {
  static shouldRender(args) {
    return !!takedeskRequestUrl(settings.desk_url) && !args.post?.deleted_at;
  }

  get href() {
    const path = this.args.post?.url;
    const itemUrl = path ? new URL(path, window.location.origin).href : "";
    return takedeskRequestUrl(settings.desk_url, itemUrl);
  }

  get label() {
    return settings.post_menu_label;
  }

  <template>
    <a
      class="btn post-action-menu__takedesk-report
        {{if @showLabel 'btn-icon-text' 'btn-icon no-text'}}"
      ...attributes
      href={{this.href}}
      target="_blank"
      rel="noopener nofollow"
      title={{this.label}}
      aria-label={{this.label}}
    >
      {{flagIcon}}
      {{#if @showLabel}}
        <span class="d-button-label">{{this.label}}</span>
      {{/if}}
    </a>
  </template>
}

export default apiInitializer((api) => {
  const requestUrl = takedeskRequestUrl(settings.desk_url);
  if (!requestUrl) {
    return;
  }

  if (settings.footer_link) {
    api.renderInOutlet("below-footer", TakedeskFooterLink);
  }

  if (settings.sidebar_link) {
    api.addCommunitySectionLink({
      name: "takedesk-report",
      href: requestUrl,
      title: settings.footer_label,
      text: settings.footer_label,
      icon: "flag",
    });
  }

  if (settings.post_menu_button) {
    api.registerValueTransformer(
      "post-menu-buttons",
      ({ value: dag, context: { buttonKeys, collapsedButtons } }) => {
        dag.add("takedesk-report", TakedeskReportButton, {
          before: buttonKeys.SHOW_MORE,
        });
        if (settings.post_menu_collapsed) {
          collapsedButtons?.hide("takedesk-report");
        }
      }
    );
  }
});
