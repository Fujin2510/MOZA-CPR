xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CASAStatementItemList";
(:: import schema at "CASAStatementItemList.xsd" ::)
declare namespace ns2="http://www.mozabank.org/CMOV";
(:: import schema at "CMOV.xsd" ::)

declare variable $CASAStatementItemList as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($CASAStatementItemList as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user></ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin></ns2:origin>
        <ns2:channelCode>E</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenceKey</ns2:licenceKey>
        <ns2:sessionId>bf9fe3e6</ns2:sessionId>
        <ns2:transactionCode>CMOV</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CMOV_I_0001>{fn:data($CASAStatementItemList/ns1:accountId)}</ns2:CMOV_I_0001>
            <ns2:CMOV_I_0002>99</ns2:CMOV_I_0002>
            <ns2:CMOV_I_0003></ns2:CMOV_I_0003>
            <ns2:CMOV_I_0004>{let $value := fn:data($CASAStatementItemList/ns1:searchByType) return  if (empty($value) or normalize-space($value) ='') then 'ALL' else $value }</ns2:CMOV_I_0004>
            <ns2:CMOV_I_0005>{fn:data($CASAStatementItemList/ns1:fromDate)}</ns2:CMOV_I_0005>
            <ns2:CMOV_I_0006>9999999</ns2:CMOV_I_0006>
            <ns2:CMOV_I_0007>{fn:data($CASAStatementItemList/ns1:toDate)}</ns2:CMOV_I_0007>
            <ns2:CMOV_I_9998></ns2:CMOV_I_9998>
            <ns2:CMOV_I_9999></ns2:CMOV_I_9999>
        </ns2:operationData>
    </ns2:Request>
};

local:func($CASAStatementItemList)