require 'rails_helper'

RSpec.describe "roles/show", type: :view do
  before(:each) do
    assign(:role, Role.create!(
      name: "Name",
      unique_code: "Unique Code",
      active_status: false,
      del_status: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Unique Code/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
