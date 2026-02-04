import { Controller } from "@hotwired/stimulus";
import { coloris, init } from "@melloware/coloris";

export default class extends Controller {
  connect() {
    init();
    coloris({
      themeMode: "dark",
      swatches: [
        "#f06060", // red
        "#f58abb", // rose
        "#fca55c", // orange
        "#fcd34d", // amber
        "#6ee89e", // green
        "#5dd9c9", // teal
        "#5ddbed", // cyan
        "#7eb8fc", // blue
        "#9da4f9", // violet
        "#c4cad4", // slate
      ],
      swatchesOnly: true,
      el: "#colorpicker",
    });
  }
}
