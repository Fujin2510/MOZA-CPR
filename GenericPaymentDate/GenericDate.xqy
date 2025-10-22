xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/genericPaymentDate";
(:: import schema at "GENERIC_PAYMENT_DATE.xsd" ::)

declare variable $req as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($req as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns1:Response) ::) {
    <ns1:Response>
        <ns1:data>
            <ns1:dictionaryArray></ns1:dictionaryArray>
            <ns1:referenceNo></ns1:referenceNo>
            <ns1:result>
                <ns1:dictionaryArray></ns1:dictionaryArray>
                <ns1:externalReferenceId></ns1:externalReferenceId>
                <ns1:status>SUCCESS</ns1:status>
                <ns1:errorList></ns1:errorList>
                <ns1:warningList></ns1:warningList>
            </ns1:result>
            <ns1:hasMore></ns1:hasMore>
            <ns1:totalRecords></ns1:totalRecords>
            <ns1:startSequence></ns1:startSequence>
            <ns1:dateDetails>
                <ns1:dictionaryArray></ns1:dictionaryArray>
                <ns1:networkDate>
                {
          let $date := fn:data($req/ns1:activationDate/ns1:dateString)
          return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
        }
                </ns1:networkDate>
                <ns1:instructionDate>     {
          let $date := fn:data($req/ns1:activationDate/ns1:dateString)
          return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
        }</ns1:instructionDate>
                <ns1:activationDate>     {
          let $date := fn:data($req/ns1:activationDate/ns1:dateString)
          return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
        }</ns1:activationDate>
            </ns1:dateDetails>
        </ns1:data>
    </ns1:Response>
};

local:func($req)