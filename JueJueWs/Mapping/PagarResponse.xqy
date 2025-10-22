xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/JueJueWS.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/JueEntityPayment";
(:: import schema at "../XSD/JueEntityPayment.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:PagarResponse) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:PagarResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                 <ns2:status>{if(fn:data($Response/ns1:output/status/codigo) = 0)
                then 'SUCCESS' else 'FAILURE'}</ns2:status>
{if(fn:data($Response/ns1:output/status/codigo) = 0) then () else(
            <ns2:errorList>
                <ns2:code></ns2:code>
                <ns2:message></ns2:message>
            </ns2:errorList>) }                
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
{ 
  if (fn:data($Response/ns1:output/status/codigo) = 0) then
    (
      <ns2:transactionName>{fn:data($Response/ns1:output/jueGoodResponse/transationName)}</ns2:transactionName>,
      <ns2:status>{fn:data($Response/ns1:output/jueGoodResponse/status)}</ns2:status>,
      <ns2:transactionLogNumber>{fn:data($Response/ns1:output/jueGoodResponse/transationLogNumber)}</ns2:transactionLogNumber>,
      <ns2:transactionDate>{substring-before(fn:data($Response/ns1:output/status/executado), ' ')}</ns2:transactionDate>,
      <ns2:operationNumber>{fn:data($Response/ns1:output/numOperacao)}</ns2:operationNumber>,
      <ns2:confirmationSheet>{fn:data($Response/ns1:output/ficheiroDeConfirmacao)}</ns2:confirmationSheet>,
      <ns2:messageGuid>{fn:data($Response/ns1:output/jueGoodResponse/messageGuid)}</ns2:messageGuid>
    )
  else ()
}
        </ns2:data>
    </ns2:Response>
};

local:func($Response)