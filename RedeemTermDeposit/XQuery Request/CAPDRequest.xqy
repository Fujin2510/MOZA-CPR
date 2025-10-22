xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns3="http://www.mozabank.org/CAPD";
(:: import schema at "../../GetAllProducts_TD/Schema/CAPD.xsd" ::) 
declare namespace ns1="http://www.mozabank.org/td-fetch-penality";
(:: import schema at "../Schemas/TD_FETCH_PENALTY.xsd" ::)

declare variable $FetchPenaltyRequest as element() (:: schema-element(ns1:Request) ::) external;  
declare function local:func($CAPDRequest as element() (:: schema-element(ns1:Request) ::)) 
                            as element() (:: schema-element(ns3:CAPDRequest) ::) {
    <ns3:CAPDRequest>
        <ns3:user>{fn:data($FetchPenaltyRequest/ns1:partyId)}</ns3:user>
        <ns3:password></ns3:password>
        <ns3:origin>P</ns3:origin>
        <ns3:channelCode>INT</ns3:channelCode>
        <ns3:version>R30</ns3:version>
        <ns3:licenceKey>licenceKey</ns3:licenceKey>
        <ns3:sessionId>00000000</ns3:sessionId>
        <ns3:transactionCode>CAPD</ns3:transactionCode>
        <ns3:operationData>
            <ns3:CAPD_I_0001>{fn:data($FetchPenaltyRequest/ns1:accountId)}</ns3:CAPD_I_0001>
        </ns3:operationData>
    </ns3:CAPDRequest>
};

local:func($FetchPenaltyRequest)