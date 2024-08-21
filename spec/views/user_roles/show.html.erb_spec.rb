require 'rails_helper'

RSpec.describe "user_roles/show", type: :view do
  before(:each) do
    assign(:user_role, UserRole.create!(
      role_unique_code: "Role Unique Code",
      entity_code: "Entity Code",
      user_id: 2,
      active_status: false,
      del_status: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Role Unique Code/)
    expect(rendered).to match(/Entity Code/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
