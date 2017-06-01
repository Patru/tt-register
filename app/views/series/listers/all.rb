Dir[File.join(File.expand_path(File.dirname(__FILE__)) ,"/*.rb")].each do |lister|
  require lister unless lister == __FILE__
end