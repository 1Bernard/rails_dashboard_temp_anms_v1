require 'rails_helper'

RSpec.describe "user_roles/index", type: :view do
  before(:each) do
    assign(:user_roles, [
      UserRole.create!(
        role_unique_code: "Role Unique Code",
        entity_code: "Entity Code",
        user_id: 2,
        active_status: false,
        del_status: false
      ),
      UserRole.create!(
        role_unique_code: "Role Unique Code",
        entity_code: "Entity Code",
        user_id: 2,
        active_status: false,
        del_status: false
      )
    ])
  end

  it "renders a list of user_roles" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Role Unique Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Entity Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
