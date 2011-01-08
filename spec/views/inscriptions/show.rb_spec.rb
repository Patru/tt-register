require 'spec_helper'

describe "/inscriptions/show.rb" do
  include InscriptionsHelper
  before(:each) do
    assigns[:inscription] = @inscription = stub_model(Inscription,
      :tournament_id => 1,
      :licence => 1,
      :name => "value for name",
      :email => "value for email",
      :token => "value for token"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ email/)
    response.should have_text(/value\ for\ token/)
  end
end
