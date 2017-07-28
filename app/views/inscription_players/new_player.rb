# encoding: UTF-8

class Views::InscriptionPlayers::NewPlayer < Views::InscriptionPlayers::InscriptionPlayer
#  needs :player, :inscription, :inscription_player => nil
  
  def page_title
    t(:new_enrollment)
  end

  def sw_content
    form_tag({:controller => 'inscription_players', :action => 'enroll'}, id:'enrollments') do
      rawtext error_messages_for(:inscription_player, header_message: t('error.header.save_inscription'),
                                 message: t('error.problems_occurred'))
      if defined?(@sel_series) and @sel_series then
        sel_series = @sel_series
      else
        sel_series = []
      end
      widget tournament.layouter, {:player => @player, :inscription => @inscription, :selected_series => sel_series}
      input :type => "submit", :value => t(:inscribe)
    end
  end
end