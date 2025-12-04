using JSPlots, DataFrames, Dates, Random, Distributions

println("Creating DistPlot examples...")

Random.seed!(42)

# Prepare header
header = TextBlock("""
<h1>DistPlot Examples</h1>
<p>This page demonstrates distribution visualization combining histogram, box plot, and rug plot.</p>
<ul>
    <li><strong>Single distribution:</strong> Basic histogram + box plot + rug plot</li>
    <li><strong>Group comparison:</strong> Compare distributions across multiple groups</li>
    <li><strong>Interactive filters:</strong> Slider controls for categorical and numeric ranges</li>
    <li><strong>Customization:</strong> Toggle histogram, box, and rug plot visibility</li>
</ul>
<p><em>Use sliders and multi-select controls to filter and explore the data!</em></p>
""")

# Example 1: Simple Distribution - Single Group
n = 1000
df1 = DataFrame(
    value = randn(n) .* 10 .+ 50
)

distplot1 = DistPlot(:simple_dist, df1, :df1;
    value_col = :value,
    title = "Simple Distribution Plot",
    value_label = "Values",
    notes = "Basic distribution showing histogram, box plot, and rug plot for a normal distribution"
)

# Example 2: Multiple Groups Comparison
n = 500
df2 = DataFrame(
    value = vcat(
        randn(n) .* 5 .+ 100,  # Control group
        randn(n) .* 6 .+ 110,  # Treatment A
        randn(n) .* 4 .+ 95    # Treatment B
    ),
    group = repeat(["Control", "Treatment A", "Treatment B"], inner=n)
)

distplot2 = DistPlot(:multi_group_dist, df2, :df2;
    value_col = :value,
    group_col = :group,
    title = "Treatment Effect Comparison",
    value_label = "Response Value",
    notes = "Compare distributions across different treatment groups using group_col"
)

# Example 3: Interactive Filters with Range Sliders
n = 1200
df3 = DataFrame(
    score = abs.(randn(n) .* 15 .+ 70),
    age = rand(18:80, n),
    department = rand(["Engineering", "Sales", "Marketing", "HR"], n)
)

distplot3 = DistPlot(:filtered_dist, df3, :df3;
    value_col = :score,
    slider_col = [:age, :department],
    histogram_bins = 40,
    title = "Score Distribution with Interactive Filters",
    value_label = "Test Score",
    notes = "Use age range slider and department multi-select to filter data dynamically"
)

# Example 4: Customized Appearance
n = 600
df4 = DataFrame(
    measurement = vcat(
        randn(n÷5) .* 8 .+ 100,
        randn(n÷5) .* 7 .+ 105,
        randn(n÷5) .* 6 .+ 108,
        randn(n÷5) .* 6 .+ 110,
        randn(n÷5) .* 5 .+ 112
    ),
    time_point = repeat(["Baseline", "Week 1", "Week 2", "Week 3", "Week 4"], inner=n÷5)
)

distplot4 = DistPlot(:custom_appearance, df4, :df4;
    value_col = :measurement,
    group_col = :time_point,
    show_histogram = true,
    show_box = true,
    show_rug = false,
    box_opacity = 0.8,
    histogram_bins = 30,
    title = "Customized DistPlot - Longitudinal Study",
    value_label = "Clinical Measurement",
    notes = "Demonstrates customization options: rug plot hidden, increased box opacity, custom bin count"
)

conclusion = TextBlock("""
<h2>Key Features Summary</h2>
<ul>
    <li><strong>Three-in-one visualization:</strong> Histogram, box plot, and rug plot combined</li>
    <li><strong>Group comparison:</strong> Overlay distributions for different groups with color coding</li>
    <li><strong>Interactive filtering:</strong> Range sliders for numeric columns, multi-select for categorical</li>
    <li><strong>Customization options:</strong> Control visibility and appearance of each component</li>
    <li><strong>Statistical insight:</strong> See shape, central tendency, spread, and outliers at once</li>
</ul>
<p><strong>Tip:</strong> The rug plot (tick marks at the bottom) shows individual data points!</p>
""")

# Create single combined page
page = JSPlotPage(
    Dict{Symbol,DataFrame}(
        :df1 => df1,
        :df2 => df2,
        :df3 => df3,
        :df4 => df4
    ),
    [header, distplot1, distplot2, distplot3, distplot4, conclusion],
    tab_title = "DistPlot Examples"
)

create_html(page, "generated_html_examples/distplot_examples.html")

println("\n" * "="^60)
println("DistPlot examples created successfully!")
println("="^60)
println("\nFile created: generated_html_examples/distplot_examples.html")
println("\nThis page includes:")
println("  • Simple single-group distribution")
println("  • Multiple groups comparison")
println("  • Interactive filters (numeric and categorical)")
println("  • Customized appearance options")
