CREATE VIEW ADP_Employee AS
WITH cte AS
(
   SELECT *,
         ROW_NUMBER() OVER (PARTITION BY [Employee ID] ORDER BY [Date Stamp] DESC) AS rn
   FROM [ADP_EmployeeHistorical]
)
SELECT *
FROM cte
WHERE rn = 1
