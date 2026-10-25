function Pandoc(doc)

  local gh_ref = "https://github.com/revuloj/voko-cikado/tree/master/txt/scienca-revuo/"
  local dosiero = ""
  if PANDOC_STATE.input_files and #PANDOC_STATE.input_files > 0 then
    local filepath = PANDOC_STATE.input_files[1]
    
    -- 1. Get just the filename (e.g., "document.md" from "posts/tech/document.md")
    local filename = filepath:match("^.+/(.+)$") or filepath
    
    -- 2. Get the last part of the path (the parent directory name)
    -- e.g., "tech" from "posts/tech/document.md"
    local dosiero = filepath:match(".*/([^/]+/[^/]+)$")
    gh_ref = gh_ref .. dosiero
  end

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
  local gh_href = '<a href="' .. gh_ref ..'">redaktita teksto</a>'
  local htmlCode = '<p class="referenco"><i>fonto</i>: '..magazino..jaro.. nro..'<br>'..ref..' (PDF); '..gh_href..'</p>'
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