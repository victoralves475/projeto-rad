import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["years", "months", "days", "hidden", "preview"]

    connect() {
        this.normalizeAndUpdate()
    }

    normalizeAndUpdate() {
        let y = parseInt(this.yearsTarget.value || "0", 10) || 0
        let m = parseInt(this.monthsTarget.value || "0", 10) || 0
        let d = parseInt(this.daysTarget.value || "0", 10) || 0

        // limites simples
        if (y < 0) y = 0
        if (m < 0) m = 0
        if (d < 0) d = 0
        if (m > 11) m = 11
        if (d > 29) d = 29

        this.yearsTarget.value = y
        this.monthsTarget.value = m
        this.daysTarget.value = d

        // pluralização correta
        const part = (n, s, p) => `${n} ${n === 1 ? s : p}`
        const str = [
            part(y, "ano", "anos"),
            part(m, "mês", "meses"),
            part(d, "dia", "dias")
        ].join(", ")

        // salva no hidden e mostra preview
        this.hiddenTarget.value = str
        if (this.hasPreviewTarget) this.previewTarget.textContent = str
    }
}
