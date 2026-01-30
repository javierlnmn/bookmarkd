import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (!this.element.open) this.open()
  }

  disconnect() {
    this.close()
  }

  open() {
    this.element.show()
  }

  close() {
    this.element.close()
  }
}