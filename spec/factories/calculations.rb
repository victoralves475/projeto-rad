FactoryBot.define do
  factory :calculation do
    # CNJ válido já formatado
    processo { "0000001-23.4567.8.90.1234" }
    crime    { "Furto" }
    pena     { "1 ano, 0 meses, 0 dias" }
    start_date { Date.today }
    age        { 30 }
    association :user
  end
end
