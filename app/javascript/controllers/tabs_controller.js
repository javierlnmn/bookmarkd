import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = { active: { type: String, default: "stats" } }

  connect() {
    this.showTab(this.activeValue)
  }

  select(event) {
    this.showTab(event.currentTarget.dataset.tab)
  }

  showTab(tab) {
    this.tabTargets.forEach((element) => {
      const isActive = element.dataset.tab === tab
      element.classList.toggle("text-white", isActive)
      element.classList.toggle("text-zinc-500", !isActive)
      element.classList.toggle("border-orange-500", isActive)
      element.classList.toggle("border-transparent", !isActive)
    })

    this.panelTargets.forEach((element) => {
      element.classList.toggle("hidden", element.dataset.tab !== tab)
    })
  }
}
