require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      email: "MyString",
      username: "MyString",
      firstname: "MyString",
      lastname: "MyString",
      other_names: "MyString",
      mobile_number: "MyString",
      creator_id: 1,
      active_status: false,
      del_status: false
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input[name=?]", "user[email]"

      assert_select "input[name=?]", "user[username]"

      assert_select "input[name=?]", "user[firstname]"

      assert_select "input[name=?]", "user[lastname]"

      assert_select "input[name=?]", "user[other_names]"

      assert_select "input[name=?]", "user[mobile_number]"

      assert_select "input[name=?]", "user[creator_id]"

      assert_select "input[name=?]", "user[active_status]"

      assert_select "input[name=?]", "user[del_status]"
    end
  end
end
