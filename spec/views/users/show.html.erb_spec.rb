require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    assign(:user, User.create!(
      email: "Email",
      username: "Username",
      firstname: "Firstname",
      lastname: "Lastname",
      other_names: "Other Names",
      mobile_number: "Mobile Number",
      creator_id: 2,
      active_status: false,
      del_status: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Username/)
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Lastname/)
    expect(rendered).to match(/Other Names/)
    expect(rendered).to match(/Mobile Number/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
