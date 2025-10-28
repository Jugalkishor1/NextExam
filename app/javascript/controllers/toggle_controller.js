// app/javascript/controllers/toggle_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Set initial theme based on localStorage
    if (localStorage.theme === "dark") {
      document.documentElement.classList.add("dark")
    }

    // Sync all toggle icons (mobile + desktop)
    this.updateIcons()
  }

  toggleTheme() {
    const html = document.documentElement
    html.classList.toggle("dark")
    localStorage.theme = html.classList.contains("dark") ? "dark" : "light"
    this.updateIcons()
  }

  toggleMenu() {
    if (this.hasMenuTarget) {
      this.menuTarget.classList.toggle("hidden")
      this.menuTarget.classList.toggle("animate-slide-down")
    }
  }

  updateIcons() {
    // Force DOM update for dark/light icon visibility
    requestAnimationFrame(() => {
      const event = new Event("themechange")
      document.dispatchEvent(event)
    })
  }
}
