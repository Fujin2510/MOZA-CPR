xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../Schema/TFCM.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/DW_TFCM_BENE_NAME";
(:: import schema at "../Schema/DW_TFCM_BENE_NAME.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:getBeneficiaryNameResponse) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:getBeneficiaryNameResponse) ::)) 
  as element() (:: schema-element(ns2:Response) ::) {

  <ns2:Response>
    <ns2:data>
      <ns2:dictionaryArray></ns2:dictionaryArray>
      <ns2:referenceNo></ns2:referenceNo>
      <ns2:result>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:externalReferenceId></ns2:externalReferenceId>
        <ns2:status>{
          if (fn:data($Response/ns1:response/status/codigo) = 0) 
          then 'SUCCESS' 
          else 'FAILURE'
        }</ns2:status>
        
        {
          if (fn:data($Response/ns1:response/status/codigo) != 0) then (
            <ns2:errorList>
              <ns2:code>ERR001</ns2:code>
              <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>
          ) else ()
        }
        
        <ns2:warningList></ns2:warningList>
      </ns2:result>
      
      <ns2:hasMore></ns2:hasMore>
      <ns2:totalRecords></ns2:totalRecords>
      <ns2:startSequence></ns2:startSequence>
      <ns2:BeneMobNumber>{fn:data($Response/ns1:response/cellular)}</ns2:BeneMobNumber>
      <ns2:mobWalletCode>{fn:data($Response/ns1:response/walletID)}</ns2:mobWalletCode>
      <ns2:costumerName>{fn:data($Response/ns1:response/costumerName)}</ns2:costumerName>
    </ns2:data>
  </ns2:Response>

};

local:func($Response)