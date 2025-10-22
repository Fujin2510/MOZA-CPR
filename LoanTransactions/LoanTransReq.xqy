xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2 = "http://www.mozabanca.org/CMOV/LoanTrans";
(:: import schema at "LoanTransactionMSB.xsd" ::)

declare namespace ns1 = "http://www.mozabanca.org/obdx/LoanTrans";
(:: import schema at "LoanTransOBDX.xsd" ::)
declare variable $UserIdVar as xs:string external;
declare variable $MSBReq as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($MSBReq as element() (:: schema-element(ns1:Request) ::),$UserIdVar as xs:string) 
  as element() (:: schema-element(ns2:Request) ::) {

  let $fromdate := fn:data($MSBReq/ns1:fromDate)
  let $todate := fn:data($MSBReq/ns1:toDate)

  return
    <ns2:Request>
      <ns2:user>{$UserIdVar}</ns2:user>
      <ns2:password></ns2:password>
      <ns2:origin>P</ns2:origin>
      <ns2:channelCode>INT</ns2:channelCode>
      <ns2:version>R30</ns2:version>
      <ns2:licenceKey>licenseKey</ns2:licenceKey>
      <ns2:sessionId>00000000</ns2:sessionId>
      <ns2:transactionCode>CMOV</ns2:transactionCode>
      <ns2:operationData>

        <ns2:CMOV_I_0001>{
          let $acct := data($MSBReq/ns1:accountId)
          return
            if (contains($acct, "@~")) then
              substring-after($acct, "@~")
            else
              $acct
        }</ns2:CMOV_I_0001>

        <ns2:CMOV_I_0002>{
          if ($fromdate = '' and $todate = '') then '5'
          else '20'
        }</ns2:CMOV_I_0002>
        <ns2:CMOV_I_0003>-</ns2:CMOV_I_0003>

        <ns2:CMOV_I_0004>{
          let $value := fn:normalize-space($MSBReq/ns1:transactionType)
          return
            if ($value = 'D') then 'DEB'
            else if ($value = 'C') then 'CRE'
            else 'ALL'
        }</ns2:CMOV_I_0004>

        {
          if ($fromdate gt $todate) then
          
          (
              <ns2:CMOV_I_0005>{
                concat(substring($todate,1,4),
                       substring($todate,6,2),
                       substring($todate,9,2))
              }</ns2:CMOV_I_0005>,
              <ns2:CMOV_I_0006> </ns2:CMOV_I_0006>,
              <ns2:CMOV_I_0007>{
                concat(substring($fromdate,1,4),
                       substring($fromdate,6,2),
                       substring($fromdate,9,2))
              }</ns2:CMOV_I_0007>
            )
           
          else
           (
              <ns2:CMOV_I_0005>{
	       if ($fromdate = '' and $todate = '') then
            '00000000' else
                concat(substring($fromdate,1,4),
                       substring($fromdate,6,2),
                       substring($fromdate,9,2))
              }</ns2:CMOV_I_0005>,
              <ns2:CMOV_I_0006> </ns2:CMOV_I_0006>,
              <ns2:CMOV_I_0007>{
	       if ($fromdate = '' and $todate = '') then
            let $d := fn:current-date()
            return concat(
              substring(string($d), 1, 4),
              substring(string($d), 6, 2),
              substring(string($d), 9, 2) )
	      else(
                concat(substring($todate,1,4),
                       substring($todate,6,2),
                       substring($todate,9,2)))
              }</ns2:CMOV_I_0007>
            )
            
        }

        <ns2:CMOV_I_9998> </ns2:CMOV_I_9998>
        <ns2:CMOV_I_9999> </ns2:CMOV_I_9999>

      </ns2:operationData>
    </ns2:Request>
};

local:func($MSBReq, $UserIdVar)