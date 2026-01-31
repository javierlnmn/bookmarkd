import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["list"];

  toggle() {
    this.listTarget.classList.toggle("hidden");
  }

  hide() {
    this.listTarget.classList.add("hidden");
    this.listTarget.classList.remove("flex");
  }
}
