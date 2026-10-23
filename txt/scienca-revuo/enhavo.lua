function Meta(meta)
    local root = meta.dest_dir and pandoc.utils.stringify(meta.dest_dir) or "."
    local output_path = root .. "/enhavlisto.csv"

    local title = meta.title and pandoc.utils.stringify(meta.title) or "sen titolo"

    -- local author = meta.author and pandoc.utils.stringify(meta.author) or ""
    local author = ""
    if meta.author then
        -- print("tipo: " .. type(meta.author[1]))
        -- print("author: " .. tostring(meta.author[2]))

        -- povas esti listo...
        if type(meta.author[1]) == "table" then
            local authors = {}
            for _, item in ipairs(meta.author) do
                table.insert(authors, pandoc.utils.stringify(item))
            end
            -- kunigu al listo kun komoj
            author = table.concat(authors, ", ")
        else
            -- nur unu aŭtoro
            author = pandoc.utils.stringify(meta.author)
        end
    end

    local year = meta.year and pandoc.utils.stringify(meta.year) or ""
    local volume = meta.volume and pandoc.utils.stringify(meta.volume) or ""

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
            '"' .. author:gsub('"', '""') .. '",',
            '"' .. year:gsub('"', '""') .. '",',
            '"' .. volume:gsub('"', '""') .. '"\n'
        )
        file:close()
    else
        io.stderr:write("Ne eblis malfermi " .. output_path .. ": " .. tostring(err) .. "\n")
    end

    return meta
end