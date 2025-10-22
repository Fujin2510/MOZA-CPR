xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/obdx/td_topup_projection";
(:: import schema at "../XSD/TD_TOPUP_PROJECTION.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/capd";
(:: import schema at "../XSD/CAPD.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:CAPDRequest) ::) {
    <ns2:CAPDRequest>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CAPD</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CAPD_I_0001>{
                let $acct := data($Request/ns1:accountId)
                return
                    if (contains($acct, "@~")) then
                        substring-after($acct, "@~")
                    else
                        $acct
            }</ns2:CAPD_I_0001>
            </ns2:operationData>
    </ns2:CAPDRequest>
};

local:func($Request)