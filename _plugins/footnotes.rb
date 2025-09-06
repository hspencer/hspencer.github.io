

require 'kramdown'

module Jekyll
  Jekyll::Hooks.register :documents, :pre_render do |doc|
    footnote_counter = 0
    footnotes = []

    # Cómo funciona:
    #   \(\(          # Busca el "((" de apertura literal.
    #   (             # Inicia la captura del contenido de la nota.
    #     (?:         # Es un grupo que no captura, pero que nos deja agrupar opciones:
    #       [^()]+    #   Opción 1: Captura cualquier caracter que NO sea un paréntesis.
    # | #   O...
    #       \(.*?\)   #   Opción 2: Captura un bloque completo de paréntesis, desde su "(" hasta su ")".
    #     )+          # Repite este proceso una o más veces.
    #   )             # Termina la captura del contenido.
    #   \)\)          # Busca el "))" de cierre literal.
    #
    # Esto le permite "saltar" por encima de los paréntesis internos sin detenerse.

    nested_parens_regex = /\(\(( (?: [^()]+ | \(.*?\) )+ )\)\)/xm

    doc.content.gsub!(nested_parens_regex) do |match|
      footnote_counter += 1
      # Usamos $1 porque la regex ahora tiene un grupo de captura principal.
      footnote_text = $1.strip
      footnotes << footnote_text

      # Reemplazamos ((...)) por el HTML del superíndice.
      "<sup id=\"fnref:#{footnote_counter}\" class=\"footnote\"><a href=\"#fn:#{footnote_counter}\" rel=\"footnote\">#{footnote_counter}</a></sup>"
    end

    # Si encontramos notas, construimos el bloque de HTML para la lista.
    if footnote_counter > 0
      notes_html = '<div class="footnotes"><h3>Notas</h3><ol>'
      footnotes.each_with_index do |note, index|
        note_content = Kramdown::Document.new(note).to_html.gsub(/<\/?p>\s?/, '').strip
        notes_html += "<li id=\"fn:#{index + 1}\"><p>#{note_content} <a href=\"#fnref:#{index + 1}\" class=\"reversefootnote\" title=\"volver al texto\">↩</a></p></li>"
      end
      notes_html += '</ol></div>'

      # Guardamos el bloque de HTML en una variable de la página.
      doc.data['footnotes_html'] = notes_html
    end
  end
end