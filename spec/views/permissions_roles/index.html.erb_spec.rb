require 'rails_helper'

RSpec.describe "permissions_roles/index", type: :view do
  before(:each) do
    assign(:permissions_roles, [
      PermissionsRole.create!(
        permission_id: 2,
        role_id: 3
      ),
      PermissionsRole.create!(
        permission_id: 2,
        role_id: 3
      )
    ])
  end

  it "renders a list of permissions_roles" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
