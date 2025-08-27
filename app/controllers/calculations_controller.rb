class CalculationsController < ApplicationController
  before_action :authenticate_user!
  layout "authenticated"

  def index
    @calculations = current_user.calculations.order(created_at: :desc).page(params[:page])
  end

  def new
    @calculation = current_user.calculations.build
  end

  def create
    @calculation = current_user.calculations.build(calculation_params)
    if @calculation.save
      redirect_to dashboard_path, notice: "Cálculo registrado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @calculation = current_user.calculations.find(params[:id])
  end

  def destroy
    @calculation = current_user.calculations.find(params[:id])
    @calculation.destroy
    redirect_to dashboard_path, notice: "Consulta excluída com sucesso."
  end

  # app/controllers/calculations_controller.rb
  def download_pdf
    @calculation = current_user.calculations.find(params[:id])
    pdf = ::Pdfs::CalculationPdf.new(@calculation).render
    send_data pdf,
              filename: "consulta-#{@calculation.id}.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end



  private

  def calculation_params
    params.require(:calculation).permit(:processo, :crime, :pena, :start_date, :age)
  end
end
