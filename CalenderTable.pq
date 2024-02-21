(StartDate as date, EndDate as date, FirstFiscalYear as number, StartFiscalMonth as number) =>
    let
        today = DateTime.Date(DateTimeZone.SwitchZone(DateTimeZone.UtcNow(), 9)),
        ThisFY = if Date.Month(today) > 3 then Date.Year(today) else Date.Year(today) - 1,
        FiscalYearNum = FirstFiscalYear,
        FiscalMonthNum = StartFiscalMonth - 1,
        source = List.Dates(StartDate, Duration.Days(EndDate - StartDate) + 1, #duration(1, 0, 0, 0)),
        convert_table = Table.FromList(source, Splitter.SplitByNothing(), {"Date"}, ExtraValues.Error),
        Changed_Type = Table.TransformColumnTypes(convert_table, {{"Date", type date}}),
        add_year_column = Table.AddColumn(Changed_Type, "Year", each Date.Year([Date]), Int64.Type),
        add_month_column = Table.AddColumn(add_year_column, "Month", each Date.Month([Date]), Int64.Type),
        add_day_column = Table.AddColumn(add_month_column, "Day", each Date.Day([Date]), Int64.Type),
        add_FY_column = Table.AddColumn(
            add_day_column, "FY", each if Date.Month([Date]) > 3 then Date.Year([Date]) else Date.Year([Date]) - 1,
            Int64.Type
        ),
        add_FiscalQuarter_num_column = Table.AddColumn(
            add_FY_column,
            "FiscalQuarter",
            each
                if Date.Month([Date]) < StartFiscalMonth then
                    4
                else if Date.Month([Date]) < StartFiscalMonth + 3 then
                    1
                else if Date.Month([Date]) < StartFiscalMonth + 6 then
                    2
                else
                    3,
            Int64.Type
        ),
        add_FiscalQuarter_0Q_column = Table.AddColumn(
            add_FiscalQuarter_num_column,
            "FiscalQuarter_0Q",
            each
                if Date.Month([Date]) < StartFiscalMonth then
                    "4Q"
                else if Date.Month([Date]) < StartFiscalMonth + 3 then
                    "1Q"
                else if Date.Month([Date]) < StartFiscalMonth + 6 then
                    "2Q"
                else
                    "3Q",
            type text
        ),
        add_week_num_column = Table.AddColumn(
            add_FiscalQuarter_0Q_column, "Week", each Date.WeekOfYear([Date], 1), Int64.Type
        ),
        add_DayOfWeek_num_column = Table.AddColumn(
            add_week_num_column, "DayOfWeek", each Date.DayOfWeek([Date], 1), Int64.Type
        ),
        add_NameOfDay_column = Table.AddColumn(
            add_DayOfWeek_num_column, "NameOfDay", each Date.DayOfWeekName([Date], "ja-JP"), type text
        ),
        add_NameOfMonth_column = Table.AddColumn(
            add_NameOfDay_column, "NameOfMonth", each Date.MonthName([Date]), type text
        ),
        add_YearMonth_column = Table.AddColumn(
            add_NameOfMonth_column,
            "YearMonth",
            each Text.Combine({Text.From([Year], "ja"), "/", Text.From([Month], "ja")})
        ),
        add_RelativeDate_column = Table.AddColumn(
            add_YearMonth_column, "RelativeDate", each Duration.Days([Date] - today), Int64.Type
        ),
        add_RelativeMonth_column = Table.AddColumn(
            add_RelativeDate_column,
            "RelativeMonth",
            each 12 * ([Year] - Date.Year(today)) + [Month] - Date.Month(today),
            Int64.Type
        ),
        add_RelativeFiscalYear_column = Table.AddColumn(
            add_RelativeMonth_column, "RelativeFiscalYear", each [FY] - ThisFY, Int64.Type
        ),
        add_RelativeYear_column = Table.AddColumn(
            add_RelativeFiscalYear_column, "RelativeYear", each [Year] - Date.Year(today), Int64.Type
        ),
        add_AccountingPeriod_column = Table.AddColumn(
            add_RelativeYear_column,
            "AccountingPeriod",
            each Date.Year(Date.AddMonths([Date], -FiscalMonthNum)) - FiscalYearNum,
            Int64.Type
        ),
        add_RelativeAccountingPeriod_column = Table.AddColumn(
            add_AccountingPeriod_column,
            "RelativeAccountingPeriod",
            each [AccountingPeriod] - Date.Year(Date.AddYears(today, -FiscalYearNum - 1)),
            Int64.Type
        )
    in
        add_RelativeAccountingPeriod_column
