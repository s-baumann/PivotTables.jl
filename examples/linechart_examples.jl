using JSPlots, DataFrames, Dates

println("Creating LineChart examples...")

# Prepare header
header = TextBlock("""
<h1>LineChart Examples</h1>
<p>This page demonstrates the key features of LineChart plots in JSPlots.</p>
<ul>
    <li><strong>Basic time series:</strong> Simple line chart with date axis</li>
    <li><strong>Multiple series:</strong> Comparing multiple lines with color dimension</li>
    <li><strong>Interactive filters:</strong> Dropdown menus to filter data dynamically</li>
    <li><strong>Integration:</strong> Combining charts with images and text</li>
</ul>
""")

# Example 1: Basic Time Series Line Chart
dates = Date(2024, 1, 1):Day(1):Date(2024, 6, 30)
df1 = DataFrame(
    Date = dates,
    Revenue = cumsum(randn(length(dates)) .* 1000 .+ 50000),
    color = repeat(["Revenue"], length(dates))
)

chart1 = LineChart(:revenue_trend, df1, :revenue_data;
    x_col = :Date,
    y_col = :Revenue,
    color_col = :color,
    title = "Daily Revenue Trend - H1 2024",
    x_label = "Date",
    y_label = "Revenue (\$)",
    notes = "Basic time series showing 6-month revenue trend"
)

# Example 2: Multiple Series Line Chart
df2 = DataFrame(
    Month = repeat(["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], 3),
    Sales = vcat(
        [120, 135, 150, 145, 160, 175, 190, 185, 200, 210, 230, 250],  # 2022
        [130, 145, 165, 160, 180, 195, 210, 205, 220, 235, 255, 280],  # 2023
        [145, 165, 185, 180, 200, 220, 240, 235, 250, 270, 290, 320]   # 2024
    ),
    Year = vcat(repeat(["2022"], 12), repeat(["2023"], 12), repeat(["2024"], 12))
)

chart2 = LineChart(:multi_series, df2, :sales_data;
    x_col = :Month,
    y_col = :Sales,
    color_col = :Year,
    title = "Monthly Sales Comparison Across Years",
    x_label = "Month",
    y_label = "Sales (thousands)",
    notes = "Multiple series chart demonstrating color dimension to compare years"
)

# Example 3: Line Chart with Interactive Filters
departments = ["Engineering", "Sales", "Marketing", "Operations"]
metrics_df = DataFrame()

for dept in departments
    for quarter in ["Q1", "Q2", "Q3", "Q4"]
        for month in 1:3
            month_name = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"][
                             (parse(Int, quarter[2])-1)*3 + month
                         ]
            push!(metrics_df, (
                Department = dept,
                Quarter = quarter,
                Month = month_name,
                Productivity = 70 + rand() * 30,
                Metric = "Productivity"
            ))
        end
    end
end

chart3 = LineChart(:filtered_metrics, metrics_df, :metrics;
    x_col = :Month,
    y_col = :Productivity,
    color_col = :Metric,
    filters = Dict{Symbol,Any}(:Department => "Engineering", :Quarter => "Q1"),
    title = "Department Productivity by Month",
    x_label = "Month",
    y_label = "Productivity Score",
    notes = "Interactive filters allow you to select different departments and quarters"
)

# Example 4: Combined with Image
example_image = joinpath(@__DIR__, "pictures", "images.jpeg")
pic = Picture(:example_visual, example_image;
             notes = "Example visualization image")

conclusion = TextBlock("""
<h2>Key Features Summary</h2>
<ul>
    <li><strong>Time series support:</strong> Automatic date formatting and axis scaling</li>
    <li><strong>Color grouping:</strong> Distinguish multiple series by color</li>
    <li><strong>Interactive filters:</strong> Dropdown menus for dynamic data filtering</li>
    <li><strong>Customization:</strong> Control titles, labels, line width, and markers</li>
    <li><strong>Integration:</strong> Combine with other plot types, images, and text</li>
</ul>
<p><strong>Tip:</strong> Hover over lines to see detailed values!</p>
""")

# Create single combined page
page = JSPlotPage(
    Dict{Symbol,DataFrame}(
        :revenue_data => df1,
        :sales_data => df2,
        :metrics => metrics_df
    ),
    [header, chart1, chart2, chart3, pic, conclusion],
    tab_title = "LineChart Examples"
)

create_html(page, "generated_html_examples/linechart_examples.html")

println("\n" * "="^60)
println("LineChart examples created successfully!")
println("="^60)
println("\nFile created: generated_html_examples/linechart_examples.html")
println("\nThis page includes:")
println("  • Basic time series chart")
println("  • Multiple series with color grouping")
println("  • Interactive filtered chart")
println("  • Integration with images and text")
