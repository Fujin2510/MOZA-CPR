xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/debit_card_read";
(:: import schema at "../Schema/DebitCardRead.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCARDebitCard";
(:: import schema at "../Schema/CCAR.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:DebitCardReadResponse) ::) {
    <ns2:DebitCardReadResponse>
        <ns2:data>
            <ns2:result>
                <ns2:status></ns2:status>
            </ns2:result>
            <ns2:cardtype>{fn:data($MSB_Response/ns1:data/ns1:operationData/ns1:CCAR_O_0003/ns1:Card/ns1:CCAR_O_0003_0013)}</ns2:cardtype>
            <ns2:holder>{fn:data($MSB_Response/ns1:data/ns1:operationData/ns1:CCAR_O_0003/ns1:Card/ns1:CCAR_O_0003_0004)}</ns2:holder>
            <ns2:cardnumber>{fn:data($MSB_Response/ns1:data/ns1:operationData/ns1:CCAR_O_0003/ns1:Card/ns1:CCAR_O_0003_0001)}</ns2:cardnumber>
            <ns2:status>{fn:data($MSB_Response/ns1:data/ns1:operationData/ns1:CCAR_O_0003/ns1:Card/ns1:CCAR_O_0003_0011)}</ns2:status>
            <ns2:issuedate>{fn:data($MSB_Response/ns1:data/ns1:operationData/ns1:CCAR_O_0003/ns1:Card/ns1:CCAR_O_0003_0007)}</ns2:issuedate>
            <ns2:expirationdate>{fn:data($MSB_Response/ns1:data/ns1:operationData/ns1:CCAR_O_0003/ns1:Card/ns1:CCAR_O_0003_0008)}</ns2:expirationdate>
            <ns2:dateofsituation>{fn:data($MSB_Response/ns1:data/ns1:operationData/ns1:CCAR_O_0003/ns1:Card/ns1:CCAR_O_0003_0012)}</ns2:dateofsituation>
            <ns2:associatedcurrentAccount>{fn:data($MSB_Response/ns1:data/ns1:operationData/ns1:CCAR_O_0003/ns1:Card/ns1:CCAR_O_0003_0006)}</ns2:associatedcurrentAccount>
            <ns2:messages>
                <ns2:keyId></ns2:keyId>
                <ns2:status>{
              if (fn:data($MSB_Response/ns1:data/ns1:errorCode) = '0') 
              then 'SUCCESS' 
              else 'FAILURE'
            }
			</ns2:status>
                <ns2:codes></ns2:codes>
                <ns2:requestId></ns2:requestId>
                <ns2:httpStatusCode></ns2:httpStatusCode>
                <ns2:overrideAuthLevelsReqd></ns2:overrideAuthLevelsReqd>
            </ns2:messages>
        </ns2:data>
    </ns2:DebitCardReadResponse>
};

local:func($MSB_Response)