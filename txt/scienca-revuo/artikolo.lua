function Span (el)
    if el.classes:includes("maldense") then
      if FORMAT:match("html") then
        -- HTML: CSS pli maldensa literaranĝo
        el.attributes["style"] = "letter-spacing: 0.08em;"
        return el
      elseif FORMAT:match("latex") then
        -- LaTeX/PDF: uzi microtype \textls 
        -- (alternatice \so{} el la pakaĵo soul-)
        local content = pandoc.utils.stringify(el.content)
        return pandoc.RawInline("latex", "\\textls{" .. content .. "}")
      end
    end
    return el
  end