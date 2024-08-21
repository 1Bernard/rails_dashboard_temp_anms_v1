require "rails_helper"

RSpec.describe EntityInfosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/entity_infos").to route_to("entity_infos#index")
    end

    it "routes to #new" do
      expect(get: "/entity_infos/new").to route_to("entity_infos#new")
    end

    it "routes to #show" do
      expect(get: "/entity_infos/1").to route_to("entity_infos#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/entity_infos/1/edit").to route_to("entity_infos#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/entity_infos").to route_to("entity_infos#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/entity_infos/1").to route_to("entity_infos#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/entity_infos/1").to route_to("entity_infos#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/entity_infos/1").to route_to("entity_infos#destroy", id: "1")
    end
  end
end
