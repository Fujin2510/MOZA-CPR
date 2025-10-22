xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns3="http://www.mozabank.org/CCARCreditCard";
(:: import schema at "XSD/CCAR.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CREDIT_CARD_READ";
(:: import schema at "XSD/CREDIT_CARD_READ.xsd" ::)

declare variable $GetAllProductsRequest as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;
declare function local:func($GetAllProductsRequest as element() (:: schema-element(ns1:Request) ::),$userIdVar) as element() (:: schema-element(ns3:Request) ::) {
    <ns3:Request>
        <ns3:user>{$userIdVar}</ns3:user>
        <ns3:password></ns3:password>
        <ns3:origin>P</ns3:origin>
        <ns3:channelCode>INT</ns3:channelCode>
        <ns3:version>R30</ns3:version>
        <ns3:licenceKey>licenseKey</ns3:licenceKey>
        <ns3:sessionId></ns3:sessionId>
        <ns3:transactionCode>CCAR</ns3:transactionCode>
        <ns3:operationData>
            <ns3:CCAR_I_0001>20</ns3:CCAR_I_0001>
            <ns3:CCAR_I_0003>S</ns3:CCAR_I_0003>
            <ns3:CCAR_I_0004>N</ns3:CCAR_I_0004>
            <ns3:CCAR_I_0007>N</ns3:CCAR_I_0007>
        </ns3:operationData>
    </ns3:Request>
};

local:func($GetAllProductsRequest,$userIdVar)