SELECT DISTINCT Fact.Sale.Package, Fact.Sale.Quantity, Fact.Sale.[Unit Price], Fact.Sale.[Tax Rate], Fact.Sale.[Total Excluding Tax], Fact.Sale.[Tax Amount], Fact.Sale.Profit, Fact.Sale.[Total Including Tax], 
                         Dimension.[Transaction Type].[Transaction Type], Dimension.Customer.Customer, Dimension.Customer.Category, Dimension.Customer.[Buying Group], Fact.Sale.[Invoice Date Key], Fact.Sale.[Delivery Date Key], 
                         Fact.[Transaction].[Is Finalized], Dimension.[Stock Item].[Lead Time Days], Dimension.[Stock Item].[Stock Item]
FROM            Fact.Sale INNER JOIN
                         Dimension.Customer ON Fact.Sale.[Customer Key] = Dimension.Customer.[Customer Key] INNER JOIN
                         Fact.[Transaction] ON Dimension.Customer.[Customer Key] = Fact.[Transaction].[Customer Key] INNER JOIN
                         Dimension.Supplier ON Fact.[Transaction].[Supplier Key] = Dimension.Supplier.[Supplier Key] INNER JOIN
                         Dimension.[Transaction Type] ON Fact.[Transaction].[Transaction Type Key] = Dimension.[Transaction Type].[Transaction Type Key] INNER JOIN
                         Dimension.[Stock Item] ON Fact.Sale.[Stock Item Key] = Dimension.[Stock Item].[Stock Item Key]
WHERE        (Dimension.Customer.Customer <> 'Unknown')
