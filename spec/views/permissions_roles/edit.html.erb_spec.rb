require 'rails_helper'

RSpec.describe "permissions_roles/edit", type: :view do
  let(:permissions_role) {
    PermissionsRole.create!(
      permission_id: 1,
      role_id: 1
    )
  }

  before(:each) do
    assign(:permissions_role, permissions_role)
  end

  it "renders the edit permissions_role form" do
    render

    assert_select "form[action=?][method=?]", permissions_role_path(permissions_role), "post" do

      assert_select "input[name=?]", "permissions_role[permission_id]"

      assert_select "input[name=?]", "permissions_role[role_id]"
    end
  end
end
