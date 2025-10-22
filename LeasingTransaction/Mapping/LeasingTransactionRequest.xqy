xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cmov";
(:: import schema at "../XSD/CMOV.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/lease_txn_stmt";
(:: import schema at "../XSD/LEASE_ACCOUNT_TXN_STMT.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare variable $userIdVar as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVar as xs:string) as element() (:: schema-element(ns2:CMOVRequest) ::) {
    <ns2:CMOVRequest>
        <ns2:user>{ $userIdVar }</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CMOV</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CMOV_I_0001>{
                let $acct := data($Request/ns1:account)
                return
                    if (contains($acct, "@~")) then
                        substring-after($acct, "@~")
                    else
                        $acct
            }</ns2:CMOV_I_0001>
            <ns2:CMOV_I_0002>99</ns2:CMOV_I_0002>
            <ns2:CMOV_I_0003></ns2:CMOV_I_0003>
            <ns2:CMOV_I_0004>ALL</ns2:CMOV_I_0004>
     <ns2:CMOV_I_0005>{
          let $date := fn:data($Request/ns1:fromDate)
          return concat(substring($date, 1, 4),substring($date, 6, 2),substring($date, 9, 2))
		  
        }</ns2:CMOV_I_0005>
        <ns2:CMOV_I_0006>9999999</ns2:CMOV_I_0006>
   <ns2:CMOV_I_0007>{
          let $date := fn:data($Request/ns1:toDate)
          return concat(substring($date, 1, 4),substring($date, 6, 2),substring($date, 9, 2))
		  
        }</ns2:CMOV_I_0007>
        <ns2:CMOV_I_9998></ns2:CMOV_I_9998>
            <ns2:CMOV_I_9999></ns2:CMOV_I_9999>
        </ns2:operationData>
    </ns2:CMOVRequest>
};

local:func($Request, $userIdVar)