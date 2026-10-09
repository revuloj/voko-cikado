-- File: csv_to_index.lua
function Table(tbl)
    -- Add custom headers: Titolo, Aŭtoro
    tbl.head = pandoc.TableHead({
        pandoc.Row({
            pandoc.Cell(pandoc.Para(pandoc.Strong("Titolo"))),
            pandoc.Cell(pandoc.Para(pandoc.Strong("Aŭtoro")))
        })
    })

    -- Iterate through rows generated from the CSV
    for _, body in ipairs(tbl.bodies) do
        for _, row in ipairs(body.body) do
            local cells = row.cells
            if #cells >= 2 then
                -- Extract filename from col 1 and title text from col 2
                local filename = pandoc.utils.stringify(cells[1].contents)
                local title_text = pandoc.utils.stringify(cells[2].contents)

                -- Append .html extension if missing
                if not filename:match("%.html$") then
                    filename = filename .. ".html"
                end

                -- Replace cell 1 with a hyperlinked title: [Title](filename.html)
                local link = pandoc.Link(title_text, filename)
                cells[1] = pandoc.Cell(pandoc.Para({link}))

                -- Keep author in cell 2, drop original filename column
                if cells[3] then
                    cells[2] = cells[3]
                    cells[3] = nil
                end
            end
        end
    end
    return tbl
end