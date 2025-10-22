xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CMOV";
(:: import schema at "../Schema/CMOV.xsd" ::)
declare namespace ns2="http://www.mozabank.org/cmov_msb";
(:: import schema at "../Schema/CC_FETCH_BILLED_STMT.xsd" ::)

declare variable $CCFetchBilledStmt_Request as element() (:: schema-element(ns2:Request) ::) external;
declare variable $Billed_CMOV_Response as element() (:: schema-element(ns1:CMOVResponse) ::) external;
declare variable $idVar as xs:string external;

declare function local:format-date($date as xs:date) as xs:string {
  let $year := string(year-from-date($date))
  let $month := if (month-from-date($date) lt 10) then concat("0", month-from-date($date)) else string(month-from-date($date))
  let $day := if (day-from-date($date) lt 10) then concat("0", day-from-date($date)) else string(day-from-date($date))
  return concat($year, "-", $month, "-", $day, "T00:00:00")
};


declare function local:func($Billed_CMOV_Response as element() (:: schema-element(ns1:CMOVResponse) ::),$CCFetchBilledStmt_Request as element() (:: schema-element(ns2:Request) ::),$idVar) as element() (:: schema-element(ns2:Response) ::) {
    
let $year := normalize-space(data($CCFetchBilledStmt_Request/ns2:statementYear))
let $month := normalize-space(data($CCFetchBilledStmt_Request/ns2:statementMonth))

let $currentDate := current-date()
let $cutoffDate := $currentDate - xs:dayTimeDuration("P90D")

let $isValid := matches($year, '^\d{4}$') and matches($month, '^\d{1,2}$')

let $monthInt := if ($isValid) then xs:integer($month) else ()
let $monthPadded := if ($isValid and $monthInt lt 10) then concat("0", $month) else string($monthInt)

let $inputDate := if ($isValid) then xs:date(concat($year, "-", $monthPadded, "-01")) else ()

(: Determine last day of the month :)
let $lastDay :=
  if ($monthInt = 2) then
    (if ((xs:integer($year) mod 4 = 0 and xs:integer($year) mod 100 != 0) or (xs:integer($year) mod 400 = 0))
     then "29" else "28")
  else if ($monthInt = 4 or $monthInt = 6 or $monthInt = 9 or $monthInt = 11) then "30"
  else "31"

let $endOfMonthDate := if ($isValid) then xs:date(concat($year, "-", $monthPadded, "-", $lastDay)) else ()

(: Conditions :)
let $isCurrentMonth :=
  $isValid and year-from-date($inputDate) = year-from-date($currentDate) and month-from-date($inputDate) = month-from-date($currentDate)

let $isCutoffMonth :=
  $isValid and year-from-date($inputDate) = year-from-date($cutoffDate) and month-from-date($inputDate) = month-from-date($cutoffDate)

let $isWithinRange :=
  $isValid and $endOfMonthDate >= $cutoffDate

(: Final date values :)
let $startDate :=
  if (not($isValid)) then ()
  else if (not($isWithinRange)) then ()
  else if ($isCurrentMonth) then concat($year, "-", $monthPadded, "-01T00:00:00")
  else if ($isCutoffMonth) then local:format-date($cutoffDate)
  else concat($year, "-", $monthPadded, "-01T00:00:00")

let $endDate :=
  if (not($isValid)) then ()
  else if (not($isWithinRange)) then ()
  else if ($isCurrentMonth) then local:format-date($currentDate)
  else concat($year, "-", $monthPadded, "-", $lastDay, "T00:00:00")


return
    <ns2:Response>
<ns2:data>
<ns2:dictionaryArray></ns2:dictionaryArray>
<ns2:referenceNo></ns2:referenceNo>
<ns2:result>
<ns2:dictionaryArray></ns2:dictionaryArray>
<ns2:externalReferenceId></ns2:externalReferenceId>
<ns2:status>{if(fn:data($Billed_CMOV_Response/ns1:errorCode) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>
            {
            if(fn:data($Billed_CMOV_Response/ns1:errorCode) = 0) then () else(
<ns2:errorList>
<ns2:code>ERR001</ns2:code>
<ns2:message>Invalid backend response</ns2:message>
</ns2:errorList>) 
            }
<ns2:warningList></ns2:warningList>
</ns2:result>
<ns2:hasMore></ns2:hasMore>
<ns2:totalRecords></ns2:totalRecords>
<ns2:startSequence></ns2:startSequence>
<ns2:creditCardStatementList>
<ns2:openingBalance>
							{
				  let $raw1 := fn:data($Billed_CMOV_Response/ns1:operationData/ns1:CMOV_O_0011[last()]/ns1:CMOV_O_0011_0012)
				  let $raw2 := fn:data($Billed_CMOV_Response/ns1:operationData/ns1:CMOV_O_0011[last()]/ns1:CMOV_O_0011_0006)
				  let $val1 := if (normalize-space($raw1) != '') then xs:decimal($raw1) div 100 else xs:decimal(0.00)
				  let $val2 := if (normalize-space($raw2) != '') then xs:decimal($raw2) div 100 else xs:decimal(0.00)
				  let $diff := $val1 - $val2
				  return $diff
				}
 
			</ns2:openingBalance>
 
            <ns2:earnedPoints>0</ns2:earnedPoints>
<ns2:redeemedPoints>0</ns2:redeemedPoints>
<ns2:closingBalance>
			{
						  let $raw := fn:data($Billed_CMOV_Response/ns1:operationData/ns1:CMOV_O_0011[1]/ns1:CMOV_O_0011_0012)
						  return
							if (normalize-space($raw) != '') then
							  xs:decimal($raw) div 100
							else 
							xs:decimal(0.00)
						}
</ns2:closingBalance>
<ns2:id>{$idVar}</ns2:id>
<ns2:statementDate>{concat(substring(xs:string(current-date()),1,10), 'T00:00:00')}</ns2:statementDate>
            {
            for $cmov in $Billed_CMOV_Response/ns1:operationData/ns1:CMOV_O_0011 
            return
<ns2:statmentItems>
<ns2:transactionDate>
                {let $date := fn:data($cmov/ns1:CMOV_O_0011_0014)
              return 
              concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
</ns2:transactionDate>
<ns2:serialNumber>{fn:data($cmov/ns1:CMOV_O_0011_0003)}</ns2:serialNumber>
<ns2:transactionDescription>{fn:data($cmov/ns1:CMOV_O_0011_0005)}</ns2:transactionDescription>
<ns2:transactionAmount>
<ns2:currency>{fn:data($cmov/ns1:CMOV_O_0011_0008)}</ns2:currency>
<ns2:amount>
						{
						  let $raw := fn:data($cmov/ns1:CMOV_O_0011_0006)
						  return
							if (normalize-space($raw) != '') then
							  xs:decimal($raw) div 100
							else 
							xs:decimal(0.00)
						}
</ns2:amount>
 
                </ns2:transactionAmount>
<ns2:crdrFlag>
                {
                      let $val := fn:data($cmov/ns1:CMOV_O_0011_0010)
                      return
                        if (starts-with($val, '+')) then 'C'
                        else if (starts-with($val, '-')) then 'D'
                        else ()
                    }
</ns2:crdrFlag>
</ns2:statmentItems>
             }
<ns2:fromDate>{
            let $stDate := current-date() - xs:dayTimeDuration("P90D") return
            if((string-length(fn:data($CCFetchBilledStmt_Request/ns2:statementMonth)) > 0) and string-length(fn:data($CCFetchBilledStmt_Request/ns2:statementYear)) > 0) then 
            $startDate
            else concat(substring(xs:string($stDate), 1, 4),"-",  substring(xs:string($stDate), 6, 2),"-",  substring(xs:string($stDate), 9, 2),"T00:00:00")}</ns2:fromDate>
<ns2:toDate>{if((string-length(fn:data($CCFetchBilledStmt_Request/ns2:statementMonth)) > 0) and string-length(fn:data($CCFetchBilledStmt_Request/ns2:statementYear)) > 0)
            then $endDate
            else(concat(substring(xs:string(fn:current-date()), 1, 4),"-",  substring(xs:string(fn:current-date()), 6, 2),"-",  substring(xs:string(fn:current-date()), 9, 2),"T00:00:00"))}</ns2:toDate> 
</ns2:creditCardStatementList> 
</ns2:data>
</ns2:Response>
};

local:func($Billed_CMOV_Response,$CCFetchBilledStmt_Request,$idVar)