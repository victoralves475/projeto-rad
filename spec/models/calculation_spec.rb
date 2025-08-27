require "rails_helper"

RSpec.describe Calculation, type: :model do
  let(:user) { create(:user) }

  it "normaliza processo com 20 dígitos para o formato CNJ" do
    c = build(:calculation,
              user: user,
              processo: "00000001234567890123", # 20 dígitos
              crime: "Furto",
              pena:  "1 ano, 0 meses, 0 dias",
              start_date: Date.new(2024,1,1),
              age: 30
    )
    expect(c).to be_valid
    c.save!
    expect(c.processo).to match(/\A\d{7}-\d{2}\.\d{4}\.\d\.\d{2}\.\d{4}\z/)
  end

  it "rejeita processo em formato inválido" do
    c = build(:calculation,
              user: user,
              processo: "123",
              crime: "Furto",
              pena:  "1 ano, 0 meses, 0 dias",
              start_date: Date.new(2024,1,1),
              age: 30
    )
    expect(c).not_to be_valid
    expect(c.errors[:processo]).to be_present
  end

  it "valida idade mínima 18" do
    c = build(:calculation, user: user, age: 17)
    expect(c).not_to be_valid
    expect(c.errors[:age]).to be_present
  end

  it "preenche expires_on e result antes de salvar (não prescrito)" do
    c = build(:calculation,
              user: user,
              processo: "00000001234567890123",
              crime: "Furto",
              pena:  "1 ano, 0 meses, 0 dias",   # faixa <=1 => 3 anos
              start_date: Date.current,
              age: 30
    )
    c.save!
    expect(c.expires_on).to eq(Date.current.advance(years: 3))
    expect(c.result).to eq("Não prescrito")
  end

  it "marca como Prescrito quando start_date é antigo o suficiente" do
    c = build(:calculation,
              user: user,
              processo: "00000001234567890123",
              crime: "Roubo",
              pena:  "13 anos, 0 meses, 0 dias", # base 20 anos
              start_date: 25.years.ago.to_date,
              age: 30
    )
    c.save!
    expect(c.result).to eq("Prescrito")
  end
end
