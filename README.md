# HR Attrition Analysis: MySQL + Power BI

Analysed attrition for 1,470 employees to find who leaves, where, and what goes with leaving, then built a one-page Power BI dashboard so HR can target retention. **237 employees left (16.1%).** Overtime, junior status and low pay stand out most.

![Dashboard](screenshots/dashboard.png)

## Business problem

HR could see how many people left but not **who**, **where**, **why** or **what it costs**. This project answers:

1. What is the overall attrition rate?
2. Which departments and job roles lose the most people?
3. Do overtime, income, age, tenure or promotion delay affect attrition?
4. Do job satisfaction and work-life balance matter?
5. How many people leave early, and what salary do leavers represent?
6. Which employee profile is at highest risk?
7. What should HR do about it?

## Dataset

- **Source:** IBM HR Analytics Employee Attrition (Kaggle, `pavansubhasht`)
- **Size:** 1,470 rows, 35 columns, no missing values, no duplicates
- **Note:** a fictional dataset created by IBM data scientists for learning
- **Removed:** `EmployeeCount`, `Over18`, `StandardHours` (one value each)

## Tools

| Tool | Used for |
|---|---|
| MySQL | Loading data, quality checks, SQL analysis |
| Power Query | Cleaning, bands, labels and 0/1 flag columns |
| Power BI | One-page dashboard (built-in aggregations, no DAX) |

## Method

1. **Setup:** created `hr_project` and `hr_attrition_raw`, loaded the CSV (1,470 rows confirmed).
2. **Quality checks:** row count, duplicates, nulls, constant columns, valid Yes/No target. The data was already clean, so nothing was deleted or imputed.
3. **Modelling:** one flat table, no relationships. Added `attrition_flag` (1 = left), band columns, readable labels and flags (`early_leaver`, `high_performer`, `low_satisfaction`, `stagnant_5yrs`, `leaver_annual_salary`, `high_risk_profile`). The average of a 0/1 flag gives a rate, so no DAX was needed.
4. **EDA in SQL:** one pattern (`COUNT`, `SUM(attrition_flag)`, rate, `GROUP BY`) run across 12 columns, plus leavers-vs-stayers and an overtime-by-satisfaction cross-check. Every table adds back to 1,470 employees and 237 leavers.
5. **Dashboard:** 8 KPIs in a dark teal design, three slicers (Department, Marital Status, Age Group).

## Results

### Headline numbers

| Measure | Leavers | Stayers |
|---|---|---|
| Employees | 237 | 1,233 |
| Average monthly income | 4,787 | 6,833 |
| Average tenure (years) | 5.1 | 7.4 |
| Average age | 33.6 | 37.6 |

Annual salary of leavers: about **$14M** (237 leavers x monthly income x 12).

### Attrition rate by segment

| Segment | Highest | Lowest |
|---|---|---|
| Overtime | Yes: 30.5% | No: 10.4% |
| Job role | Sales Representative: 39.8% | Research Director: 2.5% |
| Department | Sales: 20.6% | R&D: 13.8% |
| Tenure | 0-2 yrs: 29.8% | 10+ yrs: 8.1% |
| Age | Under 30: 27.9% | 40-49: 9.7% |
| Income (monthly) | Below 3K: 28.6% | 10K+: 8.9% |
| Marital status | Single: 25.5% | Divorced: 10.1% |
| Business travel | Frequently: 24.9% | Non-travel: 8.0% |
| Job satisfaction | Low: 22.8% | Very High: 11.3% |
| Work-life balance | Bad: 31.3% (80 employees) | Better: 14.2% |
| Gender | Male: 17.0% | Female: 14.8% |

## Key findings

1. **Overtime is the largest single gap.** Overtime workers leave about 2.9 times as often (30.5% vs 10.4%). They are 28.3% of employees but 53.6% of all leavers (127 of 237).
2. **Sales Representatives are the highest-risk role:** 39.8% (33 of 83), about 2.5 times the company rate. Laboratory Technician (23.9%) and Human Resources roles (23.1%) are also above 16.1%. Senior roles (Managers, Directors) have the lowest attrition.
3. **The first two years matter most.** 102 leavers had 2 years or less at the company, which is 43.0% of all leavers.
4. **Young and low-paid employees leave more.** Under 30 is 27.9% (38.4% of leavers), and below 3K a month is 28.6% (47.7% of leavers). Leavers earned about 30% less than stayers.
5. **Single employees** are half of all leavers (120 of 237, 25.5% rate), and **frequent travellers** leave at about 3.1 times the rate of non-travellers.
6. **Overtime outweighs satisfaction.** Overtime workers with Very High satisfaction (21.1%) still leave more often than non-overtime workers with Low satisfaction (17.6%).
7. **High-risk profile:** employees who work overtime, are single and are under 30 left at **67.5% (27 of 40)**, about 4.2 times the company rate.

### What the data does not support

- **Promotion delay is not a driver.** Employees 5+ years since their last promotion left at 14.2% (37 of 260), below the 16.1% company rate.
- **Satisfaction and work-life balance are not straight lines.** Medium (16.4%) and High (16.5%) satisfaction are almost the same, and Best work-life balance (17.6%) is above Better (14.2%).
- **Gender** shows only a small gap (2.2 percentage points).
- **Overlap:** being under 30, low-paid and new to the company probably describe the same junior employees. This analysis does not separate them.

## Dashboard KPIs

| # | KPI | Visual | Result |
|---|---|---|---|
| 1 | Attrition rate | Card | 16.1% |
| 2 | Annual salary lost | Card | about $14M |
| 3 | Overtime gap by department | Clustered column | 30.5% vs 10.4% overall |
| 4 | Attrition by job role | Treemap | Sales Representative highest |
| 5 | Early attrition (0-2 years) | Donut | 43.0% of leavers |
| 6 | Attrition by tenure | Area chart | 29.8% falling to 8.1% |
| 7 | Satisfaction vs attrition | 100% stacked bar | Low 22.8%, Very High 11.3% |
| 8 | High-risk profile | Card | 67.5% (27 of 40) |

## Recommendations

1. **Workload:** review overtime policy and staffing in the roles with the most overtime.
2. **Early-career retention:** strengthen onboarding and check-ins in the first two years.
3. **Sales Representatives:** investigate pay, targets and role clarity.
4. **Pay review:** examine the lowest income bands against the market.
5. **Early-warning list:** use the high-risk profile (overtime, single, under 30) to prioritise check-ins.
6. **Career development:** offer career-path conversations to junior employees. Promotion gaps did not show a link in this data.
7. **Travel:** review the load on frequent travellers.

## Limitations

- A fictional snapshot with no dates, so trends over time cannot be measured.
- Associations, not proven causes. No statistical tests were done, by design.
- Some groups are small (HR department 63, Bad work-life balance 80, high-risk profile 40), so their rates can swing widely.
- "Salary lost" counts the salary of leavers only, not hiring or replacement costs.

## Repository structure

```
hr-attrition-project/
  data/         WA_Fn-UseC_-HR-Employee-Attrition.csv
  sql/          01_create_table.sql, 02_cleaning.sql, 03_analysis.sql
  powerbi/      hr_attrition.pbix, hr_attrition_theme.json
  screenshots/  dashboard.png
  README.md
```

## How to reproduce

1. Run the SQL files in order in MySQL.
2. Open the `.pbix` in Power BI Desktop and update the MySQL server connection.
3. Optional: import `hr_attrition_theme.json` via View, Themes, Browse for themes.

## Author

[Your name] | [LinkedIn] | [Email]
