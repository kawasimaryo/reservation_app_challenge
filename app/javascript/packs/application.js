// This file is automatically compiled by Webpack.																									
// Place your application logic in app/javascript/* and import it here.																									
																									
import Rails from "@rails/ujs"																									
import Turbolinks from "turbolinks"																									
import * as ActiveStorage from "@rails/activestorage"																									
import "channels"																									
																									
Rails.start()																									
Turbolinks.start()																									
ActiveStorage.start()																									
																									
// ---------- UI Helpers ----------																									
const byId = (id) => document.getElementById(id)																									
const q = (sel, root = document) => root.querySelector(sel)																									
const qa = (sel, root = document) => Array.from(root.querySelectorAll(sel))																									
																									
// ===========================																									
// 1) 予約フォーム: 日付制御																									
// ===========================																									
function setupDatePickers() {																									
const todayStr = new Date().toISOString().split("T")[0]																									
																									
const startInput =																									
q('[data-behavior="checkin"]') ||																									
byId("reservation_start_date") ||																									
q('input[name="reservation[start_date]"]')																									
																									
const endInput =																									
q('[data-behavior="checkout"]') ||																									
byId("reservation_end_date") ||																									
q('input[name="reservation[end_date]"]')																									
																									
if (!startInput || !endInput) return																									
																									
startInput.setAttribute("min", todayStr)																									
																									
const syncEndMin = () => {																									
if (!startInput.value) return																									
const start = new Date(startInput.value)																									
const minEnd = new Date(start)																									
minEnd.setDate(start.getDate() + 1)																									
const minStr = minEnd.toISOString().split("T")[0]																									
endInput.setAttribute("min", minStr)																									
if (endInput.value && endInput.value < minStr) endInput.value = minStr																									
}																									
																									
startInput.addEventListener("change", syncEndMin)																									
syncEndMin()																									
}																									
																									
// ===========================																									
// 2) 画像プレビュー																									
// ===========================																									
function setupImagePreviewers() {																									
qa('input[type="file"][data-preview-target]').forEach((input) => {																									
const targetSel = input.getAttribute("data-preview-target")																									
const img = q(targetSel)																									
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
																									
// ===========================																									
// 3) ヘッダーのドロップダウン																									
// ===========================																									
function setupDropdowns() {																									
qa("[data-dropdown-toggle]").forEach((btn) => {																									
const target = q(btn.getAttribute("data-target"))																									
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
																									
// ===========================																									
// 4) フラッシュ自動フェードアウト																									
// ===========================																									
function setupFlashAutoHide() {																									
qa(".flash, .notice, .alert").forEach((el) => {																									
setTimeout(() => {																									
el.style.transition = "opacity 300ms"																									
el.style.opacity = "0"																									
setTimeout(() => (el.style.display = "none"), 300)																									
}, 3000)																									
})																									
}																									
																									
// ===========================																									
// 5) 確認モーダル（施設/予約/アカウント）																									
// ===========================																									
function setupConfirmModal() {																									
if (window.__confirmModalBound) return																									
window.__confirmModalBound = true																									
																									
const modal = byId("confirm-modal")																									
const form = byId("confirm-modal-form")																									
if (!modal || !form) return																									
																									
const titleEl = byId("confirm-modal-title")																									
const msgEl = byId("confirm-modal-message")																									
const imageEl = byId("confirm-modal-image")																									
const priceEl = byId("confirm-modal-price")																									
const extraEl = byId("confirm-modal-extra")																									
const methodInput = byId("confirm-modal-method")																									
const overlay = q(".modal-backdrop", modal)																									
																									
const open = (payload) => {																									
form.setAttribute("action", payload.action || "#")																									
if (methodInput) methodInput.value = (payload.method || "delete").toLowerCase()																									
																									
if (titleEl) titleEl.textContent = payload.title || "確認"																									
if (msgEl) msgEl.textContent = payload.message || "この操作を実行しますか？"																									
																									
if (imageEl) {																									
if (payload.image) {																									
imageEl.src = payload.image																									
imageEl.alt = payload.name || "削除対象"																									
imageEl.hidden = false																									
} else {																									
imageEl.hidden = true																									
}																									
}																									
																									
if (priceEl) {																									
priceEl.textContent = payload.price || ""																									
priceEl.hidden = !payload.price																									
}																									
																									
if (extraEl) {																									
extraEl.textContent = payload.extra || ""																									
extraEl.hidden = !payload.extra																									
}																									
																									
modal.classList.remove("hidden")																									
modal.setAttribute("aria-hidden", "false")																									
console.log("[confirm] opened", payload) // ←一時ログ																									
}																									
																									
const close = () => {																									
modal.classList.add("hidden")																									
modal.setAttribute("aria-hidden", "true")																									
}																									
																									
document.addEventListener("click", (e) => {																									
const trigger = e.target.closest("[data-confirm-target]")																									
if (!trigger) return																									
e.preventDefault()																									
																									
open({																									
action: trigger.dataset.confirmTarget,																									
method: trigger.dataset.confirmMethod || "delete",																									
message: trigger.dataset.confirmMessage || "",																									
title: trigger.dataset.confirmTitle || "",																									
image: trigger.dataset.confirmImage || "",																									
price: trigger.dataset.confirmPrice || "",																									
extra: trigger.dataset.confirmExtra || "",																									
name: trigger.dataset.confirmName || ""																									
})																									
})																									
																									
qa("[data-modal-close]", modal).forEach((el) =>																									
el.addEventListener("click", close)																									
)																									
																									
// ← オプショナルチェーンは禁止なので if に変更																									
if (overlay) {																									
overlay.addEventListener("click", close)																									
}																									
																									
document.addEventListener("keydown", (e) => {																									
if (e.key === "Escape" && !modal.classList.contains("hidden")) close()																									
})																									
}																									
																									
// ===========================																									
// Turbolinks ロード時に初期化																									
// ===========================																									
document.addEventListener("turbolinks:load", () => {																									
setupDatePickers()																									
setupImagePreviewers()																									
setupDropdowns()																									
setupFlashAutoHide()																									
setupConfirmModal()																									
})																									
