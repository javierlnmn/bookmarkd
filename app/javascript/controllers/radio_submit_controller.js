import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.button = document.querySelector(`button[form="${this.element.id}"]`);
    this.update();
  }

  update() {
    if (!this.button) return;
    this.button.disabled = !this.element.querySelector(
      "input[type=radio]:checked",
    );
  }
}
