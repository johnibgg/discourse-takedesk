# frozen_string_literal: true

RSpec.describe "Core features" do
  before do
    upload_theme_or_component.tap do |theme|
      theme.update_setting(:desk_url, "https://takedesk.example/r/hamster-forum")
      theme.save!
    end
  end

  it_behaves_like "having working core features"
end
