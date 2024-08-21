require 'rails_helper'

RSpec.describe "entity_infos/new", type: :view do
  before(:each) do
    assign(:entity_info, EntityInfo.new(
      assigned_code: "MyString",
      entity_name: "MyString",
      email: "MyString",
      contact_number: "MyString",
      user_id: 1,
      active_status: false,
      del_status: false
    ))
  end

  it "renders new entity_info form" do
    render

    assert_select "form[action=?][method=?]", entity_infos_path, "post" do

      assert_select "input[name=?]", "entity_info[assigned_code]"

      assert_select "input[name=?]", "entity_info[entity_name]"

      assert_select "input[name=?]", "entity_info[email]"

      assert_select "input[name=?]", "entity_info[contact_number]"

      assert_select "input[name=?]", "entity_info[user_id]"

      assert_select "input[name=?]", "entity_info[active_status]"

      assert_select "input[name=?]", "entity_info[del_status]"
    end
  end
end
