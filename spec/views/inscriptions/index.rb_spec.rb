require 'spec_helper'

describe "/inscriptions/index.rb" do
  include InscriptionsHelper

  before(:each) do
    assigns[:inscriptions] = [
      stub_model(Inscription,
        :tournament_id => 1,
        :licence => 1,
        :name => "value for name",
        :email => "value for email",
        :token => "value for token"
      ),
      stub_model(Inscription,
        :tournament_id => 1,
        :licence => 1,
        :name => "value for name",
        :email => "value for email",
        :token => "value for token"
      )
    ]
  end

  it "renders a list of inscriptions" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for email".to_s, 2)
    response.should have_tag("tr>td", "value for token".to_s, 2)
  end
end
