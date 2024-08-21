require 'rails_helper'

RSpec.describe "user_roles/new", type: :view do
  before(:each) do
    assign(:user_role, UserRole.new(
      role_unique_code: "MyString",
      entity_code: "MyString",
      user_id: 1,
      active_status: false,
      del_status: false
    ))
  end

  it "renders new user_role form" do
    render

    assert_select "form[action=?][method=?]", user_roles_path, "post" do

      assert_select "input[name=?]", "user_role[role_unique_code]"

      assert_select "input[name=?]", "user_role[entity_code]"

      assert_select "input[name=?]", "user_role[user_id]"

      assert_select "input[name=?]", "user_role[active_status]"

      assert_select "input[name=?]", "user_role[del_status]"
    end
  end
end
