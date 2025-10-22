xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../Schema/PaymentService.wsdl" ::)
declare namespace ns2="http://www.mozabank.org/POP_OBDX";
(:: import schema at "../Schema/POP.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:ProofOfPaymentBASE64Response) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:ProofOfPaymentBASE64Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>{
                if ($Response/ns1:output/serviceOutput/status) then
                  let $st := fn:data($Response/ns1:output/serviceOutput/status)
                  return
                    if ($st = '200') then
                      'SUCCESS'
                    else
                      'FAILURE'
                else if ($Response/ns1:output/base64) then
                  'SUCCESS'
                else
                  'FAILURE'
              }</ns2:status>  
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            {
                if ($Response/ns1:output/base64)
                then <ns2:base64>{fn:data($Response/ns1:output/base64)}</ns2:base64>
                else ()
            }
        </ns2:data>
    </ns2:Response>
};

local:func($Response)