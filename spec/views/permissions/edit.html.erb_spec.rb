require 'rails_helper'

RSpec.describe "permissions/edit", type: :view do
  let(:permission) {
    Permission.create!(
      subject_class: "MyString",
      action: "MyString",
      name: "MyString"
    )
  }

  before(:each) do
    assign(:permission, permission)
  end

  it "renders the edit permission form" do
    render

    assert_select "form[action=?][method=?]", permission_path(permission), "post" do

      assert_select "input[name=?]", "permission[subject_class]"

      assert_select "input[name=?]", "permission[action]"

      assert_select "input[name=?]", "permission[name]"
    end
  end
end
