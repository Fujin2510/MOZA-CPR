xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/TFCM%201.wsdl" ::)
declare namespace ns2="http://www.mozabank.org/DW_TFCM_TRANSFER";
(:: import schema at "../XSD/dw_tfcm_transfer.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:performSingleTransferResponse) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:performSingleTransferResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>{ if (fn:data($MSB_Response/ns1:response/status/codigo) = 0) then "SUCCESS" else "FAILURE" }
</ns2:status>
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:transfers>
                <ns2:amount>{fn:data($MSB_Response/ns1:response/amount)}</ns2:amount>
                <ns2:beneMobNumber>{fn:data($MSB_Response/ns1:response/cellular)}</ns2:beneMobNumber>
                <ns2:currency>{fn:data($MSB_Response/ns1:response/currency)}</ns2:currency>
                  <ns2:date>
  {
    replace(fn:data($MSB_Response/ns1:response/status/executado), " ", "T")
  }
</ns2:date>
                <ns2:transactionID>{fn:data($MSB_Response/ns1:response/transactionID)}</ns2:transactionID>
            </ns2:transfers>
        </ns2:data>
    </ns2:Response>
};

local:func($MSB_Response)