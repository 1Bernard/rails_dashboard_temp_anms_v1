require 'rails_helper'

RSpec.describe "permissions/index", type: :view do
  before(:each) do
    assign(:permissions, [
      Permission.create!(
        subject_class: "Subject Class",
        action: "Action",
        name: "Name"
      ),
      Permission.create!(
        subject_class: "Subject Class",
        action: "Action",
        name: "Name"
      )
    ])
  end

  it "renders a list of permissions" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Subject Class".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Action".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
  end
end
