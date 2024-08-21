require 'rails_helper'

RSpec.describe "user_roles/edit", type: :view do
  let(:user_role) {
    UserRole.create!(
      role_unique_code: "MyString",
      entity_code: "MyString",
      user_id: 1,
      active_status: false,
      del_status: false
    )
  }

  before(:each) do
    assign(:user_role, user_role)
  end

  it "renders the edit user_role form" do
    render

    assert_select "form[action=?][method=?]", user_role_path(user_role), "post" do

      assert_select "input[name=?]", "user_role[role_unique_code]"

      assert_select "input[name=?]", "user_role[entity_code]"

      assert_select "input[name=?]", "user_role[user_id]"

      assert_select "input[name=?]", "user_role[active_status]"

      assert_select "input[name=?]", "user_role[del_status]"
    end
  end
end
