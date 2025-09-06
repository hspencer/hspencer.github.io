# _plugins/footnotes.rb

# ¡Felicidades! Arreglaste mi error de tipeo y llegamos al jefe final:
# el renderizado de Markdown DENTRO de las notas.
#
# El problema: Al extraer el texto de la nota ANTES de que Kramdown procese el
# post, ese texto se queda como texto plano. Nunca pasa por el conversor.
#
# La solución: Le enseñamos a nuestro plugin a usar Kramdown por su cuenta.
# Por cada nota que extraemos, invocamos al conversor de Kramdown para que
# procese ESE FRAGMENTO específico. Es una operación quirúrgica que nos da
# lo mejor de ambos mundos: nuestra sintaxis y todo el poder de Kramdown.

require 'kramdown'

module Jekyll
  Jekyll::Hooks.register :documents, :pre_render do |doc|
    footnote_counter = 0
    footnotes = []

    # Modificamos el contenido del documento ANTES de que lo vea Kramdown.
    doc.content.gsub!(/\(\((.*?)\)\)/m) do |match|
      footnote_counter += 1
      footnote_text = $1.strip
      footnotes << footnote_text

      # Reemplazamos ((...)) por el HTML del superíndice.
      "<sup id=\"fnref:#{footnote_counter}\" class=\"footnote\"><a href=\"#fn:#{footnote_counter}\" rel=\"footnote\">#{footnote_counter}</a></sup>"
    end

    # Si encontramos notas, construimos el bloque de HTML para la lista.
    if footnote_counter > 0
      notes_html = '<div class="footnotes"><hr><ol>'
      footnotes.each_with_index do |note, index|
        
        # --- LA LÍNEA MÁGICA ---
        # Aquí es donde le pedimos a Kramdown que haga su trabajo.
        # 1. `Kramdown::Document.new(note)`: Toma el texto plano de la nota.
        # 2. `.to_html`: Lo convierte a HTML, procesando cualquier Markdown que contenga.
        # 3. `.gsub(...)`: Le quitamos las etiquetas <p> que Kramdown añade por defecto
        #    para que no arruinen el formato dentro de nuestro <li>.
        note_content = Kramdown::Document.new(note).to_html.gsub(/<\/?p>\s?/, '').strip
        
        notes_html += "<li id=\"fn:#{index + 1}\"><p>#{note_content} <a href=\"#fnref:#{index + 1}\" class=\"reversefootnote\" title=\"volver al texto\">↩</a></p></li>"
      end
      notes_html += '</ol></div>'

      # Guardamos el bloque de HTML en una variable de la página.
      doc.data['footnotes_html'] = notes_html
    end
  end
end