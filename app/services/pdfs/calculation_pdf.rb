# app/services/pdfs/calculation_pdf.rb
# frozen_string_literal: true

require "prawn"
require "prawn/table"

module Pdfs
  class CalculationPdf
    def initialize(calculation)
      @c = calculation
    end

    def render
      Prawn::Document.new(page_size: "A4", margin: 54) do |pdf|
        register_noto_sans(pdf) # fonte UTF-8 (acentos)
        header(pdf)
        details_table(pdf)
        footer(pdf)

        # Numeração de páginas
        pdf.number_pages "Página <page> de <total>",
                         at: [ pdf.bounds.right - 120, 0 ],
                         width: 120, align: :right, size: 9
      end.render
    end

    private

    # Registra a família Noto Sans (TTF) se os arquivos existirem.
    # Coloque os arquivos em:
    #   app/assets/fonts/NotoSans/NotoSans-Regular.ttf
    #   app/assets/fonts/NotoSans/NotoSans-Bold.ttf
    #   app/assets/fonts/NotoSans/NotoSans-Italic.ttf
    #   app/assets/fonts/NotoSans/NotoSans-BoldItalic.ttf
    def register_noto_sans(pdf)
      dir = Rails.root.join("app/assets/fonts/NotoSans")
      regular     = dir.join("NotoSans-Regular.ttf")
      bold        = dir.join("NotoSans-Bold.ttf")
      italic      = dir.join("NotoSans-Italic.ttf")
      bold_italic = dir.join("NotoSans-BoldItalic.ttf")

      return unless File.exist?(regular)

      # Se algum estilo não existir, reusa o regular para evitar erro.
      bold        = regular unless File.exist?(bold)
      italic      = regular unless File.exist?(italic)
      bold_italic = regular unless File.exist?(bold_italic)

      pdf.font_families.update(
        "NotoSans" => {
          normal:      regular,
          bold:        bold,
          italic:      italic,
          bold_italic: bold_italic
        }
      )
      pdf.font "NotoSans"
    end

    def header(pdf)
      pdf.text "Calculadora de Prescrição", size: 18, style: :bold, align: :center
      pdf.move_down 6
      pdf.text "Consulta ##{@c.id}", size: 11, align: :center
      pdf.move_down 18
    end

    def details_table(pdf)
      data = [
        [ "Processo",     @c.processo ],
        [ "Crime",        @c.crime ],
        [ "Pena",         @c.pena ],
        [ "Data inicial", @c.start_date ? I18n.l(@c.start_date, format: :br) : "-" ],
        [ "Idade",        @c.age.to_s ],
        [ "Prescreve em", @c.expires_on ? I18n.l(@c.expires_on, format: :br) : "-" ],
        [ "Resultado",    @c.result.to_s ]
      ]

      # Deixa o rótulo (coluna 1) em negrito usando inline_format
      data.each { |row| row[0] = "<b>#{row[0]}</b>" }

      pdf.table(
        data,
        cell_style:   { padding: [ 6, 8, 6, 8 ], borders: [ :bottom ], border_width: 0.5, inline_format: true },
        column_widths: [ 120, pdf.bounds.width - 120 ]
      )
      pdf.move_down 12
    end

    def footer(pdf)
      pdf.move_down 8
      pdf.text "Gerado em #{I18n.l(Date.current, format: :br)}", size: 9, align: :right
    end
  end
end
