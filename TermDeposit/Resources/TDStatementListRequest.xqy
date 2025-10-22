xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CMOV";
(:: import schema at "../../GetCreditCardStatement/Schema/CMOV.xsd" ::)
declare namespace ns1="http://www.mozabank.org/TD_STATEMENT_ITEM_LIST";
(:: import schema at "TDStatementItemList.xsd" ::)

declare variable $TDStatementListRequest as element() (:: schema-element(ns1:TDStatementItemListRequest) ::) external;
declare variable $userIdVar as xs:string external;
declare function local:func($TDStatementListRequest as element() (:: schema-element(ns1:TDStatementItemListRequest) ::),$userIdVar) as element() (:: schema-element(ns2:CMOVRequest) ::) {
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
            <ns2:CMOV_I_0001>{fn:data($TDStatementListRequest/ns1:accountId)}</ns2:CMOV_I_0001> 
      <ns2:CMOV_I_0002>{
        let $fromDateStr := fn:normalize-space($TDStatementListRequest/ns1:fromDate)
        let $toDateStr := fn:normalize-space($TDStatementListRequest/ns1:toDate)
        return
          if ($fromDateStr = '' and $toDateStr = '') then '5'
          else '20'
      }</ns2:CMOV_I_0002>
            <ns2:CMOV_I_0003></ns2:CMOV_I_0003>
            {
                if ($TDStatementListRequest/ns1:transactionType)
                then <ns2:CMOV_I_0004>{  if(fn:data($TDStatementListRequest/ns1:transactionType) = 'C') then 'CRE' else if(fn:data($TDStatementListRequest/ns1:transactionType) = 'D') then 'DEB' else 'ALL'}</ns2:CMOV_I_0004>
                else ()
            } 
      <ns2:CMOV_I_0005>{
        let $fromDateStr := fn:normalize-space($TDStatementListRequest/ns1:fromDate)
        let $toDateStr := fn:normalize-space($TDStatementListRequest/ns1:toDate)
        return
         if ($fromDateStr = '' and $toDateStr = '') then
            '00000000'
          else
            let $dateString := fn:data($TDStatementListRequest/ns1:fromDate)
            let $date := xs:date($dateString)
            let $nextDay := $date
            return concat(
              substring(string($nextDay), 1, 4),
              substring(string($nextDay), 6, 2),
              substring(string($nextDay), 9, 2)
            )
      }</ns2:CMOV_I_0005>
            <ns2:CMOV_I_0006>9999999</ns2:CMOV_I_0006> 
      <ns2:CMOV_I_0007>{
        let $fromDateStr := fn:normalize-space($TDStatementListRequest/ns1:fromDate)
        let $toDateStr := fn:normalize-space($TDStatementListRequest/ns1:toDate)
        return
          if ($fromDateStr = '' and $toDateStr = '') then
            let $d := fn:current-date()
            return concat(
              substring(string($d), 1, 4),
              substring(string($d), 6, 2),
              substring(string($d), 9, 2)
            )
          else
            let $dateString := fn:data($TDStatementListRequest/ns1:toDate)
            return concat(
              substring($dateString, 1, 4),
              substring($dateString, 6, 2),
              substring($dateString, 9, 2)
            )
      }</ns2:CMOV_I_0007>
            <ns2:CMOV_I_9998></ns2:CMOV_I_9998>
            <ns2:CMOV_I_9999></ns2:CMOV_I_9999>
        </ns2:operationData>
    </ns2:CMOVRequest>
};

local:func($TDStatementListRequest,$userIdVar)