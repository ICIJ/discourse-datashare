import loaderShim from "discourse/lib/loader-shim";
import ColorInput from "../components/color-input";

/**
 * The color-input component is used in the admin settings page and cannot be
 * loaded by non-admin users. Because the "create category" page also uses this
 * component and the Datashare plugin might allow category creation for non-admin users,
 * we need to shim the component to avoid loading errors.
 */
export default {
  name: "color-input-shim",
  initialize() {
    loaderShim("admin/components/color-input", () => ColorInput);
  },
};
