xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cmov";
(:: import schema at "../MSB_Schema/CMOV.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCC_ACCOUNT_TXN_STMT";
(:: import schema at "../OBDX_Schema/CCC_ACCOUNT_TXN_STMT.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVar as xs:string) 
  as element() (:: schema-element(ns2:CMOVRequest) ::) {

  <ns2:CMOVRequest>
    <ns2:user>{fn:data($userIdVar)}</ns2:user>
    <ns2:password></ns2:password>
    <ns2:origin>P</ns2:origin>
    <ns2:channelCode>INT</ns2:channelCode>
    <ns2:version>R30</ns2:version>
    <ns2:licenceKey>licenseKey</ns2:licenceKey>
    <ns2:sessionId>00000000</ns2:sessionId>
    <ns2:transactionCode>CMOV</ns2:transactionCode>
    <ns2:operationData>

      <ns2:CMOV_I_0001>{fn:data($Request/ns1:account)}</ns2:CMOV_I_0001>
      <ns2:CMOV_I_0002>99</ns2:CMOV_I_0002>
      <ns2:CMOV_I_0003></ns2:CMOV_I_0003>
      <ns2:CMOV_I_0004>ALL</ns2:CMOV_I_0004>

      <ns2:CMOV_I_0005>
      {
        let $fromDate := $Request/ns1:fromDate/ns1:dateString
        let $currDate := current-date()
        let $currYear := year-from-date($currDate)
        let $currMonth := month-from-date($currDate)
        let $currDay := day-from-date($currDate)

        (: calculate 3 months back manually :)
        let $newMonth :=
          if ($currMonth > 3)
          then $currMonth - 3
          else 12 + ($currMonth - 3) 

        let $newYear :=
          if ($currMonth > 3)
          then $currYear
          else $currYear - 1

        let $formattedPrevDate :=
          concat(string($newYear),
                 if ($newMonth lt 10) then concat('0', $newMonth) else string($newMonth),
                 if ($currDay lt 10) then concat('0', $currDay) else string($currDay))

        return
          if (empty($fromDate) or normalize-space($fromDate) = '')
          then $formattedPrevDate
          else substring(fn:data($fromDate), 1, 8)
      }
      </ns2:CMOV_I_0005>

      <ns2:CMOV_I_0006>9999999</ns2:CMOV_I_0006>

      <ns2:CMOV_I_0007>
      {
        let $toDate := $Request/ns1:toDate/ns1:dateString
        let $currDate := current-date()
        let $currYear := string(fn:year-from-date($currDate))
        let $currMonth := string(fn:month-from-date($currDate))
        let $currDay := string(fn:day-from-date($currDate))
        let $formattedCurrDate := concat($currYear,
                                         if (string-length($currMonth) = 1) then concat('0', $currMonth) else $currMonth,
                                         if (string-length($currDay) = 1) then concat('0', $currDay) else $currDay)
        return
          if (empty($toDate) or normalize-space($toDate) = '')
          then $formattedCurrDate
          else substring(fn:data($toDate), 1, 8)
      }
      </ns2:CMOV_I_0007>

      <ns2:CMOV_I_9998></ns2:CMOV_I_9998>
      <ns2:CMOV_I_9999></ns2:CMOV_I_9999>
    </ns2:operationData>
  </ns2:CMOVRequest>
};

local:func($Request,$userIdVar)