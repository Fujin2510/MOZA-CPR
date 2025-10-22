xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/genericPaymentDate";
(:: import schema at "GENERIC_PAYMENT_DATE.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ptfi";
(:: import schema at "PTFI.xsd" ::)

declare variable $GenPayResp as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($GenPayResp as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
    <ns2:data>
    <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId>{fn:data($GenPayResp/ns1:operationData/ns1:PTFI_O_0001)}</ns2:externalReferenceId>
            <ns2:status>{if(fn:data($GenPayResp/ns1:errorCode) = '0') then 'SUCCESS' else 'FAILURE'}</ns2:status>
            {if(fn:data($GenPayResp/ns1:errorCode) = '0') then () else(
<ns2:errorList>
<ns2:code>ERR001</ns2:code>
<ns2:message>Invalid backend response</ns2:message>
</ns2:errorList>)  }
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:dateDetails>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:networkDate></ns2:networkDate>
            <ns2:instructionDate>{
              let $date := fn:string(fn:current-date())
              return fn:substring($date, 1, 10)
            }</ns2:instructionDate>

            <ns2:activationDate></ns2:activationDate>
        </ns2:dateDetails>
        </ns2:data>
    </ns2:Response>
};

local:func($GenPayResp)