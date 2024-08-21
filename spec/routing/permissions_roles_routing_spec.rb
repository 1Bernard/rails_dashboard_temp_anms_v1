require "rails_helper"

RSpec.describe PermissionsRolesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/permissions_roles").to route_to("permissions_roles#index")
    end

    it "routes to #new" do
      expect(get: "/permissions_roles/new").to route_to("permissions_roles#new")
    end

    it "routes to #show" do
      expect(get: "/permissions_roles/1").to route_to("permissions_roles#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/permissions_roles/1/edit").to route_to("permissions_roles#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/permissions_roles").to route_to("permissions_roles#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/permissions_roles/1").to route_to("permissions_roles#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/permissions_roles/1").to route_to("permissions_roles#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/permissions_roles/1").to route_to("permissions_roles#destroy", id: "1")
    end
  end
end
