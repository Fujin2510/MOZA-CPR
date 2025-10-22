xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "Resources/PagamentoFicheirosWs.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/bulkTranser";
(:: import schema at "Resources/Bulk_Transfer.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:ConsultarFicheiroFornecedorAceiteResponse) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:ConsultarFicheiroFornecedorAceiteResponse) ::)) as element() (:: schema-element(ns2:BulkStatusSyncResponse) ::) {
    <ns2:BulkStatusSyncResponse>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>{
                  let $code := fn:data($MSB_Response/ns1:response/status/codigo)
                  return
                    if ($code = 0) then 'SUCCESS'
                    else if ($code = -1) then 'PENDING'
                    else 'FAILURE'
                }</ns2:status>

              {let $code := fn:data($MSB_Response/ns1:response/status/codigo)
              return
              if ($code = 0) then ()
              else if($code= -1)then () 
              else(
              <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
               </ns2:errorList>)}
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords> </ns2:totalRecords>
      
            <ns2:startSequence></ns2:startSequence>
           <ns2:fileProcessingDate>
{
  let $procDate := fn:data($MSB_Response/ns1:response/ficheiroPagamento/dataProcessamento)
  return 
    if (normalize-space($procDate) != '') 
    then concat($procDate, 'T00:00:00') 
    else ()
}
</ns2:fileProcessingDate>

            <ns2:fileStatus>{fn:data($MSB_Response/ns1:response/ficheiroPagamento/sitFicheiro)}</ns2:fileStatus>
            <ns2:totalAmount>{fn:data($MSB_Response/ns1:response/ficheiroPagamento/importancia)}</ns2:totalAmount>
            <ns2:currency>{fn:data($MSB_Response/ns1:response/ficheiroPagamento/moeda)}</ns2:currency>
            <ns2:bankAccountIdentifier>{fn:data($MSB_Response/ns1:response/ficheiroPagamento/nib)}</ns2:bankAccountIdentifier>
            <ns2:clientNumber>{fn:data($MSB_Response/ns1:response/ficheiroPagamento/numCliente)}</ns2:clientNumber>
            <ns2:externalFileRefId>{fn:data($MSB_Response/ns1:response/ficheiroPagamento/numFicheiro)}</ns2:externalFileRefId>
            <ns2:operationNumber>{fn:data($MSB_Response/ns1:response/ficheiroPagamento/numOpContabBanka)}</ns2:operationNumber>
            <ns2:totalFileRecords>{fn:data($MSB_Response/ns1:response/ficheiroPagamento/totalRegistos)}</ns2:totalFileRecords>
        </ns2:data>
    </ns2:BulkStatusSyncResponse>
};

local:func($MSB_Response)