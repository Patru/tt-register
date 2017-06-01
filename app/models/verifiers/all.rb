Dir[File.join(File.expand_path(File.dirname(__FILE__)) ,"/*.rb")].each do |verifier|
  require verifier unless verifier == __FILE__
end