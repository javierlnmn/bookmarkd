import { Controller } from "@hotwired/stimulus";
import { coloris, init } from "@melloware/coloris";

export default class extends Controller {
  connect() {
    init();
    coloris({
      themeMode: "dark",
      swatches: [
        "#f04848", // red
        "#f472b6", // rose
        "#fb923c", // orange
        "#facc15", // amber
        "#4ade80", // green
        "#2dd4bf", // teal
        "#22d3ee", // cyan
        "#60a5fa", // blue
        "#818cf8", // violet
        "#b0b8c4", // slate
      ],
      swatchesOnly: true,
      el: "#colorpicker",
    });
  }
}
