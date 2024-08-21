require 'rails_helper'

RSpec.describe "roles/new", type: :view do
  before(:each) do
    assign(:role, Role.new(
      name: "MyString",
      unique_code: "MyString",
      active_status: false,
      del_status: false
    ))
  end

  it "renders new role form" do
    render

    assert_select "form[action=?][method=?]", roles_path, "post" do

      assert_select "input[name=?]", "role[name]"

      assert_select "input[name=?]", "role[unique_code]"

      assert_select "input[name=?]", "role[active_status]"

      assert_select "input[name=?]", "role[del_status]"
    end
  end
end
