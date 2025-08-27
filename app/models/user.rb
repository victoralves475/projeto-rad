class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :calculations, dependent: :destroy

  def suspended?
    suspended_at.present?
  end

  # Impede login de usuário suspenso
  def active_for_authentication?
    super && !suspended?
  end

  # Mensagem do Devise ao tentar logar suspenso
  def inactive_message
    suspended? ? :suspended : super
  end
end
