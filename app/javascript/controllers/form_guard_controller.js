import { Controller } from "@hotwired/stimulus"

// Controla a validade do formulário da Calculation
export default class extends Controller {
    static targets = [
        "processo", "crime", "startDate", "age",
        "years", "months", "days", "submit"
    ]

    connect() {
        this.validate()
    }

    validate() {
        const processo = (this.processoTarget.value || "").trim()
        const crime = (this.crimeTarget.value || "").trim()
        const startDate = (this.startDateTarget.value || "").trim()
        const ageRaw = (this.ageTarget.value || "").trim()

        // CNJ: NNNNNNN-NN.NNNN.N.NN.NNNN
        const cnjRegex = /^\d{7}-\d{2}\.\d{4}\.\d\.\d{2}\.\d{4}$/

        // Idade >= 0 (inteiro)
        const age = Number.parseInt(ageRaw, 10)
        const ageValid = Number.isInteger(age) && age >= 18

        // Pena não pode ser 0/0/0
        const y = Number.parseInt(this.yearsTarget.value || "0", 10) || 0
        const m = Number.parseInt(this.monthsTarget.value || "0", 10) || 0
        const d = Number.parseInt(this.daysTarget.value || "0", 10) || 0
        const penaOk = (y + m + d) > 0

        // Campo a campo (classes Bootstrap)
        this.setValidity(this.processoTarget, cnjRegex.test(processo))
        this.setValidity(this.crimeTarget, crime.length > 0)
        this.setValidity(this.startDateTarget, startDate.length > 0)
        this.setValidity(this.ageTarget, ageValid)
        this.setGroupValidity([this.yearsTarget, this.monthsTarget, this.daysTarget], penaOk)

        // Form ok?
        const formValid = cnjRegex.test(processo) && crime && startDate && ageValid && penaOk
        this.submitTarget.disabled = !formValid
    }

    setValidity(inputEl, ok) {
        inputEl.classList.toggle("is-invalid", !ok)
        inputEl.classList.toggle("is-valid", ok && inputEl.value.trim().length > 0)
    }

    setGroupValidity(els, ok) {
        els.forEach(el => {
            el.classList.toggle("is-invalid", !ok)
            el.classList.toggle("is-valid", ok && (el.value ?? "") !== "")
        })
    }
}
