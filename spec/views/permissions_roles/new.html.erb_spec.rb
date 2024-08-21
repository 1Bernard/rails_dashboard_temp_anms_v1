require 'rails_helper'

RSpec.describe "permissions_roles/new", type: :view do
  before(:each) do
    assign(:permissions_role, PermissionsRole.new(
      permission_id: 1,
      role_id: 1
    ))
  end

  it "renders new permissions_role form" do
    render

    assert_select "form[action=?][method=?]", permissions_roles_path, "post" do

      assert_select "input[name=?]", "permissions_role[permission_id]"

      assert_select "input[name=?]", "permissions_role[role_id]"
    end
  end
end
