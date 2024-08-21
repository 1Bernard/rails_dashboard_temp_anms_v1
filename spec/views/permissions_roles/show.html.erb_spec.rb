require 'rails_helper'

RSpec.describe "permissions_roles/show", type: :view do
  before(:each) do
    assign(:permissions_role, PermissionsRole.create!(
      permission_id: 2,
      role_id: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
