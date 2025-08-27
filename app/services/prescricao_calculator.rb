# app/services/prescricao_calculator.rb
class PrescricaoCalculator
  # Regras simplificadas para fins acadêmicos (CP, art. 109 e 115).
  # Base: período prescricional em ANOS calculado a partir da pena "aplicada".
  # Tabela (art. 109):
  #   >12 anos  -> 20 anos
  #   >8..<=12  -> 16 anos
  #   >4..<=8   -> 12 anos
  #   >2..<=4   -> 8 anos
  #   >1..<=2   -> 4 anos
  #   <=1       -> 3 anos
  #
  # Redução pela idade (art. 115): menor de 21 no fato OU maior de 70 na sentença => reduz pela metade.
  #
  # Entrada: Calculation (com :pena string "X anos, Y meses, Z dias", :start_date date, :age integer)
  # Saída: { expires_on: Date, status: "Prescrito"|"Não prescrito" }
  def self.call(calculation)
    pena_years = parse_pena_to_years(calculation.pena)
    base_years = period_by_pena(pena_years)

    factor = (calculation.age.present? && (calculation.age < 21 || calculation.age >= 70)) ? 0.5 : 1.0
    period_years = base_years * factor

    expires_on = advance_years_fraction(calculation.start_date, period_years)
    status = Date.current > expires_on ? "Prescrito" : "Não prescrito"

    { expires_on:, status: }
  end

  # "2 anos, 4 meses, 0 dias" -> 2 + 4/12 + 0/365
  def self.parse_pena_to_years(pena_str)
    return 0.0 if pena_str.blank?
    # tenta extrair números na ordem anos/meses/dias (compatível com Stimulus)
    if (m = pena_str.match(/(\d+)\s*ano[s]?.*?(\d+)\s*m[eê]s(?:es)? .*?(\d+)\s*dia[s]?/i))
      y, mm, dd = m.captures.map(&:to_i)
      return y + (mm.to_f / 12.0) + (dd.to_f / 365.0)
    end
    # fallback: pega todos os inteiros e preenche y, m, d
    parts = pena_str.scan(/\d+/).map(&:to_i)
    y, mm, dd = (parts + [0,0,0]).first(3)
    y + (mm.to_f / 12.0) + (dd.to_f / 365.0)
  end

  def self.period_by_pena(pena_years)
    return 20 if pena_years > 12
    return 16 if pena_years > 8
    return 12 if pena_years > 4
    return 8  if pena_years > 2
    return 4  if pena_years > 1
    3
  end

  # Avança uma fração de anos sobre uma Date usando advance (anos/meses).
  def self.advance_years_fraction(start_date, years_float)
    years = years_float.floor
    months = ((years_float - years) * 12).round
    (start_date || Date.current).advance(years:, months:)
  end
end
