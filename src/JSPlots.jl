module JSPlots

    using CSV, DataFrames, JSON, Dates, DuckDB, DBInterface, Base64

    abstract type JSPlotsType end

    include("pivottables.jl")
    export PivotTable

    include("linechart.jl")
    export LineChart

    include("threedchart.jl")
    export Chart3d

    include("scatterplot.jl")
    export ScatterPlot

    include("distplot.jl")
    export DistPlot

    include("kerneldensity.jl")
    export KernelDensity

    include("textblock.jl")
    export TextBlock

    include("picture.jl")
    export Picture

    include("table.jl")
    export Table

    include("make_html.jl")
    export JSPlotPage, create_html

end # module JSPlots
