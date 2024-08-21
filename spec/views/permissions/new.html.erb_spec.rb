require 'rails_helper'

RSpec.describe "permissions/new", type: :view do
  before(:each) do
    assign(:permission, Permission.new(
      subject_class: "MyString",
      action: "MyString",
      name: "MyString"
    ))
  end

  it "renders new permission form" do
    render

    assert_select "form[action=?][method=?]", permissions_path, "post" do

      assert_select "input[name=?]", "permission[subject_class]"

      assert_select "input[name=?]", "permission[action]"

      assert_select "input[name=?]", "permission[name]"
    end
  end
end
