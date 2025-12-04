using JSPlots, DataFrames, Dates

println("Creating PivotTable examples...")

# Prepare header
header = TextBlock("""
<h1>PivotTable Examples</h1>
<p>This page demonstrates the key features of interactive PivotTable plots in JSPlots.</p>
<ul>
    <li><strong>Basic pivot:</strong> Simple data aggregation with drag-and-drop</li>
    <li><strong>Custom heatmaps:</strong> Color-coded matrices with custom color scales</li>
    <li><strong>Different renderers:</strong> Table, Bar Chart, Line Chart, and more</li>
    <li><strong>Data filtering:</strong> Inclusions and exclusions to focus on specific data</li>
    <li><strong>Aggregations:</strong> Sum, Average, Count, and other aggregation functions</li>
</ul>
<p><em>Tip: Drag and drop fields between Rows, Columns, and Values to reorganize!</em></p>
""")

# Example 1: Basic Sales Data Pivot Table
sales_df = DataFrame(
    Region = repeat(["North", "South", "East", "West"], inner=12),
    Month = repeat(["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"], outer=4),
    Product = rand(["Widget", "Gadget", "Gizmo"], 48),
    Sales = rand(10000:50000, 48),
    Units = rand(50:200, 48)
)

pivot1 = PivotTable(:sales_pivot, :sales_data;
    rows = [:Region],
    cols = [:Month],
    vals = :Sales,
    aggregatorName = :Sum,
    rendererName = :Table,
    notes = "Basic pivot table - drag fields to reorganize rows and columns"
)

# Example 2: Heatmap with Custom Colors
performance_df = DataFrame(
    Employee = repeat(["Alice", "Bob", "Charlie", "Diana", "Eve"], inner=4),
    Quarter = repeat(["Q1", "Q2", "Q3", "Q4"], outer=5),
    Score = randn(20) .* 10 .+ 75,  # Scores around 75 with some variation
    Department = repeat(["Sales", "Engineering", "Sales", "Marketing", "Engineering"], inner=4)
)

pivot2 = PivotTable(:performance_heatmap, :performance_data;
    rows = [:Employee],
    cols = [:Quarter],
    vals = :Score,
    aggregatorName = :Average,
    rendererName = :Heatmap,
    colour_map = Dict{Float64,String}([50.0, 65.0, 75.0, 85.0, 100.0] .=>
                                      ["#d73027", "#fee08b", "#ffffbf", "#d9ef8b", "#1a9850"]),
    notes = "Custom color scale heatmap - green indicates good performance, red needs improvement"
)

# Example 3: Pivot Table with Bar Chart Renderer
product_data = DataFrame(
    Category = repeat(["Electronics", "Clothing", "Home", "Sports", "Books"], 20),
    Brand = rand(["Brand A", "Brand B", "Brand C", "Brand D"], 100),
    Revenue = rand(1000:10000, 100),
    Quarter = repeat(["Q1", "Q2", "Q3", "Q4"], 25)
)

pivot3 = PivotTable(:revenue_by_category, :product_data;
    rows = [:Category],
    cols = [:Quarter],
    vals = :Revenue,
    aggregatorName = :Sum,
    rendererName = Symbol("Bar Chart"),
    notes = "Bar chart renderer - switch renderer in the dropdown to see other visualizations"
)

# Example 4: Pivot Table with Exclusions
customer_df = DataFrame(
    Country = rand(["USA", "UK", "Germany", "France", "Japan", "Test"], 120),
    ProductType = rand(["Premium", "Standard", "Budget"], 120),
    Channel = rand(["Online", "Retail", "Wholesale"], 120),
    Revenue = rand(500:5000, 120),
    Year = repeat([2022, 2023, 2024], 40)
)

pivot4 = PivotTable(:customer_revenue, :customer_data;
    rows = [:Country],
    cols = [:ProductType],
    vals = :Revenue,
    exclusions = Dict(:Country => [:Test]),  # Exclude test data
    aggregatorName = :Sum,
    rendererName = :Heatmap,
    notes = "Exclusions feature - 'Test' country data is automatically filtered out"
)

# Example 5: Pivot with Inclusions
survey_df = DataFrame(
    Age_Group = rand(["18-25", "26-35", "36-45", "46-55", "56+"], 200),
    Gender = rand(["Male", "Female", "Other", "Prefer not to say"], 200),
    Satisfaction = rand(1:10, 200),
    Product = rand(["Product A", "Product B", "Product C"], 200),
    Region = rand(["North", "South", "East", "West"], 200)
)

pivot5 = PivotTable(:survey_results, :survey_data;
    rows = [:Age_Group, :Gender],
    cols = [:Product],
    vals = :Satisfaction,
    inclusions = Dict(:Age_Group => [Symbol("18-25"), Symbol("26-35"), Symbol("36-45")]),
    aggregatorName = :Average,
    rendererName = Symbol("Table Barchart"),
    notes = "Inclusions feature - only showing ages 18-45, filtering out older demographics"
)

# Example 6: Count Aggregation
transactions_df = DataFrame(
    Transaction_Type = rand(["Purchase", "Refund", "Exchange", "Cancel"], 500),
    Customer_Type = rand(["New", "Returning", "VIP"], 500),
    Payment_Method = rand(["Credit Card", "PayPal", "Bank Transfer", "Cash"], 500),
    Store = rand(["Store 1", "Store 2", "Store 3"], 500),
    Amount = rand(10:500, 500)
)

pivot6 = PivotTable(:transaction_analysis, :transaction_data;
    rows = [:Customer_Type],
    cols = [:Transaction_Type],
    vals = :Amount,
    aggregatorName = :Count,
    rendererName = :Heatmap,
    colour_map = Dict{Float64,String}([0.0, 50.0, 100.0, 150.0] .=>
                                      ["#f7fbff", "#9ecae1", "#4292c6", "#08519c"]),
    notes = "Count aggregation - showing transaction counts rather than sums or averages"
)

# Example 7: Stock Market Returns Analysis
# Generate stock data with ~100 days per stock and ~50 stocks
tickers = ["AAPL", "MSFT", "GOOGL", "AMZN", "META", "TSLA", "NVDA", "JPM", "BAC", "WFC",
           "XOM", "CVX", "PFE", "JNJ", "UNH", "V", "MA", "DIS", "NFLX", "CMCSA",
           "INTC", "CSCO", "ORCL", "IBM", "CRM", "ADBE", "PYPL", "QCOM", "TXN", "AMD",
           "BA", "CAT", "GE", "MMM", "HON", "UPS", "FDX", "WMT", "HD", "MCD",
           "NKE", "SBUX", "KO", "PEP", "PG", "CL", "EL", "CLX", "KMB", "CHD"]

countries = ["USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA",
             "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA",
             "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA",
             "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA",
             "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA"]

gics_codes = ["45202030", "45103010", "50203010", "25504010", "50203010", "45102010", "45301020",
              "40101010", "40101010", "40101010", "10102010", "10102010", "35202010", "35201010",
              "35102010", "20301010", "20301010", "25301020", "50202010", "50202020",
              "45301020", "45201020", "45103020", "45103010", "45103010", "45103010", "20301010",
              "45301020", "45301020", "45301020", "20101010", "20104010", "20105010", "20105020",
              "20106020", "20303010", "20303010", "25502010", "25504020", "25301030",
              "25302010", "25301030", "30201030", "30201030", "30302010", "30302010", "30302010",
              "30302010", "30302010", "30302010"]

industry_names = ["Technology Hardware", "Software", "Interactive Media", "Internet & Direct Marketing",
                  "Interactive Media", "Automobile Manufacturers", "Semiconductors", "Diversified Banks",
                  "Diversified Banks", "Diversified Banks", "Oil & Gas Exploration", "Oil & Gas Exploration",
                  "Pharmaceuticals", "Pharmaceuticals", "Health Care Providers", "Transaction Processing",
                  "Transaction Processing", "Broadcasting", "Movies & Entertainment", "Cable & Satellite",
                  "Semiconductors", "Communications Equipment", "Systems Software", "Software", "Software",
                  "Software", "Transaction Processing", "Semiconductors", "Semiconductors", "Semiconductors",
                  "Aerospace & Defense", "Construction Machinery", "Industrial Conglomerates", "Industrial Conglomerates",
                  "Industrial Machinery", "Air Freight & Logistics", "Air Freight & Logistics", "Hypermarkets",
                  "Home Improvement Retail", "Restaurants", "Footwear", "Restaurants", "Soft Drinks",
                  "Soft Drinks", "Personal Products", "Personal Products", "Personal Products", "Personal Products",
                  "Personal Products", "Personal Products"]

# Generate 100 days of data
start_date = Date(2024, 1, 1)
dates = [start_date + Day(i) for i in 0:99]

# Create stock returns data
stock_data_rows = []
for (i, ticker) in enumerate(tickers)
    for date in dates
        # Generate realistic returns (daily returns typically -3% to +3%)
        daily_return = randn() * 0.015  # ~1.5% daily volatility
        # Volume varies by stock and day
        base_volume = 10_000_000 + i * 500_000
        volume = round(Int, base_volume * (1 + 0.3 * randn()))

        push!(stock_data_rows, (
            Date = date,
            Return = round(daily_return * 100, digits=2),  # Convert to percentage
            Volume = max(1_000_000, volume),  # Ensure minimum volume
            Ticker = ticker,
            Country = countries[i],
            GICS_Code = gics_codes[i],
            Industry = industry_names[i]
        ))
    end
end

stock_returns_df = DataFrame(stock_data_rows)

pivot7 = PivotTable(:stock_returns_analysis, :stock_returns_data;
    rows = [:Industry],
    cols = [:Ticker],
    vals = :Return,
    aggregatorName = :Average,
    rendererName = :Heatmap,
    colour_map = Dict{Float64,String}([-3.0, -1.0, 0.0, 1.0, 3.0] .=>
                                      ["#d73027", "#fee08b", "#ffffbf", "#d9ef8b", "#1a9850"]),
    notes = "Stock returns analysis - drag GICS_Code, Country, or Date to rows/columns to reorganize. Green = positive returns, Red = negative returns"
)

conclusion = TextBlock("""
<h2>Key Features Summary</h2>
<ul>
    <li><strong>Drag-and-drop interface:</strong> Reorganize data dynamically by dragging fields</li>
    <li><strong>Multiple renderers:</strong> Table, Heatmap, Bar Chart, Line Chart, and more</li>
    <li><strong>Custom color scales:</strong> Define your own color gradients for heatmaps</li>
    <li><strong>Aggregation functions:</strong> Sum, Average, Count, Median, Min, Max, etc.</li>
    <li><strong>Data filtering:</strong> Include or exclude specific values</li>
    <li><strong>Multi-level grouping:</strong> Use multiple row or column dimensions</li>
</ul>
<p><strong>Tip:</strong> Try dragging unused fields from the top into Rows or Columns!</p>
""")

# Create single combined page
page = JSPlotPage(
    Dict{Symbol,DataFrame}(
        :sales_data => sales_df,
        :performance_data => performance_df,
        :product_data => product_data,
        :customer_data => customer_df,
        :survey_data => survey_df,
        :transaction_data => transactions_df,
        :stock_returns_data => stock_returns_df
    ),
    [header, pivot1, pivot2, pivot3, pivot4, pivot5, pivot6, pivot7, conclusion],
    tab_title = "PivotTable Examples"
)

create_html(page, "generated_html_examples/pivottable_examples.html")

println("\n" * "="^60)
println("PivotTable examples created successfully!")
println("="^60)
println("\nFile created: generated_html_examples/pivottable_examples.html")
println("\nThis page includes:")
println("  • Basic pivot table with drag-and-drop")
println("  • Custom color scale heatmaps")
println("  • Different renderers (Table, Bar Chart)")
println("  • Data filtering with exclusions and inclusions")
println("  • Count aggregation")
println("  • Stock market returns analysis (50 stocks × 100 days = 5,000 rows)")
