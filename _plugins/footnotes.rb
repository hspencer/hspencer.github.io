# _plugins/footnotes.rb

# OK, esta es la versión definitiva. Mis disculpas por el largo y frustrante viaje.
# Hemos aprendido dos cosas:
# 1. Necesitamos ejecutar nuestro código ANTES que el conversor de Markdown para ganar la "carrera".
# 2. Necesitamos separar las notas del contenido para que se ajusten a tu layout de sidebar.
#
# Esta solución hace ambas cosas usando el hook `:pre_render`. Se ejecuta en el
# momento perfecto: sobre el contenido crudo, antes de la conversión, pero con acceso
# al objeto `doc` para poder pasar datos a la plantilla.
#
# También, y más importante, corrige el error `NoMethodError` al inicializar
# el array de notas correctamente con ``. Esta es la arquitectura limpia y robusta
# que buscábamos desde el inicio.

require 'kramdown'

module Jekyll
  Jekyll::Hooks.register :documents, :pre_render do |doc|
    footnote_counter = 0
    
    # --- LA CORRECCIÓN DEL ÚLTIMO Y PERSISTENTE ERROR ---
    # Inicializamos 'footnotes' como un array vacío (``). Ahora sí es una lista
    # a la que podemos añadirle elementos con `<<`.
    footnotes = []

    # Modificamos el contenido del documento ANTES de que lo vea Kramdown.
    doc.content.gsub!(/\(\((.*?)\)\)/m) do |match|
      footnote_counter += 1
      footnote_text = $1.strip
      footnotes << footnote_text

      # Reemplazamos ((...)) por el HTML del superíndice.
      # Kramdown verá esto como HTML y lo respetará, no lo procesará.
      "<sup id=\"fnref:#{footnote_counter}\" class=\"footnote\"><a href=\"#fn:#{footnote_counter}\" rel=\"footnote\">#{footnote_counter}</a></sup>"
    end

    # Si encontramos notas, construimos el bloque de HTML para la lista.
    if footnote_counter > 0
      notes_html = '<div class="footnotes"><hr><ol>'
      footnotes.each_with_index do |note, index|
        # Procesamos el texto de cada nota como Markdown para permitir formato.
        note_content = Kramdown::Document.new(note).to_html.gsub(/<\/?p>\s?/, '').strip
        notes_html += "<li id=\"fn:#{index + 1}\"><p>#{note_content} <a href=\"#fnref:#{index + 1}\" class=\"reversefootnote\" title=\"volver al texto\">↩</a></p></li>"
      end
      notes_html += '</ol></div>'

      # Guardamos el bloque de HTML en una variable de la página.
      # Ahora es accesible en tu layout como `{{ page.footnotes_html }}`.
      doc.data['footnotes_html'] = notes_html
    end
  end
end