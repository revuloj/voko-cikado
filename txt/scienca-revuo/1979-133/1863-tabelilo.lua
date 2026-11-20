-- vicordo de reĝistroj
local suffix_cycle = { "B", "C", "D", "E", "H", "L", "M", "A" }

local function dbg(msg)
    io.stderr:write(tostring(msg) .. "\n")
    io.stderr:flush()
  end

local function find_index(tbl, val)
  for i, v in ipairs(tbl) do
    if v == val then return i end
  end
  return 1
end

local function trim(s)
  return s:match("^%s*(.-)%s*$")
end

local function split_pipe(line)
  local parts = {}
  -- Alles bis zum nächsten '|' oder bis Zeilenende erfassen
  for field in (line .. "|"):gmatch("([^|]*)|") do
    table.insert(parts, trim(field))
  end
  return parts
end

-- transformi deksesuman nombron en bitmaskon
-- bits: longo, apriore 8
local function hex_to_bitmask(val, bits)
  -- se ni reicevos signaron "0x42" aŭ "42" ni konvertu unue al nombro
  local num = type(val) == "string"
    and tonumber(val:gsub("^0[xX]", ""), 16)
    or val

  if not num then return "" end

  bits = bits or 8 -- apriore 8 bitoj
  local chars = {}

  for i = bits - 1, 0, -1 do
    -- ĉu la bito ĉe la pozicio i estas 1 aŭ 0?
    local is_set = ((num >> i) & 1) == 1
    table.insert(chars, is_set and "■" or "□")

    -- ĉe la kvina pozicio ni aldonos punkton
    if i > 0 and (i == 3) then
      table.insert(chars, ".")
    end
  end

  return table.concat(chars)
end

-- generilo por tabelo 6
-- start_hex: komenca nombro deksesuma (ekz-e 0x40)
-- cmd:       komando (ekz. "MOV")
-- target:    celreĝistro (ekz-e "B")
-- start_suf: fontreĝistro (ekz-e "B")
-- count:     kiom da linioj ni kreu (apriore: 8)
local function generate_rows_tab6(start_hex, cmd, target, start_suf, count)
  count = count or #suffix_cycle
  local start_idx = find_index(suffix_cycle, start_suf)
  local rows = {}

  for i = 0, count - 1 do
    local hex_val = start_hex + i
    local hex_str = string.format("%02X", hex_val)
    local suf = suffix_cycle[((start_idx - 1 + i) % #suffix_cycle) + 1]

    table.insert(rows, {
      instr = string.format("%s %s %s,%s", hex_str, cmd,  target, suf)
    })
  end

  return rows
end

-- generilo por tabelo 7
-- hex:   nombro deksesuma (ekz-e 0x42)
-- sign:  mlg. nomo de signo/stirkodo (ekz. "B", "DEL")
-- klav:  kloav(kombin)o (ekz-e "CTRL B")
-- rim:   rimarkigo
-- ni kreas la trian kolumnon kiel bitmasko, ekz-e □■□□□.□■□
local function generate_row_tab7(hex, sign, klav, rim)
    -- dbg("tab7 "..hex.." "..sign)
    count = count or #suffix_cycle
    local start_idx = find_index(suffix_cycle, start_suf)

    local bitmask = hex_to_bitmask(hex)

    -- local row = {}
    -- table.insert(row, {
    --   instr = {
    --     hex, sign, bitmask, klav, rim
    --   }
    -- })
-- 
    -- return row

    return {
      instr = {
        hex, sign, bitmask, klav, rim
      }
    }
end

-- ############################ ĝeneralaj helpfunkcioj por krei tabelon #######

local function dump_val(v, indent, seen)
  indent = indent or ""
  seen = seen or {}

  local t = type(v)
  if t == "string" then
    return string.format("%q", v)
  elseif t == "number" or t == "boolean" or t == "nil" then
    return tostring(v)
  elseif t ~= "table" and t ~= "userdata" then
    return string.format("<%s: %s>", t, tostring(v))
  end

  if seen[v] then
    return "<cycle>"
  end
  seen[v] = true

  -- Pandoc-AST-Objekte haben oft eine eigene String-Repräsentation
  if pandoc and pandoc.utils and pandoc.utils.stringify then
    local ok, str = pcall(pandoc.utils.stringify, v)
    if ok and str and str ~= "" and t == "userdata" then
      return string.format("userdata(str=%q)", str)
    end
  end

  local parts = { "{" }
  local next_indent = indent .. "  "

  for k, val in pairs(v) do
    local key_str = type(k) == "string" and k or ("[" .. tostring(k) .. "]")
    table.insert(parts, string.format(
      "\n%s%s = %s,",
      next_indent,
      key_str,
      dump_val(val, next_indent, seen)
    ))
  end

  table.insert(parts, "\n" .. indent .. "}")
  return table.concat(parts)
end

local function make_cell(val)
    local str = tostring(val or "")
    if str == "" then
      return { pandoc.Plain({}) }
    end
    return { pandoc.Plain({ pandoc.Str(str) }) }
  end  

local function make_blank_row()
    return pandoc.Row({
      make_cell("")
    })
  end

local function make_colspecs(num_cols, aligns, widths)
  local colspecs = {}
  for i = 1, num_cols do
    local align = (aligns and aligns[i]) or pandoc.AlignLeft
    local width = (widths and widths[i]) or pandoc.ColWidthDefault
    table.insert(colspecs, { align, width })
  end
  return colspecs
end  

local function make_table_head(header_line, aligns)
  local labels = split_pipe(header_line)
  local cells = {}

  for i, label in ipairs(labels) do
    -- evtl. analizu Inline-Markdown anst. pandoc.Str:
    -- local blocks = pandoc.read(label, "markdown").blocks
    -- local cell_blocks = (#blocks > 0 and blocks[1].t == "Para")
    --   and { pandoc.Plain(blocks[1].content) }
    --   or { pandoc.Plain({ pandoc.Str(label) }) }

    local cell_blocks = label ~= ""
      and { pandoc.Plain({ pandoc.Str(label) }) }
      or {}

    local align = (aligns and aligns[i]) or pandoc.AlignDefault
    table.insert(cells, pandoc.Cell(cell_blocks, align))
  end

  local header_row = pandoc.Row(cells)
  return pandoc.TableHead({ header_row })
end  

local function make_simple_headers(header_line)
    local labels = split_pipe(header_line)
    local headers = {}
  
    for _, label in ipairs(labels) do
      -- In SimpleTable ist jeder Header-Eintrag eine Liste von Inlines (z. B. { pandoc.Str(...) })
      if label ~= "" then
        table.insert(headers, { pandoc.Str(label) })
      else
        table.insert(headers, {})
      end
    end
  
    return headers
  end  

local function build_pandoc_table(all_rows, header_line, classes)
  dbg("kapo: "..header_line)
  dbg("linioj: "..#all_rows)

  -- moderna AST (Pandoc 2.10+ kun TableBody)
  -- vd. https://pandoc.org/lua-filters.html#pandoc.Table
  if pandoc.TableBody then
      local body_rows = {}
      for _, r in ipairs(all_rows) do
          if r.blank then
              table.insert(body_rows, make_blank_row())
          else
              table.insert(body_rows, pandoc.Row({
                  make_cell(r.instr)
              }))
          end
      end 

      local header_row = make_table_head(header_line)
      local col_count = #header_row.cells
      local colspecs = make_colspecs(col_count)
      local attr = pandoc.Attr("", classes, {})
  
      -- local header_row = pandoc.Row({})
      -- if (kapo) then
      --     header_row = pandoc.Row({ make_cell(kapo) })
      -- end

      return pandoc.Table(
          attr,
          colspecs,
          pandoc.TableHead({ header_row }),
          { 
            pandoc.TableBody({}, 0, {}, body_rows) 
          },
          pandoc.TableFoot({})
      )
  end

  -- por malnovaj Pandoc-versioj ni uzos SimpleTable
  if pandoc.SimpleTable then

      local headers = make_simple_headers(header_line)
      local col_count = #headers
      dbg("#kol: "..col_count)

      local aligns = {}
      local widths = {}
      
      for i = 1, col_count do
        table.insert(aligns, pandoc.AlignLeft)
        table.insert(widths, 0) -- 0 = automatische Breite in SimpleTable
      end

      -- local headers = {}
      -- if kapo then
      --     headers = {
      --     { pandoc.Plain({ pandoc.Str(kapo) }) }
      --     }
      -- end
      
      local rows_blocks = {}
      for _, r in ipairs(all_rows) do
        --dbg("r: "..dump_val(r))        
        if r.blank then
          -- malplena linio
          table.insert(rows_blocks, {
              { pandoc.Plain({ "" }) }
          })
        elseif type(r.instr) == "table" then
          -- pluraj kolumnoj, kreu rikordon "cells"
          local cells = {}
          for _, field in ipairs(r.instr) do
            table.insert(cells, make_cell(field))
          end
          table.insert(rows_blocks, cells)
        else     
          -- simpla signaro aŭ nil 
          table.insert(rows_blocks, { make_cell(r.instr) })
        end
      end

      --local non_empty = 0
      --for _, row in ipairs(rows_blocks) do
      --  for _, cell in ipairs(row) do
      --    local blk = cell[1]
      --    if blk and blk.content and #blk.content > 0 then
      --      non_empty = non_empty + 1
      --    end
      --  end
      --end
      --dbg("rows=" .. #rows_blocks .. ", non_empty_cells=" .. non_empty)

      local st = pandoc.SimpleTable(
        {},
        aligns,
        widths, -- kolumn-larĝoj, evt. ni devas doni tiom da "0", kiom ni havas kolumnojn?
        headers,
        rows_blocks
      )
      if pandoc.utils and pandoc.utils.from_simple_table then
        return pandoc.utils.from_simple_table(st)
      end
      return st
    end

  -- se nenio alia funkcios ni skribos Markdown-tabelon

  -- local lines = { header_line, "| --- | --- |" }
  -- for _, r in ipairs(all_rows) do
  --     if r.blank then
  --         table.insert(lines, "||")
  --     else
  --         table.insert(lines, string.format("| %s |", r.instr))
  --     end
  -- end
  -- return pandoc.RawBlock("markdown", table.concat(lines, "\n"))
end

  
function CodeBlockTab6(el)
  dbg("tab-6")
  local combined = {}
  header = ""

  -- Ni preparas la enhavon de la tabelo
  -- ĉiu linioj en la teksto havu formon: <start_hex> <cmd> <target> <start_suf> [count]
  -- ekz-e: 0x40 MOV B B 8 kreos ok liniojn en kiuj la deksesuma nombro inkrementiĝos
  -- kaj la fontreĝistro trairos ĉiujn laŭ ordo
  for line in el.text:gmatch("[^\r\n]+") do
      local trimmed = trim(line) --line:match("^%s*(.-)%s*$")
      if trimmed ~= "" and not trimmed:match("^#") then
        if (header == "") then
          header = trimmed
        else
          local hex_s, cmd, target, start_suf, count_s =
              trimmed:match("^(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s*(%S*)$")

          local start_hex = tonumber(hex_s)
          local count = tonumber(count_s)

          if start_hex and cmd and target and start_suf then
              --if #combined > 0 then
              --    table.insert(combined, { blank = true })
              --end

              local rows = generate_rows_tab6(start_hex, cmd, target, start_suf, count)
              for _, r in ipairs(rows) do
                table.insert(combined, r)
              end

              -- malplena linio post unu bloko
              table.insert(combined, { blank = true })
          end
        end
      end
  end

  -- el la preparita enhavo ni nun kreas la pandoc-tabelon    
  return build_pandoc_table(combined,header,el.classes) -- anstataŭ malplenan kapon ni eble uzu la unuan linion, ĉu?
end  

  
function CodeBlockTab7(el)
  dbg("tab-7")

  local combined = {}
  local header = ""

  -- Ni preparas la enhavon de la tabelo, la unua linio estu la kolumnnomoj
  -- kaj la ceteraj linioj havu formon: <hex>|<sign>|<klav>|<rim>
  -- ekz-e: 
  -- 16-uma kodo|Mnemoniko aŭ karaktro|Teletajpilaj klavoj|Rimarkigoj
  -- 00|NUL|CTRL SHIFT|Plenigo
  -- 81|SOH|CTRL A|Kapumkomenco  
  -- - (unuopa minussigno montras malplenan linion)
  for line in el.text:gmatch("[^\r\n]+") do
    local trimmed = trim(line)

    if trimmed ~= "" and not trimmed:match("^#") then
      -- unua malplena linio estu la kaplinio
      if (header == "") then
        header = trimmed
      elseif (trimmed == "-") then
        -- malplena linio post unu bloko
        table.insert(combined, { blank = true })
      else
        local cols = split_pipe(trimmed)
        local row = generate_row_tab7(cols[1], cols[2], cols[3], cols[4])
        --dbg("ri: "..dump_val(row))
        table.insert(combined, row)
      end
    end
  end

  -- el la preparita enhavo ni nun kreas la pandoc-tabelon    
  return build_pandoc_table(combined,header,el.classes) 
end  

function CodeBlock(el)
  --dbg("CodeBlock")
  dbg(el.classes)

  if el.classes:includes("gen-table-6") then
    return CodeBlockTab6(el)
  elseif el.classes:includes("gen-table-7") then
    return CodeBlockTab7(el)
  end

  return nil
end