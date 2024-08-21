require 'rails_helper'

RSpec.describe "roles/index", type: :view do
  before(:each) do
    assign(:roles, [
      Role.create!(
        name: "Name",
        unique_code: "Unique Code",
        active_status: false,
        del_status: false
      ),
      Role.create!(
        name: "Name",
        unique_code: "Unique Code",
        active_status: false,
        del_status: false
      )
    ])
  end

  it "renders a list of roles" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Unique Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
