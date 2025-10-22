xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns3="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ccap_party_td_accounts_list";
(:: import schema at "../Schema/PARTY_TD_ACCOUNTS_LIST.xsd" ::)

declare variable $CAPDRequest as element() (:: schema-element(ns1:Request) ::) external;
declare variable $CCAPResponse as element() (:: schema-element(ns2:Response) ::) external;
declare variable $AccountVar as xs:string external;
declare function local:func($CAPDRequest as element() (:: schema-element(ns1:Request) ::), 
                            $CCAPResponse as element() (:: schema-element(ns2:Response) ::),$AccountVar) 
                            as element() (:: schema-element(ns3:CAPDRequest) ::) {
    <ns3:CAPDRequest>
        <ns3:user>{fn:data($CAPDRequest/ns1:partyId)}</ns3:user>
        <ns3:password></ns3:password>
        <ns3:origin>P</ns3:origin>
        <ns3:channelCode>INT</ns3:channelCode>
        <ns3:version>R30</ns3:version>
        <ns3:licenceKey>licenceKey</ns3:licenceKey>
        <ns3:sessionId>00000000</ns3:sessionId>
        <ns3:transactionCode>CAPD</ns3:transactionCode>
        <ns3:operationData>
            <ns3:CAPD_I_0001>{$AccountVar}</ns3:CAPD_I_0001>
        </ns3:operationData>
    </ns3:CAPDRequest>
};

local:func($CAPDRequest, $CCAPResponse,$AccountVar)