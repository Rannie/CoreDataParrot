Pod::Spec.new do |s|
  s.name         = "CoreDataParrot"
  s.version      = "0.1.0"
  s.summary      = "CoreData stack management and quick query language library (Swift)."
  s.homepage     = "https://github.com/Rannie/CoreDataParrot"
  s.license      = "MIT"
  s.author    	 = "Hanran Liu"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Rannie/CoreDataParrot.git", :tag => s.version }
  s.source_files = "CoreDataParrot", "CoreDataParrot/*.swift"
  s.framework    = "CoreData"
  s.requires_arc = true
end