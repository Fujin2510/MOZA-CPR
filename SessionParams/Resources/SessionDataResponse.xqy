xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/sessionprocess";
(:: import schema at "SessionParamsGet.xsd" ::)
declare namespace ns1="http://xmlns.oracle.com/pcbpel/adapter/db/top/QuerySessions";
(:: import schema at "QuerySessions_table.xsd" ::)

declare variable $Resp as element() (:: schema-element(ns1:SessionTxnUserCollection) ::) external;

declare function local:func($Resp as element() (:: schema-element(ns1:SessionTxnUserCollection) ::)) as element() (:: schema-element(ns2:SessionData) ::) {
    <ns2:SessionData>
        <ns2:Session>{fn:data($Resp/ns1:SessionTxnUser/ns1:sessionId)}</ns2:Session>
        <ns2:UserId>{fn:data($Resp/ns1:SessionTxnUser/ns1:userId)}</ns2:UserId>
        <ns2:CreatedDate>{fn:data($Resp/ns1:SessionTxnUser/ns1:creationTime)}</ns2:CreatedDate>
        <ns2:PartyName>{fn:data($Resp/ns1:SessionTxnUser/ns1:partyname)}</ns2:PartyName>
        <ns2:BranchCode>{fn:data($Resp/ns1:SessionTxnUser/ns1:branchcode)}</ns2:BranchCode>
        {
            if ($Resp/ns1:SessionTxnUser/ns1:accountId)
            then <ns2:AccountId>{fn:data($Resp/ns1:SessionTxnUser/ns1:accountId)}</ns2:AccountId>
            else ()
        }
        {      
                if ($Resp/ns1:SessionTxnUser/ns1:fromDate)
                then <ns2:FromDate>{fn:data($Resp/ns1:SessionTxnUser/ns1:fromDate)}</ns2:FromDate>
                else () 
        }
        {
                if ($Resp/ns1:SessionTxnUser/ns1:toDate)
                then <ns2:ToDate>{fn:data($Resp/ns1:SessionTxnUser/ns1:toDate)}</ns2:ToDate>
                else () 
        }
        {
            if ($Resp/ns1:SessionTxnUser/ns1:status)
            then <ns2:Status>{fn:data($Resp/ns1:SessionTxnUser/ns1:status)}</ns2:Status>
            else ()
        }
        {
            if ($Resp/ns1:SessionTxnUser/ns1:fullname)
            then <ns2:FullName>{fn:data($Resp/ns1:SessionTxnUser/ns1:fullname)}</ns2:FullName>
            else ()
        }
    </ns2:SessionData>
};

local:func($Resp)