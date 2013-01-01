# encoding: UTF-8

require 'views/columns.rb'

module Views::Tables
  def data_fields worker, *fields
    if fields.length == 1 and fields[0].is_a?(Array)
      fields = fields[0]
    end
    fields.each do |sym|
      td do 
        text worker.send(sym)
      end
    end
  end
  def headers *fields
    if fields.length == 1 and fields[0].is_a?(Array)
      fields = fields[0]
    end
    tr do 
      fields.each do |field|
        th :align => 'left' do 
          text Views::Columns.header(field)
        end
      end
    end
  end
  
  def stylo_image
    @@stylo_image ||= capture{image_tag("stylo.png", :border=>0)}
  end

  def lightning_image
    @@lightning_image ||= capture{image_tag("lightning.png", :border=>0)}
  end

  def eye_image
    @@eye_image ||= capture{image_tag("show.png", :border=>0)}
  end
end