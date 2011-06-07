# encoding: UTF-8

require 'prawn'

module MaRuKu::Out::Prawn
  def to_prawn(pdf)
    @pdf = pdf
    array_to_prawn(@children)
  end
  
  def array_to_prawn(children)
    children.each do |c|
      send("to_prawn_#{c.node_type}", c)
    end
  end

  def to_prawn_ul(ul)
    ul.children.each do |c|
      to_prawn_li_span(c)
    end
    @pdf.text ' '
  end
  
  def to_prawn_li_span(li)
    if li.children.empty?
      text = li.to_html
    else
      text = to_pdf_string(li.children)
    end
    
    @pdf.text "  •  " + text, :indent_paragraphs => 20
  end
  
  def to_prawn_paragraph(para)
    text = to_pdf_string(para.children)
    @pdf.text text, :inline_format => true
    @pdf.text ' '
  end

  def to_pdf_string(children)
    children.inject("") do |t, c|
      if c.is_a? String
        t + c
      else
        t + send("to_prawn_string_#{c.node_type}", c)
      end
    end
  end

  def to_prawn_string_emphasis(em)
    "<em>#{to_pdf_string(em.children)}</em>"
  end

  def to_prawn_string_strong(strong)
    "<strong>#{to_pdf_string(strong.children)}</strong>"
  end

  def entity_table
    @table ||= {
      "lsquo" => "‘",
      "rsquo" => "’",
      "ldquo" => "“",
      "rdquo" => "”"
    }
  end
  
  def to_prawn_string_paragraph(para)
    para.to_html
  end
  
  def to_prawn_string_entity(entity)
    name = entity.entity_name
    typographic = entity_table[name]
    raise "I don't know how to make a typographic #{name}" unless typographic
    typographic
  end
  
  # TODO find a less ghetto way to do leading-trailing margins
  def to_prawn_header(header)
    size = { 1 => 16, 2 => 12 }[header.level]
    @pdf.text header.children.join("\n"), :size => size, :style => :bold
    @pdf.text ' '
  end
  
  def to_prawn_div(div)
    if div.attributes[:class] == "signature"
      signature_name = div.children.map.join(" ")
      @pdf.instance_eval do
        text ' ', :size => 30
        stroke_horizontal_line 0, 200
        stroke_horizontal_line 250, 300
        text ' ', :size => 4
        text signature_name
        draw_text "Date", :at => [250, y - bounds.absolute_bottom + 5]
        text ' ', :size => 20
        stroke_horizontal_line 0, 200
        text ' ', :size => 4
        text signature_name + " (Print)"
      end
    else
      puts "Didn't write div to pdf: #{div.inspect}"      
    end
  end
end

MaRuKu::MDElement.send(:include, MaRuKu::Out::Prawn)
