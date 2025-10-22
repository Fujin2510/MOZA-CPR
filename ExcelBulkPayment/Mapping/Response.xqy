xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSDs/PagamentoFicheiros.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/excelBulk";
(:: import schema at "../XSDs/ExcelBulkPayment.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:CarregarFicheiroSalarioResponse) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:CarregarFicheiroSalarioResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
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
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:authorizationLibraryReference>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/bibAut)}</ns2:authorizationLibraryReference>
            <ns2:inputLibraryReference>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/bibInput)}</ns2:inputLibraryReference>
            <ns2:originalLibraryReference>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/bibOriginal)}</ns2:originalLibraryReference>
            <ns2:debitAccountNumber>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/contaPrincipal)}</ns2:debitAccountNumber>
            <ns2:effectiveProcessingDate>
              {concat(fn:data($MSB_Response/ns1:response/ficheiroCarregado/dataProcEfectivo), 'T00:00:00')}
            </ns2:effectiveProcessingDate>           
            <ns2:fileFormatType>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/formato)}</ns2:fileFormatType>
            <ns2:totalProcessedAmount>{
                let $raw := xs:decimal(fn:data($MSB_Response/ns1:response/ficheiroCarregado/importanciaTotal))
let $amount := $raw div 100
return fn-bea:format-number($amount, "0.00")

                }</ns2:totalProcessedAmount>
            <ns2:cancellationIndicator>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/indCancela)}</ns2:cancellationIndicator>
            <ns2:continueProcessingIndicator>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/indContinua)}</ns2:continueProcessingIndicator>
            <ns2:authSubmissionIndicator>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/indEnvioAut)}</ns2:authSubmissionIndicator>
            <ns2:fileSubmissionIndicator>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/indEnvioFicheiro)}</ns2:fileSubmissionIndicator>
            <ns2:processingFeedbackMessage>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/mensagem)}</ns2:processingFeedbackMessage>
            <ns2:clientName>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/nomeCliente)}</ns2:clientName>
            <ns2:appConvertedFileName>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/nomeConvertido)}</ns2:appConvertedFileName>
            <ns2:appConvertedAuthFileName>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/nomeConvertidoAut)}</ns2:appConvertedAuthFileName>
            <ns2:fileName>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/nomeOriginal)}</ns2:fileName>
            <ns2:authFileName>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/nomeOriginalAut)}</ns2:authFileName>
            <ns2:clientNumber>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/numCliente)}</ns2:clientNumber>
            <ns2:fileNumber>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/numFicheiro)}</ns2:fileNumber>
           
               <ns2:orderingPartyReference>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/refOrdenante)}</ns2:orderingPartyReference>
               
            <ns2:processingType>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/tipoProcessamento)}</ns2:processingType>
            <ns2:renumerationType>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/tipoRemuneracao)}</ns2:renumerationType>
            <ns2:totalRecordsInFile>{fn:data($MSB_Response/ns1:response/ficheiroCarregado/totalRegistos)}</ns2:totalRecordsInFile>
        </ns2:data>
    </ns2:Response>
};

local:func($MSB_Response)