import { Controller } from "@hotwired/stimulus"

// Formata como CNJ: NNNNNNN-NN.NNNN.N.NN.NNNN (20 dígitos)
export default class extends Controller {
    static targets = ["input"]

    connect() {
        this.format()
    }

    format() {
        const el = this.inputTarget
        const digits = (el.value || "").replace(/\D/g, "").slice(0, 20) // <- 20 dígitos
        let v = digits

        // Inserções nas posições de dígitos (7-2-4-1-2-4)
        if (v.length > 7)  v = v.slice(0,7) + "-" + v.slice(7)
        if (v.length > 10) v = v.slice(0,10) + "." + v.slice(10)
        if (v.length > 15) v = v.slice(0,15) + "." + v.slice(15)
        if (v.length > 17) v = v.slice(0,17) + "." + v.slice(17)
        if (v.length > 20) v = v.slice(0,20) + "." + v.slice(20)

        el.value = v
    }
}
