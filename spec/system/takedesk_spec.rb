# frozen_string_literal: true

RSpec.describe "Takedesk removal request links", system: true do
  let(:desk_url) { "https://takedesk.example/r/hamster-forum" }

  fab!(:theme) { upload_theme_component }
  fab!(:user)
  fab!(:topic)
  fab!(:post) { Fabricate(:post, topic: topic) }

  def configure(**values)
    values.each { |name, value| theme.update_setting(name, value) }
    theme.save!
  end

  def reported_url(link)
    CGI.parse(URI(link[:href]).query)["url"].first
  end

  before { sign_in(user) }

  context "with a valid desk address" do
    before { configure(desk_url: desk_url) }

    it "shows the footer link" do
      visit("/t/#{topic.slug}/#{topic.id}")

      link = find(".takedesk-footer a.takedesk-link")
      expect(link.text).to eq("Report content")
      expect(link[:href]).to eq(desk_url)
      expect(link[:target]).to eq("_blank")
    end

    it "adds the link to the sidebar" do
      visit("/latest")

      expect(page).to have_css(
        ".sidebar-section-link[data-link-name='takedesk-report'][href='#{desk_url}']",
      )
    end

    it "puts the post button behind the show more menu by default" do
      visit("/t/#{topic.slug}/#{topic.id}")

      expect(page).to have_css("#post_1 .post-controls")
      expect(page).to have_no_css("#post_1 .post-action-menu__takedesk-report")

      find("#post_1 .post-action-menu__show-more").click

      button = find("#post_1 .post-action-menu__takedesk-report")
      expect(button[:href]).to start_with("#{desk_url}?url=")
      expect(reported_url(button)).to end_with("/t/#{topic.slug}/#{topic.id}")
    end

    it "can show the post button directly" do
      configure(post_menu_collapsed: false)
      visit("/t/#{topic.slug}/#{topic.id}")

      button = find("#post_1 .post-action-menu__takedesk-report")
      expect(button[:title]).to eq("Report for removal")
      expect(reported_url(button)).to include("/t/#{topic.slug}/#{topic.id}")
    end

    it "respects disabled options" do
      configure(footer_link: false, sidebar_link: false, post_menu_button: false)
      visit("/t/#{topic.slug}/#{topic.id}")

      expect(page).to have_css("#post_1 .post-controls")
      # A collapsed button would add the show more menu: neither may exist.
      expect(page).to have_no_css("#post_1 .post-action-menu__show-more")
      expect(page).to have_no_css(".post-action-menu__takedesk-report")
      expect(page).to have_no_css(".takedesk-footer")
      expect(page).to have_no_css(".sidebar-section-link[data-link-name='takedesk-report']")
    end
  end

  it "shows nothing when the desk address is not valid" do
    configure(desk_url: "javascript:alert(1)")
    visit("/t/#{topic.slug}/#{topic.id}")

    expect(page).to have_css("#post_1 .post-controls")
    expect(page).to have_no_css("#post_1 .post-action-menu__show-more")
    expect(page).to have_no_css(".post-action-menu__takedesk-report")
    expect(page).to have_no_css(".takedesk-footer")
    expect(page).to have_no_css(".sidebar-section-link[data-link-name='takedesk-report']")
  end
end
