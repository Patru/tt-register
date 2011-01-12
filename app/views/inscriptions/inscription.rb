class Views::Inscriptions::Inscription < Views::Layouts::SWPage
  @@fields=[:licence, :name]
  def fields
    @@fields
  end
  @@header_fields = [:tournament].concat @@fields
  @@header_fields << :email
  def header_fields
    @@header_fields
  end

  def inscription_form(button_text)
    form_for(@inscription) do |f|
      rawtext f.error_messages(:header_message => "Fehler beim Anlegen der Einschreibung",
                               :message => "Folgende Felder müssen korrigiert werden:")
      table do
        tr do
          td :class => 'label' do
            rawtext f.label(Views::Labels.label(:tournament_id))
          end
          td do
            rawtext f.collection_select(:tournament_id, @tournaments, :id, :name)
          end
        end
        form_text_field f, :licence
        form_text_field f, :name
        if @inscription.new_record? then
          form_text_field f, :email
        else
          if @admin or @inscription.id.eql? session[:id] then
            form_hidden_field f, :email
          end
        end
      end
      p do
        rawtext f.submit(button_text)
      end
    end
  end

  def see_email?
    own_inscription? or @admin
  end

  def own_inscription?
    @inscription and @inscription.id == session[:id]
  end
end