require 'spec_helper'

describe "/inscriptions/edit.rb" do
  include InscriptionsHelper

  before(:each) do
    assigns[:inscription] = @inscription = stub_model(Inscription,
      :new_record? => false,
      :tournament_id => 1,
      :licence => 1,
      :name => "value for name",
      :email => "value for email",
      :token => "value for token"
    )
  end

  it "renders the edit inscription form" do
    render

    response.should have_tag("form[action=#{inscription_path(@inscription)}][method=post]") do
      with_tag('input#inscription_tournament_id[name=?]', "inscription[tournament_id]")
      with_tag('input#inscription_licence[name=?]', "inscription[licence]")
      with_tag('input#inscription_name[name=?]', "inscription[name]")
      with_tag('input#inscription_email[name=?]', "inscription[email]")
      with_tag('input#inscription_token[name=?]', "inscription[token]")
    end
  end
end
