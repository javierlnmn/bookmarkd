import { Controller } from "@hotwired/stimulus"
import { coloris, init } from "@melloware/coloris";

export default class extends Controller {
  connect() {
    init();
    coloris({
      themeMode: 'dark',
      swatches: [
        'DarkSlateGray',
        '#2a9d8f',
        '#e9c46a',
        'coral',
        'rgb(231, 111, 81)',
        'Crimson',
        '#023e8a',
        '#0077b6',
        'hsl(194, 100%, 39%)',
        '#00b4d8',
        '#48cae4'
      ],
      swatchesOnly: true,
      el: "#folder_name",
    });
  }
}