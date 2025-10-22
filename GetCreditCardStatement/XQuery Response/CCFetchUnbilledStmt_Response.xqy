xquery version "1.0" encoding "utf-8";
 
(:: OracleAnnotationVersion "1.0" ::)
 
declare namespace ns1="http://www.mozabank.org/CMOV";

(:: import schema at "../Schema/CMOV.xsd" ::)

declare namespace ns2="http://www.mozabank.org/emitir_extractos";

(:: import schema at "../Schema/CC_FETCH_UNBILLED_STMT.xsd" ::)
 
declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;

declare variable $CCFetchUnbilledStmt_Request as element() (:: schema-element(ns2:Request) ::) external;

declare variable $idVar as xs:string external;
 
declare function local:func($Response as element() (:: schema-element(ns1:Response) ::),$CCFetchUnbilledStmt_Request as element() (:: schema-element(ns2:Request) ::),$idVar) as element() (:: schema-element(ns2:Response) ::) {
 
let $todayDate := current-date()

let $cutoffDate := $todayDate - xs:dayTimeDuration("P90D")

let $monthToday := if (month-from-date($todayDate) lt 10) then concat('0', month-from-date($todayDate)) else string(month-from-date($todayDate))

let $dayToday := if (day-from-date($todayDate) lt 10) then concat('0', day-from-date($todayDate)) else string(day-from-date($todayDate))
 
let $monthCutoff := if (month-from-date($cutoffDate) lt 10) then concat('0', month-from-date($cutoffDate)) else string(month-from-date($cutoffDate))

let $dayCutoff := if (day-from-date($cutoffDate) lt 10) then concat('0', day-from-date($cutoffDate)) else string(day-from-date($cutoffDate))
 
let $todayFormatted := concat(year-from-date($todayDate),"-", $monthToday,"-", $dayToday,"T00:00:00")

let $cutoffFormatted := concat(year-from-date($cutoffDate),"-", $monthCutoff,"-", $dayCutoff,"T00:00:00")
 
return
<ns2:Response>
<ns2:data>
<ns2:dictionaryArray></ns2:dictionaryArray>
<ns2:referenceNo></ns2:referenceNo>
<ns2:result>
<ns2:dictionaryArray></ns2:dictionaryArray>
<ns2:externalReferenceId></ns2:externalReferenceId>
<ns2:status>{ if(fn:data($Response/ns1:errorCode) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>

                {

            if(fn:data($Response/ns1:errorCode) = 0) then () else(
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

		  let $val1 := xs:decimal(fn:data($Response/ns1:operationData/ns1:CMOV_O_0011[last()]/ns1:CMOV_O_0011_0012)) div 100

		  let $val2 := xs:decimal(fn:data($Response/ns1:operationData/ns1:CMOV_O_0011[last()]/ns1:CMOV_O_0011_0006)) div 100

		  return $val1 - $val2

		}
</ns2:openingBalance>
 
            <ns2:earnedPoints>0</ns2:earnedPoints>
<ns2:redeemedPoints>0</ns2:redeemedPoints>
<ns2:closingBalance>

			{

			  let $raw := fn:data($Response/ns1:operationData/ns1:CMOV_O_0011[1]/ns1:CMOV_O_0011_0012)

			  return

				if (normalize-space($raw) != '') then

				  xs:decimal($raw) div 100

				else

				  ()

			}
</ns2:closingBalance>
<ns2:id>{$idVar}</ns2:id>
<ns2:statementDate>

{

              let $date := fn:data($Response/ns1:operationData/ns1:CMOV_O_0011[1]/ns1:CMOV_O_0011_0015)

              return

                if (xs:int($date) >0) then

                  concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')

                else ()

            }
</ns2:statementDate>

             {

        for $resp in $Response/ns1:operationData/ns1:CMOV_O_0011

        return
<ns2:statmentItems>
<ns2:transactionDate>

                {let $date := fn:data($resp/ns1:CMOV_O_0011_0014)

              return 

              concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}
</ns2:transactionDate>
<ns2:serialNumber>{fn:data($resp/ns1:CMOV_O_0011_0003)}</ns2:serialNumber>
<ns2:transactionDescription>{fn:data($resp/ns1:CMOV_O_0011_0005)}</ns2:transactionDescription>
<ns2:transactionAmount>
<ns2:currency>{fn:data($resp/ns1:CMOV_O_0011_0008)}</ns2:currency>
<ns2:amount>

						{

						  let $rawAmount := fn:data($resp/ns1:CMOV_O_0011_0006)

						  return

							if (normalize-space($rawAmount) != '') then

							  xs:decimal($rawAmount) div 100

							else ()

						}
</ns2:amount>
</ns2:transactionAmount>
<ns2:crdrFlag>

                {

                      let $val := fn:data($resp/ns1:CMOV_O_0011_0010)

                      return

                        if (starts-with($val, '+')) then 'C'

                        else if (starts-with($val, '-')) then 'D'

                        else ()

                    }
</ns2:crdrFlag>
</ns2:statmentItems>

            } 
<ns2:fromDate>{$cutoffFormatted}</ns2:fromDate>
<ns2:toDate>{$todayFormatted}</ns2:toDate>
</ns2:creditCardStatementList>
</ns2:data>
</ns2:Response>

};
 
local:func($Response,$CCFetchUnbilledStmt_Request,$idVar)