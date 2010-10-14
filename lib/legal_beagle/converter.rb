require 'jekyll'
require 'pathname'
require 'legal_beagle/to_prawn'

module LegalBeagle
  class Converter
    include Jekyll::Convertible
  
    attr_accessor :content, :data, :ext
  
    def initialize(filename)
      file = Pathname.new(filename)
      self.ext     = file.extname
      self.content = file.read
      read_yaml(file.dirname, file.basename)
    end
  
    def transform
      Maruku.new(content).to_prawn(@pdf)
    end
    
    def render(pdf)
      @pdf = pdf
      self.content = Liquid::Template.parse(self.content).render(data, {})
      self.transform
    end
  end
end
