import { Application } from "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import TC from "@rolemodel/turbo-confirm"

TC.start()

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
