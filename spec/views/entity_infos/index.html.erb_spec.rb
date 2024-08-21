require 'rails_helper'

RSpec.describe "entity_infos/index", type: :view do
  before(:each) do
    assign(:entity_infos, [
      EntityInfo.create!(
        assigned_code: "Assigned Code",
        entity_name: "Entity Name",
        email: "Email",
        contact_number: "Contact Number",
        user_id: 2,
        active_status: false,
        del_status: false
      ),
      EntityInfo.create!(
        assigned_code: "Assigned Code",
        entity_name: "Entity Name",
        email: "Email",
        contact_number: "Contact Number",
        user_id: 2,
        active_status: false,
        del_status: false
      )
    ])
  end

  it "renders a list of entity_infos" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Assigned Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Entity Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Contact Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
