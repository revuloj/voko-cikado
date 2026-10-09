function Meta(meta)
    local root = meta.dest_dir and pandoc.utils.stringify(meta.dest_dir) or "."
    local output_path = root .. "/enhavlisto.csv"

    local title = meta.title and pandoc.utils.stringify(meta.title) or "sen titolo"
    local author = meta.author and pandoc.utils.stringify(meta.author) or ""
    local date = meta.date and pandoc.utils.stringify(meta.date) or ""

    -- por krei hiperligojn ni bezonas ankaŭ la dosiernomon 
    local input_file = PANDOC_STATE.input_files[1] or ""
    local filename = input_file:match("([^/]+)%.md$") or input_file:match("([^/]+)$")
    local html_file = (filename ~= "" and filename:gsub("%.md$", "") or "file") .. ".html"    
    
    -- skribu meta-informojn al enhavlisto.csv
    local file, err = io.open(output_path, "a")
    if file then
        file:write(
            '"' .. filename .. '",',
            '"' .. title:gsub('"', '""') .. '",',
            '"' .. author:gsub('"', '""') .. '"\n'
        )
        file:close()
    else
        io.stderr:write("Ne eblis malfermi " .. output_path .. ": " .. tostring(err) .. "\n")
    end

    return meta
end