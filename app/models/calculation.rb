class Calculation < ApplicationRecord

  paginates_per 10
  max_paginates_per 100

  belongs_to :user

  CNJ_REGEX = /\A\d{7}-\d{2}\.\d{4}\.\d\.\d{2}\.\d{4}\z/

    before_validation :normalize_processo_cnj
  before_save :compute_prescricao

  validates :processo, presence: true,
            format: { with: CNJ_REGEX, message: "deve estar no formato 0000000-00.0000.0.00.0000" }
  validates :crime, :pena, :start_date, :age, presence: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 18 }

  private

  def normalize_processo_cnj
    return if processo.blank?
    digits = processo.gsub(/\D/, "")
    if digits.length == 20
      self.processo = [
        digits[0, 7],  "-", digits[7, 2],  ".", digits[9, 4],
        ".", digits[13, 1], ".", digits[14, 2], ".", digits[16, 4]
      ].join
    end
  end

  def compute_prescricao
    calc = PrescricaoCalculator.call(self)
    self.expires_on = calc[:expires_on]
    self.result     = calc[:status]
  end

end
