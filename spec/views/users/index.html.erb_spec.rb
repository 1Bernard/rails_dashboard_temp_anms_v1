require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        email: "Email",
        username: "Username",
        firstname: "Firstname",
        lastname: "Lastname",
        other_names: "Other Names",
        mobile_number: "Mobile Number",
        creator_id: 2,
        active_status: false,
        del_status: false
      ),
      User.create!(
        email: "Email",
        username: "Username",
        firstname: "Firstname",
        lastname: "Lastname",
        other_names: "Other Names",
        mobile_number: "Mobile Number",
        creator_id: 2,
        active_status: false,
        del_status: false
      )
    ])
  end

  it "renders a list of users" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Username".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Firstname".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Lastname".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Other Names".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Mobile Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
