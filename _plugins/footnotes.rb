# _plugins/footnotes.rb
# -----------------------------------------------------------------------------
# (( ... )) → gestiona notas al pie accesibles y ubicables en cualquier parte.
#
# QUÉ HACE:
# 1) footnotes_process:
#    - Recorre el contenido, captura ((nota)).
#    - Reemplaza cada ((nota)) por una referencia <sup><a …></a></sup> con
#      atributos ARIA (rol doc-noteref) y anclas bidireccionales.
#    - Acumula las notas en page['footnotesList'] (array) para renderizarlas
#      donde quieras (sidebar, footer, etc.).
# 2) footnotes_render:
#    - Recibe un array (normalmente page.footnotesList) y lo imprime como:
#      <div id="footnotes" role="doc-endnotes" aria-labelledby="footnotes-label">
#        <h3 id="footnotes-label">Notas</h3>
#        <ol>…</ol>
#      </div>
#
# USO EN LAYOUT:
#   {{ content | footnotes_process | markdownify }}      <!-- en <article> -->
#   {{ page.footnotesList | footnotes_render }}          <!-- en el sidebar -->
#
# NOTAS:
# - Orden IMPORTA: primero footnotes_process, luego markdownify, para que
#   no se muestren los ((...)) crudos en el artículo.
# - Tras editar _plugins/, reinicia `jekyll serve`.
# - Si publicas en GitHub Pages (build del servidor), plugins personalizados
#   no se ejecutan: compila localmente y publica _site/docs o usa Actions.
# -----------------------------------------------------------------------------

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

      # Regex multilinea, captura no-greedy entre doble paréntesis (( ... ))
      processed = input.gsub(/\(\((.+?)\)\)/m) do
        counter += 1
        idx = counter

        # Guarda la nota tal cual (si quieres forzar texto plano, aquí podrías sanear).
        notes << Regexp.last_match(1).strip

        # Inserta referencia con roles ARIA (WAI-ARIA DPUB)
        # - role="doc-noteref" para la referencia
        # - id/anchors emparejadas fnref-# ↔ fn-#
        %Q{<sup class="fn-ref"><a role="doc-noteref" href="#fn-#{idx}" id="fnref-#{idx}" aria-describedby="footnotes-label">#{idx}</a></sup>}
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