xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/TFCM%201.wsdl" ::)

declare namespace ns2 = "http://www.mozabank.org/DW_TFCM_TRANSFER";
(:: import schema at "../XSD/dw_tfcm_transfer.xsd" ::)

declare variable $responses as element(ns1:performSingleTransferResponse)* external;

declare function local:func(
  $responses as element(ns1:performSingleTransferResponse)*
) as element(ns2:Response) {
  <ns2:Response>
    <ns2:data>
      <ns2:dictionaryArray/>
      <ns2:referenceNo/>
      <ns2:result>
        <ns2:dictionaryArray/>
        <ns2:externalReferenceId/>
        <ns2:status>SUCCESS</ns2:status>
        <ns2:errorList/>
        <ns2:warningList/>
      </ns2:result>
      <ns2:hasMore/>
      <ns2:totalRecords/>
      <ns2:startSequence/>
      <!--    {
          for $res in $responses
          return
            <ns2:transfer>
              <ns2:amount>{fn:data($res/ns1:response/ns1:amount)}</ns2:amount>
              <ns2:beneMobNumber>{fn:data($res/ns1:response/ns1:cellular)}</ns2:beneMobNumber>
              <ns2:currency>{fn:data($res/ns1:response/ns1:currency)}</ns2:currency>
              <ns2:date>
             <ns2:date>
  {
    replace(fn:data($res/ns1:response/status/executado), " ", "T")
  }
</ns2:date>
              <ns2:transactionID>{fn:data($res/ns1:response/ns1:responseCode)}</ns2:transactionID>
            </ns2:transfer>
        }
      </ns2:transfers> -->
    </ns2:data>
  </ns2:Response>
};

local:func($responses)