xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/obdx/CTFO";
(:: import schema at "../XSD/CTFO.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/instruction_read";
(:: import schema at "../XSD/INSTRUCTION_READ.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;
declare variable $accountID as xs:string external;
declare variable $endDate as xs:string external;
declare variable $startDate as xs:string external;
declare variable $status as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVar as xs:string,  $accountID as xs:string,$startDate,$endDate,$status) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password>{''}</ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CTFO</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CTFO_I_0001>{
            
if (contains($accountID, "@~")) then
        substring-after($accountID, "@~")
      else
        $accountID
            }</ns2:CTFO_I_0001>
         <ns2:CTFO_I_0002>5</ns2:CTFO_I_0002>
    <ns2:CTFO_I_0004>{  
                     let $startDate := normalize-space($startDate)
                  return
                    if ($startDate != "") then
                      $startDate
                    else
                 let $currDate := fn:string(fn:current-date())
              return concat(
                substring($currDate, 1, 4),  (: Year :)
                substring($currDate, 6, 2),  (: Month :)
                substring($currDate, 9, 2)   (: Day :)
              )
        }</ns2:CTFO_I_0004>
<ns2:CTFO_I_0007>{  
                     let $startDate := normalize-space($startDate)
                  return
                    if ($startDate != "") then
                      $startDate
                    else
                 let $currDate := fn:string(fn:current-date())
              return concat(
                substring($currDate, 1, 4),  (: Year :)
                substring($currDate, 6, 2),  (: Month :)
                substring($currDate, 9, 2)   (: Day :)
              )
        }</ns2:CTFO_I_0007>
<ns2:CTFO_I_0008>{
                   let $endDate := normalize-space($endDate)
                return
                  if ($endDate != "") then
                    $endDate
                  else
                    let $sevenDaysAgo := fn:current-date() + xs:yearMonthDuration("P6M")
              let $currDate := fn:string($sevenDaysAgo)
              return concat(
                substring($currDate, 1, 4),  (: Year :)
                substring($currDate, 6, 2),  (: Month :)
                substring($currDate, 9, 2)   (: Day :)
              )              
        }</ns2:CTFO_I_0008>
        <ns2:CTFO_I_0005>P</ns2:CTFO_I_0005>
       <ns2:CTFO_I_0006>{' '}</ns2:CTFO_I_0006>
        </ns2:operationData>
        </ns2:Request>

};

local:func($Request,$userIdVar,$accountID,$startDate,$endDate,$status)