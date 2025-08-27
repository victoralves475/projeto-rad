require "rails_helper"

RSpec.describe PrescricaoCalculator do
  let(:base_date) { Date.new(2020, 1, 1) }

  def calc(pena:, age:)
    # Objeto Calculation “falso” suficiente para o serviço
    Calculation.new(pena: pena, start_date: base_date, age: age)
  end

  it "usa a tabela do art. 109 (ex.: >1..<=2 => 4 anos)" do
    result = described_class.call(calc(pena: "2 anos, 0 meses, 0 dias", age: 30))
    expect(result[:expires_on]).to eq(base_date.advance(years: 4))
    expect(%w[Prescrito Não prescrito]).to include(result[:status])
  end

  it "aplica redução pela metade para idade < 21" do
    # base 4 anos (mesma pena), com idade 18 -> 2 anos
    result = described_class.call(calc(pena: "2 anos, 0 meses, 0 dias", age: 18))
    expect(result[:expires_on]).to eq(base_date.advance(years: 2))
  end

  it "classifica >12 anos em 20 anos" do
    result = described_class.call(calc(pena: "13 anos, 0 meses, 0 dias", age: 30))
    expect(result[:expires_on]).to eq(base_date.advance(years: 20))
  end

  it "parseia singular/plural (ano/anos, mês/meses, dia/dias)" do
    # 1 ano, 1 mês, 1 dia -> ~ 1 + 1/12 + 1/365 anos -> cai na faixa >1..<=2 (4 anos base)
    result = described_class.call(calc(pena: "1 ano, 1 mês, 1 dia", age: 30))
    expect(result[:expires_on]).to eq(base_date.advance(years: 4))
  end
end
