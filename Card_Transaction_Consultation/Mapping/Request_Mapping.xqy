xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/ctcd";
(:: import schema at "../XSDs/CTCD%20-%20Card%20Transaction%20Consultation.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CTCD_TRANSACTION_LIST";
(:: import schema at "../XSDs/Card_Txn_List.xsd" ::)

declare variable $Request_Mapping as element() (:: schema-element(ns1:Request) ::) external;

declare variable $userIdVar as xs:string external;

declare function local:func($Request_Mapping as element() (:: schema-element(ns1:Request) ::),$userIdVar as xs:string) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{ $userIdVar }</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CTCD</ns2:transactionCode>
       <ns2:operationData>
            <ns2:CTCD_I_0001>20</ns2:CTCD_I_0001>
            <ns2:CTCD_I_0002>{fn:data($Request_Mapping/ns1:cardNumber)}</ns2:CTCD_I_0002>
            <ns2:CTCD_I_0003>
              {
                substring(fn:data($Request_Mapping/ns1:startDate/ns1:dateString), 1, 8)
              }
</ns2:CTCD_I_0003>           
<ns2:CTCD_I_0004>
              {
                substring(fn:data($Request_Mapping/ns1:endDate/ns1:dateString), 1, 8)
              }
</ns2:CTCD_I_0004>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request_Mapping, $userIdVar)