xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/CompraRecargaOperadora.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/operator_recharge";
(:: import schema at "../XSD/OPERATOR_RECHARGE.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:ComprarRecargaResponse) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:ComprarRecargaResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
  
        <ns2:data>
     
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
            <ns2:status>{if (fn:data($Request/ns1:response/status/codigo) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>
            <ns2:errorList></ns2:errorList>
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        <ns2:operatorCode>{fn:data($Request/ns1:response/codigoOperadora)}</ns2:operatorCode>
        <ns2:accountNumber>{xs:string(fn:data($Request/ns1:response/numeroConta))}</ns2:accountNumber>
        <ns2:phoneNumber>{xs:string(fn:data($Request/ns1:response/numeroTelefone))}</ns2:phoneNumber>
        <ns2:amount>
{
  let $amount := xs:decimal(fn:data($Request/ns1:response/montante))
  return
    if ($amount = xs:integer($amount)) then
      concat($amount, '.00')
    else
      $amount
}
</ns2:amount>
        <ns2:currency>{fn:data($Request/ns1:response/moeda)}</ns2:currency>
        <ns2:operationNumber>{fn:data($Request/ns1:response/numeroOperacao)}</ns2:operationNumber>       </ns2:data>
    </ns2:Response>
};

local:func($Request)