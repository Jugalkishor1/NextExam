import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    if (localStorage.theme === "dark") {
      document.documentElement.classList.add("dark")
    }
  }

  toggleTheme() {
    const html = document.documentElement
    html.classList.toggle("dark")
    localStorage.theme = html.classList.contains("dark") ? "dark" : "light"
  }
}
