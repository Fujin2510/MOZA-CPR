xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/sessionprocess";
(:: import schema at "SessionParamsGet.xsd" ::)
declare namespace ns1="http://xmlns.oracle.com/pcbpel/adapter/db/top/InsertSessionParams";
(:: import schema at "InsertSessionParams_table.xsd" ::)

declare variable $Resp as element() (:: schema-element(ns1:SessionTxnUserCollection) ::) external;

declare function local:func($Resp as element() (:: schema-element(ns1:SessionTxnUserCollection) ::)) as element() (:: schema-element(ns2:SessionData) ::) {
    <ns2:SessionData>
        <ns2:Session>{fn:data($Resp/ns1:SessionTxnUser/ns1:sessionId)}</ns2:Session>
        <ns2:UserId>{fn:data($Resp/ns1:SessionTxnUser/ns1:userId)}</ns2:UserId>
        <ns2:CreatedDate>{fn:data($Resp/ns1:SessionTxnUser/ns1:creationTime)}</ns2:CreatedDate>
    </ns2:SessionData>
};

local:func($Resp)