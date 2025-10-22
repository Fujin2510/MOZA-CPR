xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CMOV";
(:: import schema at "../Schema/CMOV.xsd" ::)
declare namespace ns1="http://www.mozabank.org/cmov_msb";
(:: import schema at "../Schema/CC_FETCH_BILLED_STMT.xsd" ::)

declare variable $CCFetchBilledStmt_Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;
declare variable $CCFetchUnbilledStmt_Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $accountIdVar as xs:string external;

declare function local:getStartEndDates($year as xs:string?, $month as xs:string?) 
as element()* {
  let $currentDate := current-date()
  let $cutoffDate := $currentDate - xs:dayTimeDuration("P90D")

  return
    if (string-length(normalize-space($year)) = 0 or string-length(normalize-space($month)) = 0) then
      let $start := local:formatDate($cutoffDate)
      let $end := local:formatDate($currentDate)
      return (<startDate>{$start}</startDate>, <endDate>{$end}</endDate>)

    else if (matches($month, '^\d{1,2}$') and matches($year, '^\d{4}$')) then
      let $monthInt := xs:integer($month)
      let $monthPadded := if ($monthInt lt 10) then concat("0", $month) else string($monthInt)
      let $inputDate := xs:date(concat($year, "-", $monthPadded, "-01"))
      let $isValid := $inputDate >= xs:date(concat(string(year-from-date($cutoffDate)), "-", 
                                  if (month-from-date($cutoffDate) lt 10) then concat("0", month-from-date($cutoffDate)) else string(month-from-date($cutoffDate)), "-01"))

      let $lastDay :=
        if ($monthInt = 2) then
          (if ((xs:integer($year) mod 4 = 0 and xs:integer($year) mod 100 != 0) or (xs:integer($year) mod 400 = 0)) 
           then "29" else "28")
        else if ($monthInt = 4 or $monthInt = 6 or $monthInt = 9 or $monthInt = 11) then "30"
        else "31"

      let $lastDayOfMonth := xs:date(concat($year, "-", $monthPadded, "-", $lastDay))
      let $isCurrentMonth := year-from-date($inputDate) = year-from-date($currentDate) and month-from-date($inputDate) = month-from-date($currentDate)
      let $isCutoffMonth := year-from-date($inputDate) = year-from-date($cutoffDate) and month-from-date($inputDate) = month-from-date($cutoffDate)

      return
        if (not($isValid)) then
          (<startDate/>, <endDate/>)
        else if ($isCurrentMonth) then
          (<startDate>{concat($year, $monthPadded, "01")}</startDate>,
           <endDate>{local:formatDate($currentDate)}</endDate>)
        else if ($isCutoffMonth) then
          (<startDate>{local:formatDate($cutoffDate)}</startDate>,
           <endDate>{concat($year, $monthPadded, $lastDay)}</endDate>)
        else
          (<startDate>{concat($year, $monthPadded, "01")}</startDate>,
           <endDate>{concat($year, $monthPadded, $lastDay)}</endDate>)
    else
      (<startDate/>, <endDate/>)
};

declare function local:formatDate($d as xs:date) as xs:string {
  let $y := string(year-from-date($d))
  let $m := if (month-from-date($d) lt 10) then concat("0", month-from-date($d)) else string(month-from-date($d))
  let $dy := if (day-from-date($d) lt 10) then concat("0", day-from-date($d)) else string(day-from-date($d))
  return concat($y, $m, $dy)
};


declare function local:func($CCFetchBilledStmt_Request as element() (:: schema-element(ns1:Request) ::),$CCFetchUnbilledStmt_Request as element() (:: schema-element(ns1:Request) ::),$userIdVar,$accountIdVar) 
as element() (:: schema-element(ns2:CMOVRequest) ::) {


let $year := data($CCFetchBilledStmt_Request/ns1:statementYear)
let $originalMonth := data($CCFetchBilledStmt_Request/ns1:statementMonth)
let $monthInt := xs:integer($originalMonth)
let $nextMonthInt := if ($monthInt lt 12) then $monthInt + 1 else 1
let $month := string($nextMonthInt)
let $dates := local:getStartEndDates($year, $month)

return
<ns2:CMOVRequest>
    <ns2:user>{$userIdVar}</ns2:user>
    <ns2:password></ns2:password>
    <ns2:origin>P</ns2:origin>
    <ns2:channelCode>INT</ns2:channelCode>
    <ns2:version>R30</ns2:version>
    <ns2:licenceKey>licenseKey</ns2:licenceKey>
    <ns2:sessionId>00000000</ns2:sessionId>
    <ns2:transactionCode>CMOV</ns2:transactionCode>
    <ns2:operationData>
        <ns2:CMOV_I_0001>{$accountIdVar}</ns2:CMOV_I_0001>
        <ns2:CMOV_I_0002>20</ns2:CMOV_I_0002>
        <ns2:CMOV_I_0003>-</ns2:CMOV_I_0003>
        <ns2:CMOV_I_0004>ALL</ns2:CMOV_I_0004>
        <ns2:CMOV_I_0005>{($dates[2]/text())}</ns2:CMOV_I_0005>
        <ns2:CMOV_I_0006></ns2:CMOV_I_0006>
        <ns2:CMOV_I_0007>{($dates[1]/text())}</ns2:CMOV_I_0007>
        <ns2:CMOV_I_9998></ns2:CMOV_I_9998>
        <ns2:CMOV_I_9999></ns2:CMOV_I_9999>
    </ns2:operationData>
</ns2:CMOVRequest>
};

local:func($CCFetchBilledStmt_Request,$CCFetchUnbilledStmt_Request,$userIdVar,$accountIdVar)