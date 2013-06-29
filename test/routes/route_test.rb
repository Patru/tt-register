require "test_helper"

# Add the following to your Rake file to test routes by default:
#   MiniTest::Rails::Testing.default_tasks << "routes"

describe "Route Integration Test" do
  it "route root" do
    assert_routing root_path, controller: "inscriptions", action: "new"
  end
end
