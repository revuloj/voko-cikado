local function file_exists(path)
    local f = io.open(path, "r")
    if f then
      f:close()
      return true
    end
    return false
  end

local function get_filter_dir()
    -- en kiu dosierujo ni nun troviĝas: debug.getinfo(1, "S").source - "@.../frontmatter-filters.lua"
    local info = debug.getinfo(1, "S")
    local src = info and info.source or ""
    if src:sub(1, 1) == "@" then
      local path = src:sub(2)
      return pandoc.path.directory(path)
    end
    return "."
  end
  
local function apply_lua_filter_file(doc, path)
    -- kreu propran medion por limigi validecon de nelokaj variabloj
    local env = setmetatable({}, { __index = _G })
    local chunk, err = loadfile(path, "t", env)
    if not chunk then
      io.stderr:write(
        string.format("[AVERTO] Eraro ŝargante lua-filtrilon '%s': %s\n", path, tostring(err))
      )
      return doc
    end
  
    local ok, result = pcall(chunk)
    if not ok then
      io.stderr:write(
        string.format("[AVERTO] Eraro lanĉante lua-filtrilon '%s': %s\n", path, tostring(result))
      )
      return doc
    end
  
    -- Fse ni ricevas filtrilo-tabelon ni trairas per :walk(doc) 
    if type(result) == "table" then
      return doc:walk(result)
    end
  
    -- alternative: la filtrilo difinas nelokajn funkciojn kiel CodeBlock(el) aŭ Pandoc(doc) rekte en env
    local filter_tbl = {}
    for k, v in pairs(env) do
      if type(v) == "function" then
        filter_tbl[k] = v
      end
    end
  
    if next(filter_tbl) ~= nil then
      return doc:walk(filter_tbl)
    end
  
    return doc
  end
  
function Pandoc(doc)
    local filters = doc.meta["lua-filters"]
    if not filters then
      return doc
    end
  
    local filter_list = {}
    local dir = get_filter_dir()

    if filters.t == "MetaList" then
      for _, item in ipairs(filters) do
        table.insert(filter_list, dir.."/"..pandoc.utils.stringify(item))
      end
    else
      table.insert(filter_list, dir.."/"..pandoc.utils.stringify(filters))
    end
  
    for _, filter_path in ipairs(filter_list) do
      if filter_path ~= "" then
        if file_exists(filter_path) then
          doc = apply_lua_filter_file(doc, filter_path)
        else
          io.stderr:write(
            string.format("[AVERTO] Lua-filtrilo ne trovita: '%s'\n", filter_path)
          )
        end
      end
    end
  
    return doc
  end