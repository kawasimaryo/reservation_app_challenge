// This file is automatically compiled by Webpack.
// Place your application logic in app/javascript/* and import it here.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
// import "stylesheets/application" // ← WebpackerでCSS管理するなら有効化

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// ---------- UI Helpers ----------
const byId = (id) => document.getElementById(id)

// チェックイン/アウトの日付制御（チェックアウトはチェックイン+1日以降のみ）
function setupDatePickers() {
  const todayStr = new Date().toISOString().split("T")[0]

  const startInput =
    document.querySelector('[data-behavior="checkin"]') ||
    byId("reservation_start_date") ||
    document.querySelector('input[name="reservation[start_date]"]')

  const endInput =
    document.querySelector('[data-behavior="checkout"]') ||
    byId("reservation_end_date") ||
    document.querySelector('input[name="reservation[end_date]"]')

  if (!startInput || !endInput) return

  startInput.setAttribute("min", todayStr)

  const syncEndMin = () => {
    if (!startInput.value) return
    const start = new Date(startInput.value)
    const minEnd = new Date(start)
    minEnd.setDate(start.getDate() + 1)
    const minEndStr = minEnd.toISOString().split("T")[0]
    endInput.setAttribute("min", minEndStr)
    if (endInput.value && endInput.value < minEndStr) {
      endInput.value = minEndStr
    }
  }

  startInput.addEventListener("change", syncEndMin)
  syncEndMin()
}

// 画像プレビュー（例：<input type="file" data-preview-target="#avatar-preview">）
function setupImagePreviewers() {
  document
    .querySelectorAll('input[type="file"][data-preview-target]')
    .forEach((input) => {
      const targetSel = input.getAttribute("data-preview-target")
      const img = document.querySelector(targetSel)
      if (!img) return

      input.addEventListener("change", (e) => {
        const file = e.target.files && e.target.files[0]
        if (!file) return
        const url = URL.createObjectURL(file)
        img.src = url
        img.onload = () => URL.revokeObjectURL(url)
      })
    })
}

// ユーザー名クリックのドロップダウン（例：data-dropdown-toggle data-target="#menu"）
function setupDropdowns() {
  document.querySelectorAll("[data-dropdown-toggle]").forEach((btn) => {
    const target = document.querySelector(btn.getAttribute("data-target"))
    if (!target) return

    btn.addEventListener("click", (e) => {
      e.preventDefault()
      target.hidden = !target.hidden
    })

    document.addEventListener("click", (e) => {
      if (!target.hidden && !target.contains(e.target) && e.target !== btn) {
        target.hidden = true
      }
    })
  })
}

// フラッシュメッセージ自動フェードアウト
function setupFlashAutoHide() {
  document.querySelectorAll(".flash, .notice, .alert").forEach((el) => {
    setTimeout(() => {
      el.style.transition = "opacity 300ms"
      el.style.opacity = "0"
      setTimeout(() => (el.style.display = "none"), 300)
    }, 3000)
  })
}

document.addEventListener("turbolinks:load", () => {
  setupDatePickers()
  setupImagePreviewers()
  setupDropdowns()
  setupFlashAutoHide()
})
