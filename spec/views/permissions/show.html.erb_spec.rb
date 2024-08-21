require 'rails_helper'

RSpec.describe "permissions/show", type: :view do
  before(:each) do
    assign(:permission, Permission.create!(
      subject_class: "Subject Class",
      action: "Action",
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Subject Class/)
    expect(rendered).to match(/Action/)
    expect(rendered).to match(/Name/)
  end
end
