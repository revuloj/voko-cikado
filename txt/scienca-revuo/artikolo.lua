function Pandoc(doc)
  local license = '<p class="referenco"><i>laŭ permeso</i>: <a href="https://creativecommons.org/licenses/by-nd/4.0/">CC BY-ND 4.0</a></p>'  
  local license_block = pandoc.RawBlock('html', license)
  -- aldonu komence de la dokumento
  table.insert(doc.blocks, 1, license_block)

  -- kunigo tekston por la fonto kaj same enŝovu tute supre
  local magazino = doc.meta.magazine and pandoc.utils.stringify(doc.meta.magazine)..", " or "Scienca Revuo "
  local jaro = doc.meta.year and pandoc.utils.stringify(doc.meta.year) or ""
  local nro = doc.meta.volume and " n-ro "..pandoc.utils.stringify(doc.meta.volume)..", " or ""

  local url = ''
  local ref = ''
  if doc.meta.source then
    url = pandoc.utils.stringify(doc.meta.source)
    -- artikolnumero estas ĉe la fino de URL
    local id = url:match("([%d]+)$") or url
    ref = '<a href="' .. url .. '">artikolo ' .. id .. '</a>'
  end

  -- kreu HTML-referencon
  local htmlCode = '<p class="referenco"><i>fonto</i>: '..magazino..jaro.. nro..ref..'</p>'
  local source_block = pandoc.RawBlock('html', htmlCode)
  
  -- aldonu komence de la dokumento
  table.insert(doc.blocks, 1, source_block)

  return doc
end

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