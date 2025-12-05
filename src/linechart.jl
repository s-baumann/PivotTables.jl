
struct LineChart <: JSPlotsType
    chart_title::Symbol
    data_label::Symbol
    functional_html::String
    appearance_html::String
    function LineChart(chart_title::Symbol, df::DataFrame, data_label::Symbol;
                            x_col::Symbol=:x,
                            y_col::Symbol=:y,
                            color_col::Symbol=:color,
                            filters::Dict{Symbol, Any}=Dict{Symbol, Any}(),
                            facet_cols::Union{Nothing, Symbol, Vector{Symbol}}=nothing,
                            title::String="Line Chart",
                            x_label::String="",
                            y_label::String="",
                            line_width::Int=1,
                            marker_size::Int=1,
                            notes::String="")

        # Normalize facet_cols to array
        facet_array = if facet_cols === nothing
            Symbol[]
        elseif facet_cols isa Symbol
            [facet_cols]
        else
            facet_cols
        end

        # Validate facet_cols
        if length(facet_array) > 2
            error("facet_cols can have at most 2 columns")
        end

        # Get unique values for each filter column
        filter_options = Dict()
        for col in keys(filters)
            filter_options[string(col)] = unique(df[!, col])
        end

        # Get unique color values and assign colors
        unique_colors = unique(df[!, color_col])
        color_palette = ["#636efa", "#EF553B", "#00cc96", "#ab63fa", "#FFA15A",
                        "#19d3f3", "#FF6692", "#B6E880", "#FF97FF", "#FECB52"]
        color_map = Dict(
            key => color_palette[(i - 1) % length(color_palette) + 1]
            for (i, key) in enumerate(unique_colors)
        )

        dropdowns_html = ""
        for col in keys(filters)
            # Get default value for this column
            default_val = filters[col]
            # Build options HTML with selected attribute
            options_html = ""
            for opt in filter_options[string(col)]
                selected = (opt == default_val) ? " selected" : ""
                options_html *= "                <option value=\"$(opt)\"$selected>$(opt)</option>\n"
            end
            dropdowns_html *= """
            <div style="margin: 10px;">
                <label for="$(col)_select">$(col): </label>
                <select id="$(col)_select" onchange="updateChart_$chart_title()">
    $options_html            </select>
            </div>
            """
        end


        # Create filter column names as JavaScript array
        filter_cols_js = "[" * join(["'$col'" for col in keys(filters)], ", ") * "]"

        # Create facet column names as JavaScript array
        facet_cols_js = "[" * join(["'$col'" for col in facet_array], ", ") * "]"

        # Create color map as JavaScript object
        color_map_js = "{" * join(["'$k': '$v'" for (k, v) in color_map], ", ") * "}"

        functional_html = """
        (function() {
            // Configuration
            const X_COL = '$x_col';
            const Y_COL = '$y_col';
            const COLOR_COL = '$color_col';
            const FILTER_COLS = $filter_cols_js;
            const FACET_COLS = $facet_cols_js;
            const COLOR_MAP = $color_map_js;
            const X_LABEL = '$x_label';
            const Y_LABEL = '$y_label';

            let allData = [];

            // Make it global so inline onchange can see it
            window.updateChart_$chart_title = function() {
                const filters = {};
                FILTER_COLS.forEach(col => {
                    const select = document.getElementById(col + '_select');
                    if (select) {
                        filters[col] = select.value;
                    }
                });

                const filteredData = allData.filter(row => {
                    for (let col in filters) {
                        if (String(row[col]) !== String(filters[col])) {
                            return false;
                        }
                    }
                    return true;
                });

                if (FACET_COLS.length === 0) {
                    // No faceting - original behavior
                    const groupedData = {};
                    filteredData.forEach(row => {
                        const colorVal = row[COLOR_COL];
                        if (!groupedData[colorVal]) {
                            groupedData[colorVal] = [];
                        }
                        groupedData[colorVal].push(row);
                    });

                    const traces = [];
                    for (let colorVal in groupedData) {
                        const group = groupedData[colorVal];
                        group.sort((a, b) => a[X_COL] - b[X_COL]);

                        traces.push({
                            x: group.map(row => row[X_COL]),
                            y: group.map(row => row[Y_COL]),
                            type: 'scatter',
                            mode: 'lines+markers',
                            name: colorVal,
                            line: {
                                color: COLOR_MAP[colorVal] || '#000000',
                                width: $line_width
                            },
                            marker: { size: $marker_size }
                        });
                    }

                    const layout = {
                        xaxis: { title: X_LABEL || X_COL },
                        yaxis: { title: Y_LABEL || Y_COL },
                        hovermode: 'closest',
                        showlegend: true
                    };

                    Plotly.newPlot('$chart_title', traces, layout, {responsive: true});

                } else if (FACET_COLS.length === 1) {
                    // Facet wrap
                    const facetCol = FACET_COLS[0];
                    const facetValues = [...new Set(filteredData.map(row => row[facetCol]))].sort();
                    const nFacets = facetValues.length;

                    // Calculate grid dimensions (prefer wider grids)
                    const nCols = Math.ceil(Math.sqrt(nFacets * 1.5));
                    const nRows = Math.ceil(nFacets / nCols);

                    const traces = [];
                    const layout = {
                        hovermode: 'closest',
                        showlegend: true,
                        grid: {rows: nRows, columns: nCols, pattern: 'independent'}
                    };

                    facetValues.forEach((facetVal, idx) => {
                        const facetData = filteredData.filter(row => row[facetCol] === facetVal);

                        // Group by color within this facet
                        const groupedData = {};
                        facetData.forEach(row => {
                            const colorVal = row[COLOR_COL];
                            if (!groupedData[colorVal]) {
                                groupedData[colorVal] = [];
                            }
                            groupedData[colorVal].push(row);
                        });

                        const row = Math.floor(idx / nCols) + 1;
                        const col = (idx % nCols) + 1;
                        const xaxis = idx === 0 ? 'x' : 'x' + (idx + 1);
                        const yaxis = idx === 0 ? 'y' : 'y' + (idx + 1);

                        for (let colorVal in groupedData) {
                            const group = groupedData[colorVal];
                            group.sort((a, b) => a[X_COL] - b[X_COL]);

                            traces.push({
                                x: group.map(row => row[X_COL]),
                                y: group.map(row => row[Y_COL]),
                                type: 'scatter',
                                mode: 'lines+markers',
                                name: colorVal,
                                legendgroup: colorVal,
                                showlegend: idx === 0,
                                xaxis: xaxis,
                                yaxis: yaxis,
                                line: {
                                    color: COLOR_MAP[colorVal] || '#000000',
                                    width: $line_width
                                },
                                marker: { size: $marker_size }
                            });
                        }

                        // Add axis configuration
                        layout[xaxis] = {
                            title: row === nRows ? (X_LABEL || X_COL) : '',
                            anchor: yaxis
                        };
                        layout[yaxis] = {
                            title: col === 1 ? (Y_LABEL || Y_COL) : '',
                            anchor: xaxis
                        };

                        // Add annotation for facet label
                        if (!layout.annotations) layout.annotations = [];
                        layout.annotations.push({
                            text: facetCol + ': ' + facetVal,
                            showarrow: false,
                            xref: xaxis === 'x' ? 'x domain' : xaxis + ' domain',
                            yref: yaxis === 'y' ? 'y domain' : yaxis + ' domain',
                            x: 0.5,
                            y: 1.05,
                            xanchor: 'center',
                            yanchor: 'bottom',
                            font: {size: 10}
                        });
                    });

                    Plotly.newPlot('$chart_title', traces, layout, {responsive: true});

                } else {
                    // Facet grid (2 facet columns)
                    const facetRow = FACET_COLS[0];
                    const facetCol = FACET_COLS[1];
                    const rowValues = [...new Set(filteredData.map(row => row[facetRow]))].sort();
                    const colValues = [...new Set(filteredData.map(row => row[facetCol]))].sort();
                    const nRows = rowValues.length;
                    const nCols = colValues.length;

                    const traces = [];
                    const layout = {
                        hovermode: 'closest',
                        showlegend: true,
                        grid: {rows: nRows, columns: nCols, pattern: 'independent'}
                    };

                    rowValues.forEach((rowVal, rowIdx) => {
                        colValues.forEach((colVal, colIdx) => {
                            const facetData = filteredData.filter(row =>
                                row[facetRow] === rowVal && row[facetCol] === colVal
                            );

                            // Group by color within this facet
                            const groupedData = {};
                            facetData.forEach(row => {
                                const colorVal = row[COLOR_COL];
                                if (!groupedData[colorVal]) {
                                    groupedData[colorVal] = [];
                                }
                                groupedData[colorVal].push(row);
                            });

                            const idx = rowIdx * nCols + colIdx;
                            const xaxis = idx === 0 ? 'x' : 'x' + (idx + 1);
                            const yaxis = idx === 0 ? 'y' : 'y' + (idx + 1);

                            for (let colorVal in groupedData) {
                                const group = groupedData[colorVal];
                                group.sort((a, b) => a[X_COL] - b[X_COL]);

                                traces.push({
                                    x: group.map(row => row[X_COL]),
                                    y: group.map(row => row[Y_COL]),
                                    type: 'scatter',
                                    mode: 'lines+markers',
                                    name: colorVal,
                                    legendgroup: colorVal,
                                    showlegend: idx === 0,
                                    xaxis: xaxis,
                                    yaxis: yaxis,
                                    line: {
                                        color: COLOR_MAP[colorVal] || '#000000',
                                        width: $line_width
                                    },
                                    marker: { size: $marker_size }
                                });
                            }

                            // Add axis configuration
                            layout[xaxis] = {
                                title: rowIdx === nRows - 1 ? (X_LABEL || X_COL) : '',
                                anchor: yaxis
                            };
                            layout[yaxis] = {
                                title: colIdx === 0 ? (Y_LABEL || Y_COL) : '',
                                anchor: xaxis
                            };

                            // Add annotations for facet labels
                            if (!layout.annotations) layout.annotations = [];

                            // Column header
                            if (rowIdx === 0) {
                                layout.annotations.push({
                                    text: facetCol + ': ' + colVal,
                                    showarrow: false,
                                    xref: xaxis === 'x' ? 'x domain' : xaxis + ' domain',
                                    yref: yaxis === 'y' ? 'y domain' : yaxis + ' domain',
                                    x: 0.5,
                                    y: 1.1,
                                    xanchor: 'center',
                                    yanchor: 'bottom',
                                    font: {size: 10}
                                });
                            }

                            // Row label
                            if (colIdx === nCols - 1) {
                                layout.annotations.push({
                                    text: facetRow + ': ' + rowVal,
                                    showarrow: false,
                                    xref: xaxis === 'x' ? 'x domain' : xaxis + ' domain',
                                    yref: yaxis === 'y' ? 'y domain' : yaxis + ' domain',
                                    x: 1.05,
                                    y: 0.5,
                                    xanchor: 'left',
                                    yanchor: 'middle',
                                    textangle: -90,
                                    font: {size: 10}
                                });
                            }
                        });
                    });

                    Plotly.newPlot('$chart_title', traces, layout, {responsive: true});
                }
            };

            // Load and parse CSV data using centralized parser
            loadDataset('$data_label').then(function(data) {
                allData = data;
                window.updateChart_$chart_title();
            }).catch(function(error) {
                console.error('Error loading data for chart $chart_title:', error);
            });
        })();
        """

        appearance_html = """
        <h2>$title</h2>
        <p>$notes</p>
        
        <!-- Controls -->
        <div id="controls">
            $dropdowns_html
        </div>
        
        <!-- Chart -->
        <div id="$chart_title"></div>
        <br><hr><br>
        """

        new(chart_title, data_label, functional_html, appearance_html)
    end
end



