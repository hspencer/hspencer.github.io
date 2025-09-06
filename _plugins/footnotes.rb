module Jekyll
  module Footnotes
    # ---------------------------------------------------------------------------
    # Filtro: procesa contenido → inserta refs <sup> y rellena page['footnotesList']
    # ---------------------------------------------------------------------------
    def footnotes_process(input)
      return input if input.nil? || input.empty?

      # Evita doble-procesado si el filtro se invoca dos veces en el mismo render.
      page_hash = @context.registers[:page]
      already = page_hash['__footnotes_processed']
      unless already.nil?
        return input
      end

      counter = 0
      notes = []

      # Regex multilinea, captura solo los dobles paréntesis (( ... )) sin procesar el contenido dentro de ellos
      processed = input.gsub(/\(\((.+?)\)\)/m) do |match|
        counter += 1
        idx = counter
        note_content = match[2..-2].strip # Extrae y limpia el contenido de las notas
        notes << note_content

        # Inserta referencia con roles ARIA (WAI-ARIA DPUB)
        %Q{<sup class="fn-ref"><a role="doc-noteref" href="#fn-#{idx}" id="fnref-#{idx}">#{idx}</a></sup>}
      end

      # Expone el array en la página actual y marca como procesado
      page_hash['footnotesList'] = notes
      page_hash['__footnotes_processed'] = true

      processed
    end

    # ---------------------------------------------------------------------------
    # Filtro: renderiza el array de notas en un bloque accesible
    # ---------------------------------------------------------------------------
    def footnotes_render(notes)
      return "" if notes.nil? || notes.empty?

      out = []
      out << %Q{<div id="footnotes" role="doc-endnotes" aria-labelledby="footnotes-label">}
      out << %Q{  <h3 id="footnotes-label">Notas</h3>}
      out << %Q{  <ol>}
      notes.each_with_index do |note, i|
        idx = i + 1
        # Cada nota con role="doc-endnote". Enlace de retorno con flecha.
        out << %Q{    <li id="fn-#{idx}" role="doc-endnote">#{note} <a class="fn-back" href="#fnref-#{idx}" aria-label="Volver a la referencia #{idx}">↩︎</a></li>}
      end
      out << %Q{  </ol>}
      out << %Q{</div>}
      out.join("\n")
    end
  end
end

Liquid::Template.register_filter(Jekyll::Footnotes)