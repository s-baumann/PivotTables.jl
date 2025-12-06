using JSPlots, DataFrames

println("Creating 3D Chart examples...")

# Prepare header
header = TextBlock("""
<h1>3D Chart Examples</h1>
<p>This page demonstrates 3D surface plots in JSPlots using Plotly with interactive controls.</p>
<ul>
    <li><strong>Dimension selection:</strong> Choose which variables to display on x, y, and z axes</li>
    <li><strong>Grouping:</strong> Compare multiple groups with different color gradients</li>
    <li><strong>Filtering:</strong> Filter data with interactive sliders</li>
    <li><strong>Multiple surfaces:</strong> Visualize several datasets on the same 3D plot</li>
    <li><strong>Interactive controls:</strong> Rotate, zoom, and pan to explore from all angles</li>
</ul>
<p><em>Click and drag to rotate the 3D plots. Use scroll wheel to zoom!</em></p>
""")

# Example 1: Basic 3D Surface - Mathematical Function
example1_text = TextBlock("""
<h2>Example 1: Basic 3D Surface</h2>
<p>A simple 3D surface showing a ripple pattern. This demonstrates the basic usage with a single surface.</p>
""")

x_range = -5:0.2:5
y_range = -5:0.2:5
surface_df = DataFrame()

for x in x_range
    for y in y_range
        z = sin(sqrt(x^2 + y^2))
        push!(surface_df, (x=x, y=y, z=z, group="Ripple"))
    end
end

chart1 = Chart3d(:basic_surface, surface_df, :surface_data, [:x, :y, :z];
    group_cols = :group,
    title = "3D Surface: sin(√(x² + y²))",
    x_label = "X",
    y_label = "Y",
    z_label = "Z",
    notes = "Classic ripple pattern - demonstrates basic 3D surface visualization"
)

# Example 2: Multiple Dimensions with Axis Selection
example2_text = TextBlock("""
<h2>Example 2: Multiple Dimensions with Axis Selection</h2>
<p>This example demonstrates the ability to choose which dimensions to display on each axis. Try selecting different combinations!</p>
""")

multi_dim_df = DataFrame()

for x in -5:0.3:5
    for y in -5:0.3:5
        # Create multiple dimensions
        z1 = sin(sqrt(x^2 + y^2))
        z2 = cos(sqrt(x^2 + y^2))
        z3 = 0.5 * (sin(x) * cos(y))
        z4 = sqrt(abs(x * y))

        push!(multi_dim_df, (
            x=x,
            y=y,
            sine_wave=z1,
            cosine_wave=z2,
            combined=z3,
            product=z4,
            group="Surface"
        ))
    end
end

chart2 = Chart3d(:multi_dimensions, multi_dim_df, :multi_dim_data,
    [:sine_wave, :cosine_wave, :combined, :product, :x, :y];
    group_cols = :group,
    title = "Multiple Dimensions - Choose Your Axes",
    notes = "Use the dropdowns above to select which variables to display on each axis"
)

# Example 3: Multiple Groups with Grouping Dropdown
example3_text = TextBlock("""
<h2>Example 3: Multiple Surfaces with Grouping</h2>
<p>Compare different mathematical functions by grouping. You can switch between different grouping variables or choose no grouping.</p>
""")

multi_surface_df = DataFrame()

for x in -5:0.3:5
    for y in -5:0.3:5
        # Surface 1: Sine wave
        z1 = sin(sqrt(x^2 + y^2))
        push!(multi_surface_df, (x=x, y=y, z=z1, function_type="Sine", category="Type A"))

        # Surface 2: Cosine wave (shifted)
        z2 = cos(sqrt(x^2 + y^2)) - 1.5
        push!(multi_surface_df, (x=x, y=y, z=z2, function_type="Cosine", category="Type B"))

        # Surface 3: Combination
        z3 = 0.5 * (sin(x) * cos(y)) + 1.5
        push!(multi_surface_df, (x=x, y=y, z=z3, function_type="Combined", category="Type A"))
    end
end

chart3 = Chart3d(:multi_surfaces, multi_surface_df, :multi_data, [:x, :y, :z];
    group_cols = [:function_type, :category],
    title = "Multiple 3D Surfaces Comparison",
    x_label = "X Axis",
    y_label = "Y Axis",
    z_label = "Height",
    notes = "Use the 'Group by' dropdown to switch between different grouping options"
)

# Example 4: 3D Chart with Filtering
example4_text = TextBlock("""
<h2>Example 4: 3D Surface with Filtering</h2>
<p>This example demonstrates filtering capabilities. Use the sliders to filter the data based on different variables.</p>
""")

# Create a dataset with additional filtering dimensions
filtered_df = DataFrame()

for x in -10:0.5:10
    for y in -10:0.5:10
        # Calculate distance from origin
        r = sqrt(x^2 + y^2)

        # Calculate angle
        angle = atan(y, x)

        # Calculate z value
        z = sin(r) / (r + 0.1) * cos(angle)

        # Assign region based on quadrant
        region = if x >= 0 && y >= 0
            "NE"
        elseif x < 0 && y >= 0
            "NW"
        elseif x < 0 && y < 0
            "SW"
        else
            "SE"
        end

        push!(filtered_df, (
            x=x,
            y=y,
            z=z,
            distance=r,
            angle_deg=rad2deg(angle),
            region=region,
            group="Wave"
        ))
    end
end

chart4 = Chart3d(:filtered_surface, filtered_df, :filtered_data, [:x, :y, :z];
    group_cols = :group,
    slider_col = [:distance, :region],
    title = "3D Surface with Filtering",
    x_label = "X Position",
    y_label = "Y Position",
    z_label = "Amplitude",
    notes = "Use the sliders to filter by distance from origin or region (quadrant)"
)

# Example 5: Comprehensive - All Features Combined
example5_text = TextBlock("""
<h2>Example 5: Comprehensive - All Features Combined</h2>
<p>This example combines all features: multiple dimensions, multiple grouping options, and filtering. Try different combinations!</p>
""")

comprehensive_df = DataFrame()

for x in -8:0.4:8
    for y in -8:0.4:8
        # Calculate various z values
        r = sqrt(x^2 + y^2)
        z_ripple = sin(r) / (r + 0.1)
        z_wave = cos(x) * sin(y)
        z_saddle = x^2 - y^2
        z_peak = exp(-(x^2 + y^2) / 20)

        # Categorizations
        region = if x >= 0 && y >= 0
            "NE"
        elseif x < 0 && y >= 0
            "NW"
        elseif x < 0 && y < 0
            "SW"
        else
            "SE"
        end

        pattern = if abs(x) > abs(y)
            "Horizontal"
        else
            "Vertical"
        end

        magnitude_category = if r < 4
            "Inner"
        elseif r < 8
            "Middle"
        else
            "Outer"
        end

        push!(comprehensive_df, (
            x=x,
            y=y,
            ripple=z_ripple,
            wave=z_wave,
            saddle=z_saddle / 10,  # Scale down for better visualization
            peak=z_peak,
            distance=r,
            region=region,
            pattern=pattern,
            magnitude=magnitude_category
        ))
    end
end

chart5 = Chart3d(:comprehensive_3d, comprehensive_df, :comprehensive_data,
    [:ripple, :wave, :saddle, :peak, :x, :y];
    group_cols = [:region, :pattern, :magnitude],
    slider_col = [:distance, :region],
    title = "Comprehensive 3D Example - All Features",
    notes = "Select axes, choose grouping, and filter data - all features demonstrated together"
)

# Example 6: Wave Interference Pattern
example6_text = TextBlock("""
<h2>Example 6: Wave Interference Pattern</h2>
<p>A classic physics demonstration showing interference from two wave sources. Perfect for scientific visualizations.</p>
""")

wave_df = DataFrame()

for x in -10:0.5:10
    for y in -10:0.5:10
        # Two wave sources creating interference
        r1 = sqrt((x-3)^2 + (y-3)^2)
        r2 = sqrt((x+3)^2 + (y+3)^2)

        wave1 = sin(r1) / (r1 + 0.1)
        wave2 = sin(r2) / (r2 + 0.1)

        z = wave1 + wave2

        push!(wave_df, (x=x, y=y, z=z, group="Interference"))
    end
end

chart6 = Chart3d(:wave_interference, wave_df, :wave_data, [:x, :y, :z];
    group_cols = :group,
    title = "Wave Interference Pattern",
    x_label = "X Position",
    y_label = "Y Position",
    z_label = "Amplitude",
    notes = "Interference pattern from two wave sources - great for physics simulations"
)

conclusion = TextBlock("""
<h2>Key Features Summary</h2>
<ul>
    <li><strong>Interactive 3D controls:</strong> Click and drag to rotate, scroll to zoom, shift+drag to pan</li>
    <li><strong>Dimension selection:</strong> Choose which variables to display on x, y, and z axes (dropdowns appear when 2+ dimensions available)</li>
    <li><strong>Multiple grouping options:</strong> Switch between different grouping variables (dropdown appears when 2+ group columns available)</li>
    <li><strong>Data filtering:</strong> Interactive sliders for continuous variables and multi-select for categorical variables</li>
    <li><strong>Multiple surface support:</strong> Compare different datasets on the same plot with distinct color gradients</li>
    <li><strong>Scientific applications:</strong> Perfect for mathematical functions, simulations, and terrain data</li>
    <li><strong>Integration:</strong> Combine with other plot types, images, and text blocks</li>
</ul>
<p><strong>Tip:</strong> Hover over the surface to see exact x, y, z coordinates!</p>
""")

# Create single combined page
page = JSPlotPage(
    Dict{Symbol,DataFrame}(
        :surface_data => surface_df,
        :multi_dim_data => multi_dim_df,
        :multi_data => multi_surface_df,
        :filtered_data => filtered_df,
        :comprehensive_data => comprehensive_df,
        :wave_data => wave_df
    ),
    [header,
     example1_text, chart1,
     example2_text, chart2,
     example3_text, chart3,
     example4_text, chart4,
     example5_text, chart5,
     example6_text, chart6,
     conclusion],
    tab_title = "3D Chart Examples"
)

create_html(page, "generated_html_examples/threedchart_examples.html")

println("\n" * "="^60)
println("3D Chart examples created successfully!")
println("="^60)
println("\nFile created: generated_html_examples/threedchart_examples.html")
println("\nThis page includes:")
println("  • Basic 3D surface plot")
println("  • Multiple dimensions with axis selection dropdowns")
println("  • Multiple surfaces with grouping dropdown")
println("  • Filtering with sliders (continuous and categorical)")
println("  • Comprehensive example combining all features")
println("  • Wave interference pattern")
println("  • Integration with text blocks")
