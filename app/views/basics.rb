# encoding: UTF-8

module Views
  module Basics
    def headers *fields
      if fields.length == 1 and fields[0].is_a?(Array)
        fields = fields[0]
      end
      thead do
        tr do
          fields.each do |field|
            th :align => 'left' do
              text column_header(field)
            end
          end
        end
      end
    end

    def headers_with_class tr_class, *fields
      if fields.length == 1 and fields[0].is_a?(Array)
        fields = fields[0]
      end
      thead do
        tr :class=>tr_class do
          fields.each do |field|
            th :align => 'left' do
              text column_header(field)
            end
          end
        end
      end
    end

    def column_header(symbol)
      attribute_label symbol
    end

    def attribute_label(symbol)
      I18n.t("attributes.#{symbol}")
    end

    def translated_text(clazz, symbol)
      trans_text=clazz.human_attribute_name(symbol)+":"
      if trans_text =~ /missing/
        trans_text = Views::Labels.label(symbol)
      end
      trans_text
    end

    def label_text(form, symbol)
      translated_text form.object.class, symbol
    end
  end
end
