require 'rails_helper'

RSpec.describe "roles/edit", type: :view do
  let(:role) {
    Role.create!(
      name: "MyString",
      unique_code: "MyString",
      active_status: false,
      del_status: false
    )
  }

  before(:each) do
    assign(:role, role)
  end

  it "renders the edit role form" do
    render

    assert_select "form[action=?][method=?]", role_path(role), "post" do

      assert_select "input[name=?]", "role[name]"

      assert_select "input[name=?]", "role[unique_code]"

      assert_select "input[name=?]", "role[active_status]"

      assert_select "input[name=?]", "role[del_status]"
    end
  end
end
