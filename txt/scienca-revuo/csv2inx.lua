-- File: csv_to_index.lua
function Table(tbl)
    -- Aaldonu kapon: Titolo, Aŭtoro
    tbl.head = pandoc.TableHead({
        pandoc.Row({
            pandoc.Cell(pandoc.Para(pandoc.Strong("Titolo"))),
            pandoc.Cell(pandoc.Para(pandoc.Strong("Aŭtoro"))),
            pandoc.Cell(pandoc.Para(pandoc.Strong("Jaro"))),
            pandoc.Cell(pandoc.Para(pandoc.Strong("Numero")))
        })
    })

    -- Trairu liniojn el CSV-dosiero
    for _, body in ipairs(tbl.bodies) do
        for _, row in ipairs(body.body) do
            local cells = row.cells
            if #cells >= 2 then
                -- Dosiernomon ni atendas en kolumno 1, kaj apude la titolon
                local filename = pandoc.utils.stringify(cells[1].contents)
                local title_text = pandoc.utils.stringify(cells[2].contents)

                -- aldnu finaĵon .html
                if not filename:match("%.html$") then
                    filename = filename .. ".html"
                end

                -- Metu en kolumno 1 hiperligon el dosiernomo kaj titolo
                -- Ceterajn kolumnojn ŝovu je unu maldekstren
                local link = pandoc.Link(title_text, filename)
                cells[1] = pandoc.Cell(pandoc.Para({link}))
                table.remove(cells, 2)
            end
        end
    end
    return tbl
end