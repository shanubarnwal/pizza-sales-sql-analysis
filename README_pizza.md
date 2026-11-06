# Pizza Sales Analysis using SQL

**Tools:** SQL (MySQL)

## Business Problem
A pizza restaurant wants to understand what sells, when customers order, and which products bring in the most revenue, so it can plan menu, staffing and promotions.

## Dataset
- 4 related tables: `orders`, `order_details`, `pizzas`, `pizza_types`
- 21,350 orders and 48,620 order lines, covering 1 Jan 2015 to 31 Dec 2015 (358 trading days)
- 32 pizza types in 4 categories (Classic, Supreme, Veggie, Chicken), sold in up to 5 sizes

## Approach
Wrote 13 SQL queries (basic, intermediate and advanced) using joins across all four tables, aggregation, subqueries, CTE-style derived tables and window functions (`SUM() OVER`, `RANK() OVER`). See `pizza_sales_analysis.sql`.

## Key Results
| Question | Result |
|---|---|
| Total orders | 21,350 |
| Total revenue | 817,860.05 |
| Highest-priced pizza | The Greek Pizza (XXL) at 35.95 |
| Most ordered size | Large (L): 18,956 pizzas, about 38% of all pizzas |
| Average pizzas per day | about 138 |

**Top 5 pizzas by quantity:** Classic Deluxe (2,453), Barbecue Chicken (2,432), Hawaiian (2,422), Pepperoni (2,418), Thai Chicken (2,371).

**Top 3 pizzas by revenue:** Thai Chicken (43,434), Barbecue Chicken (42,768), California Chicken (41,410).

**Quantity by category:** Classic 14,888, Supreme 11,987, Veggie 11,649, Chicken 11,050.

**Revenue share by category:** Classic 26.9%, Supreme 25.5%, Chicken 24.0%, Veggie 23.7%.

## Insights
1. **Two clear rush periods.** Orders peak at 12 to 1 pm (about 23% of orders) and 5 to 7 pm (about 22%). Together these two windows bring in nearly half of all orders.
2. **Chicken pizzas earn more than they sell.** Chicken is the lowest category by quantity but sits third by revenue share, and the top 3 pizzas by revenue are all chicken pizzas. Their higher price per pizza is the reason.
3. **Sales are spread evenly across the menu.** The top 5 pizzas by quantity are within about 3% of each other, so no single pizza carries the business.
4. **Large size dominates.** XL and XXL together are only about 1% of pizzas ordered.

## Recommendations
1. Schedule more kitchen and delivery staff for 12 to 1 pm and 5 to 7 pm, and run off-peak offers around 2 to 4 pm when orders dip.
2. Promote chicken pizzas more, since each sale brings in more revenue.
3. Review the XL and XXL sizes. Very low demand may not justify the ingredient and stock cost.

## Files
- `pizza_sales_analysis.sql`: all 13 queries with comments
- Data files: `orders.csv`, `order_details.csv`, `pizzas.csv`, `pizza_types.csv`

## Limitations
Data covers one year only, so seasonal trends across years can't be checked. Revenue is calculated from list prices, with no discounts or costs, so it shows sales and not profit.
