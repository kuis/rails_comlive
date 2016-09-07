require 'barby'
require 'barby/barcode/bookland'
require 'barby/barcode/code_128'
require 'barby/barcode/code_25'
require 'barby/barcode/code_25_interleaved'
require 'barby/barcode/code_25_iata'
require 'barby/barcode/code_39'
require 'barby/barcode/code_93'
require 'barby/barcode/ean_13'
require 'barby/barcode/ean_8'
require 'barby/barcode/gs1_128'
require 'barby/barcode/qr_code'
require 'barby/barcode/upc_supplemental'
# require 'barby/barcode/pdf_417'
# require 'barby/barcode/data_matrix' => unable to install dependency semacode

require 'barby/outputter/html_outputter'

class BarcodeGenerator

  def initialize(barcode)
    raise ArgumentError.new("Not a valid barcode") unless BARCODE_FORMATS.include?(barcode.format)
    klass = normalize_class(barcode.format)
    @barcode = klass.new(barcode.content)
  end

  def generate
    @barcode.to_html
  end

  private

  def normalize_class(type)
    case type
      when "gs1_128"
        Barby::GS1128
      when  "ean_13"
        Barby::EAN13
      when "ean_8"
        Barby::EAN8
      when "upc_supplemental"
        Barby::UPCSupplemental
      else
        "Barby/#{type}".classify.constantize
    end
  end
end
