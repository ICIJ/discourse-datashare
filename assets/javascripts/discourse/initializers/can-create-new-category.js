import { withPluginApi } from "discourse/lib/plugin-api";

function initialize(api) {
  api.modifyClass("route:new-category", (Superclass) => {
    return class extends Superclass {
      beforeModel() {
        if (this.currentUser?.can_create_category) {
          return;
        }

        return super.beforeModel(...arguments);
      }
    };
  });
}

export default {
  name: "can-create-new-category",
  initialize() {
    withPluginApi(initialize);
  },
};
