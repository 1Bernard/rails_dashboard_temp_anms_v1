require 'rails_helper'

RSpec.describe "entity_infos/show", type: :view do
  before(:each) do
    assign(:entity_info, EntityInfo.create!(
      assigned_code: "Assigned Code",
      entity_name: "Entity Name",
      email: "Email",
      contact_number: "Contact Number",
      user_id: 2,
      active_status: false,
      del_status: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Assigned Code/)
    expect(rendered).to match(/Entity Name/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Contact Number/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
