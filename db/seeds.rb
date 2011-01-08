# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
tournaments = Tournament.create([{:name => 'Young Stars Zuerich Competition', :tour_id => 'YSZC'}])
tournament_days = TournamentDay.crate([{:tournament_id => 1, :date => Date.civil(2010, 8, 28), :max_inscirptions => 320}])