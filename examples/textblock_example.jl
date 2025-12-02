using JSPlots, DataFrames, Dates

# Example 1: Simple text block with basic HTML
text1 = TextBlock("""
<h2>Introduction</h2>
<p>This is a simple text block that provides context for the visualizations below.</p>
<p>You can use standard HTML formatting including <strong>bold</strong>, <em>italic</em>, and <code>code</code>.</p>
""")

# Example 2: Text block with lists
text2 = TextBlock("""
<h2>Key Findings</h2>
<ul>
    <li>The distribution shows a clear bimodal pattern</li>
    <li>Group A has a higher mean than Group B</li>
    <li>Outliers are present in both groups</li>
</ul>
""")

# Example 3: Text block with a table
text3 = TextBlock("""
<h2>Summary Statistics</h2>
<table>
    <thead>
        <tr>
            <th>Metric</th>
            <th>Group A</th>
            <th>Group B</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Mean</td>
            <td>105.3</td>
            <td>98.7</td>
        </tr>
        <tr>
            <td>Std Dev</td>
            <td>12.4</td>
            <td>15.8</td>
        </tr>
        <tr>
            <td>Sample Size</td>
            <td>150</td>
            <td>150</td>
        </tr>
    </tbody>
</table>
""")

# Example 4: Combining text blocks with actual plots
df = DataFrame(
    x = 1:10,
    y = rand(10) .* 100,
    color = repeat(["A", "B"], inner=5)
)

line_plot = LineChart(:example_chart, df, :df;
    x_col = :x,
    y_col = :y,
    color_col = :color,
    title = "Sample Data",
    x_label = "Time",
    y_label = "Value"
)

intro_text = TextBlock("""
<h1>Analysis Report</h1>
<p><em>Generated on $(Dates.format(now(), "yyyy-mm-dd HH:MM:SS"))</em></p>
<h2>Overview</h2>
<p>This report presents the analysis of our sample data collected over the past period.</p>
""")

conclusion_text = TextBlock("""
<h2>Conclusions</h2>
<p>Based on the analysis above, we can conclude that:</p>
<ol>
    <li>The data shows moderate variability</li>
    <li>No significant outliers are present</li>
    <li>Further investigation is recommended</li>
</ol>
<h3>Next Steps</h3>
<p>For more information, contact the data science team.</p>
""")

# Create a page combining text blocks and plots
page = JSPlotPage(
    Dict{Symbol,DataFrame}(:df => df),
    [intro_text, line_plot, conclusion_text],
    tab_title = "Analysis Report with Text"
)

create_html(page, "generated_html_examples/textblock_example.html")

# You can also create a page with just text blocks (no plots)
page_text_only = JSPlotPage(
    Dict{Symbol,DataFrame}(),  # Empty dataframes dict
    [text1, text2, text3],
    tab_title = "Documentation Page"
)

create_html(page_text_only, "generated_html_examples/textblocks_only.html")

println("TextBlock examples created successfully!")
println("  - textblock_example.html (mixed text and plots)")
println("  - textblocks_only.html (text blocks only)")
