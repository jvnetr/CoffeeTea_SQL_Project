import sqlite3

import pytest


def build_db():
    conn = sqlite3.connect(':memory:')
    cur = conn.cursor()
    cur.execute('CREATE TABLE BudgetandPerformance (Date TEXT, "Area Code" TEXT, "Product ID" INTEGER, Profit REAL, "Budget Profit" REAL);')
    sample_data = [
        ('2022-01-15', '10001', 1, 100, 80),
        ('2022-02-15', '10001', 1, 150, 120),
        ('2023-01-10', '10001', 1, 200, 180),
        ('2023-02-20', '10001', 1, 250, 220),
    ]
    cur.executemany('INSERT INTO BudgetandPerformance VALUES (?, ?, ?, ?, ?)', sample_data)
    conn.commit()
    return conn


def test_profitability_trends_yearly_totals():
    conn = build_db()
    cur = conn.cursor()

    # Query adapted from the SQL script
    query = """
    SELECT
        strftime('%Y', Date) as Year,
        SUM(Profit) as [Total Profit],
        SUM("Budget Profit") as [Total Budget Profit],
        SUM(Profit) - SUM("Budget Profit") as [Profit Variance],
        ((SUM(Profit) - SUM("Budget Profit")) / SUM("Budget Profit")) * 100 as [Profit Variance %]
    FROM
        BudgetandPerformance bp
    GROUP BY
        strftime('%Y', Date),
        strftime('%m', Date)
    ORDER BY
        Year;
    """
    cur.execute(query)
    results = cur.fetchall()

    yearly = {}
    for year, tot_profit, tot_budget, var, pct in results:
        data = yearly.setdefault(year, {'profit': 0, 'budget': 0, 'variance': 0})
        data['profit'] += tot_profit
        data['budget'] += tot_budget
        data['variance'] += var

    # Expected yearly totals directly from the database
    expected_rows = cur.execute(
        """
        SELECT
            strftime('%Y', Date) as Year,
            SUM(Profit) as profit,
            SUM("Budget Profit") as budget,
            SUM(Profit) - SUM("Budget Profit") as variance
        FROM BudgetandPerformance
        GROUP BY strftime('%Y', Date)
        ORDER BY Year;
        """
    ).fetchall()

    expected = {row[0]: {'profit': row[1], 'budget': row[2], 'variance': row[3]} for row in expected_rows}

    assert yearly == expected
