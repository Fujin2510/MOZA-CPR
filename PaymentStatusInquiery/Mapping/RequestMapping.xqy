xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cmov";
(:: import schema at "../XSD/CMOV.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/cz_outward_remittance_list";
(:: import schema at "../XSD/CZ_OUTWARD_REMITTANCE_LIST.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:CMOVRequest) ::) {
    <ns2:CMOVRequest>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CMOV</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CMOV_I_0001>{
          let $acct := fn:data($Request/ns1:accountList)
         return
          if (contains($acct, "@~")) then
           substring-after($acct, "@~")
          else
           $acct
         }</ns2:CMOV_I_0001>
            <ns2:CMOV_I_0002>20</ns2:CMOV_I_0002>
            <ns2:CMOV_I_0003></ns2:CMOV_I_0003>
              <ns2:CMOV_I_0004>{
  let $pt := fn:string($Request/ns1:paymentType)
  return
     if ($pt = 'PTFI') then 'TFI'
    else if ($pt = 'PTFZ') then 'TFO'
    else if ($pt = 'ALL') then 'ALL'
    else $pt
}</ns2:CMOV_I_0004>
            <ns2:CMOV_I_0005>{
                let $toDate := fn:normalize-space($Request/ns1:fromDate/ns1:dateString)
                return
                  if ($toDate != '') then
                    substring($toDate, 1, 8)  (: Take only yyyyMMdd :)
                 else
      let $sevenDaysAgo := fn:current-date() - xs:dayTimeDuration("P7D")
      let $currDate := fn:string($sevenDaysAgo)
      return concat(
        substring($currDate, 1, 4),  (: Year :)
        substring($currDate, 6, 2),  (: Month :)
        substring($currDate, 9, 2)   (: Day :)
      )
}</ns2:CMOV_I_0005>
            <ns2:CMOV_I_0006>9999999</ns2:CMOV_I_0006>
            <ns2:CMOV_I_0007>{
  let $fromDate := fn:normalize-space($Request/ns1:toDate/ns1:dateString)
  return
    if ($fromDate != '') then
      substring($fromDate, 1, 8)  (: Take only the yyyyMMdd part :)

   else
                    let $currDate := fn:string(fn:current-date())
                    return concat(
                      substring($currDate, 1, 4),  (: Year :)
                      substring($currDate, 6, 2),  (: Month :)
                      substring($currDate, 9, 2)   (: Day :)
                    )
              }
</ns2:CMOV_I_0007>
            <ns2:CMOV_I_9998></ns2:CMOV_I_9998>
            <ns2:CMOV_I_9999></ns2:CMOV_I_9999>
        </ns2:operationData>
    </ns2:CMOVRequest>
};

local:func($Request)