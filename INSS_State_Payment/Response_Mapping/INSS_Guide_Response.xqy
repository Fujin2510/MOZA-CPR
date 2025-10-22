xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/INSS.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/INSS_GUIDE_NO_DETAILS";
(:: import schema at "../XSD/INSS_GUIDE_NO_DETAILS.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:ConsultaResponse) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:ConsultaResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                
                <ns2:status>{if (fn:data($MSB_Response/ns1:output/status/codigo) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:guideNumber>{fn:data($MSB_Response/ns1:output/numGuiaPagContribuicao)}</ns2:guideNumber>
            <ns2:accountNumber>{fn:data($MSB_Response/ns1:output/numConta)}</ns2:accountNumber>
            <ns2:contributorName>{fn:data($MSB_Response/ns1:output/nomeContribuinte)}</ns2:contributorName>
            <ns2:contributionValue>{fn:data($MSB_Response/ns1:output/valContibuicao)}</ns2:contributionValue>
            <ns2:valjurosMora>{fn:data($MSB_Response/ns1:output/valJurosMora)}</ns2:valjurosMora>
            <ns2:penaltyValue>{fn:data($MSB_Response/ns1:output/valMulta)}</ns2:penaltyValue>
            <ns2:interestValue>{fn:data($MSB_Response/ns1:output/valJurosMora)}</ns2:interestValue>
            <ns2:totalAmount>{fn:data($MSB_Response/ns1:output/valTotalPagar)}</ns2:totalAmount>
            <ns2:contributionTypeCode>{fn:data($MSB_Response/ns1:output/codTipoContribuicao)}</ns2:contributionTypeCode>
            <ns2:contributionType>{fn:data($MSB_Response/ns1:output/tipoContribuicao)}</ns2:contributionType>
            <ns2:inssNumber>{fn:data($MSB_Response/ns1:output/numINSS)}</ns2:inssNumber>
            <ns2:inssStatusCode>ACTIVE</ns2:inssStatusCode>
            <ns2:nuit>{fn:data($MSB_Response/ns1:output/nuit)}</ns2:nuit>
            <ns2:referenceMonth>{fn:data($MSB_Response/ns1:output/mesReferencia)}</ns2:referenceMonth>
            <ns2:inssAgencyCode>{fn:data($MSB_Response/ns1:output/codAgenciaINSS)}</ns2:inssAgencyCode>
            <ns2:inssCreditCurrentAccount>
                <ns2:displayValue>{fn:data($MSB_Response/ns1:output/numContaCreditoINSS)}</ns2:displayValue>
                <ns2:value>{fn:data($MSB_Response/ns1:output/numContaCreditoINSS)}</ns2:value>
            </ns2:inssCreditCurrentAccount>
            <ns2:creditName>{fn:data($MSB_Response/ns1:output/nomeCredito)}</ns2:creditName>
        <ns2:paymentDueDate>
  {
    let $date := fn:data($MSB_Response/ns1:output/dataPagamento)
    return concat($date, 'T00:00:00')
  }
</ns2:paymentDueDate>

            <ns2:paymentLocation>{fn:data($MSB_Response/ns1:output/localPagamento)}</ns2:paymentLocation>
            <ns2:instructions>{fn:data($MSB_Response/ns1:output/instrucoes)}</ns2:instructions>
            <ns2:inssControlNumber>{fn:data($MSB_Response/ns1:output/codControloINSS)}</ns2:inssControlNumber>
            <ns2:paymentFormat>{fn:data($MSB_Response/ns1:output/formPagamento)}</ns2:paymentFormat>
            <ns2:bankIdentificationNumber>{fn:data($MSB_Response/ns1:output/numIdentificacaoBanco)}</ns2:bankIdentificationNumber>
        <ns2:dateOfReceipt>
  {
     fn:data($MSB_Response/ns1:output/dataHoraRecebimento)
  
  }
</ns2:dateOfReceipt>
            <ns2:returnProtocol>{fn:data($MSB_Response/ns1:output/protocoloRetorno)}</ns2:returnProtocol>
          <ns2:processingDate>
{
 fn:data($MSB_Response/ns1:output/dataHoraProcessamento)
 
}
</ns2:processingDate>
            <ns2:authenticationCode>{fn:data($MSB_Response/ns1:output/codAutenticacao)}</ns2:authenticationCode>
                <ns2:amountPaid>{fn:data($MSB_Response/ns1:output/valPago)}</ns2:amountPaid>
                <ns2:movementSequence>{fn:data($MSB_Response/ns1:output/seqMovimento)}</ns2:movementSequence>
            <ns2:returnMessage>{fn:data($MSB_Response/ns1:output/msgErroINSS)}</ns2:returnMessage>
            <ns2:currencyCode></ns2:currencyCode>
        </ns2:data>
    </ns2:Response>
};

local:func($MSB_Response)