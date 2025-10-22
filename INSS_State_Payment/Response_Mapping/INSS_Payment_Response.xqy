xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/INSS.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/INSS_PAYMENT";
(:: import schema at "../XSD/INSS_PAYMENT.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:PagarResponse) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:PagarResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
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
            <ns2:taxPayerName>{fn:data($MSB_Response/ns1:output/nome)}</ns2:taxPayerName>
            <ns2:contributionTypeCode>{fn:data($MSB_Response/ns1:output/codTipoContribuicao)}</ns2:contributionTypeCode>
            <ns2:contributionType>{fn:data($MSB_Response/ns1:output/tipoContribuicao)}</ns2:contributionType>
            <ns2:inssNumber>{fn:data($MSB_Response/ns1:output/numINSS)}</ns2:inssNumber>
            <ns2:nuit>{fn:data($MSB_Response/ns1:output/nuit)}</ns2:nuit>
            <ns2:referenceMonth>{fn:data($MSB_Response/ns1:output/mesReferencia)}</ns2:referenceMonth>
      <ns2:paymentDeadline>
  {
    let $date := fn:data($MSB_Response/ns1:output/dataLimitePagamento)
    return concat($date, 'T00:00:00')
  }
</ns2:paymentDeadline>



       
            <ns2:fineAmount>
                <ns2:currency></ns2:currency>
                <ns2:amount>{fn:data($MSB_Response/ns1:output/valMulta)}</ns2:amount>
            </ns2:fineAmount>
            <ns2:defaultInterestAmount>
                <ns2:currency></ns2:currency>
                <ns2:amount>{fn:data($MSB_Response/ns1:output/valJurosMora)}</ns2:amount>
            </ns2:defaultInterestAmount>
            <ns2:totalAmount>
                <ns2:currency></ns2:currency>
                <ns2:amount>{fn:data($MSB_Response/ns1:output/valTotalPagar)}</ns2:amount>
            </ns2:totalAmount>
            <ns2:inssAgencyCode>{fn:data($MSB_Response/ns1:output/codAgenciaINSS)}</ns2:inssAgencyCode>
            <ns2:inssCreditCurrentAccount>{fn:data($MSB_Response/ns1:output/numContaCreditoINSS)}</ns2:inssCreditCurrentAccount>
            <ns2:creditName>{fn:data($MSB_Response/ns1:output/nomeCredito)}</ns2:creditName>
          <ns2:paymentDate>
  {
    let $date := fn:data($MSB_Response/ns1:output/dataPagamento)
    let $dateOnly := if (contains($date, 'T')) then substring-before($date, 'T') else $date
    return concat($dateOnly, 'T00:00:00')
  }
</ns2:paymentDate>


            <ns2:paymentLocation>{fn:data($MSB_Response/ns1:output/localPagamento)}</ns2:paymentLocation>
            <ns2:inssInstructions>{fn:data($MSB_Response/ns1:output/instrucoes)}</ns2:inssInstructions>
            <ns2:inssControlNumber>{fn:data($MSB_Response/ns1:output/codControloINSS)}</ns2:inssControlNumber>
            <ns2:paymentFormat>{fn:data($MSB_Response/ns1:output/formPagamento)}</ns2:paymentFormat>
            <ns2:bankIdentificationNumber>{fn:data($MSB_Response/ns1:output/numIdentificacaoBanco)}</ns2:bankIdentificationNumber>
            <ns2:dateOfReceipt>
              { fn:data($MSB_Response/ns1:output/dataHoraRecebimento) }
</ns2:dateOfReceipt>

            <ns2:returnProtocol>{fn:data($MSB_Response/ns1:output/protocoloRetorno)}</ns2:returnProtocol>
           <ns2:processingDate>
                  { fn:data($MSB_Response/ns1:output/dataHoraProcessamento) }
</ns2:processingDate>
            <ns2:authenticationCode>{fn:data($MSB_Response/ns1:output/codAutenticacao)}</ns2:authenticationCode>
            <ns2:operationNumber>{fn:data($MSB_Response/ns1:output/numOperacao)}</ns2:operationNumber>
            <ns2:authorizationNumber>{fn:data($MSB_Response/ns1:output/numAutorizacao)}</ns2:authorizationNumber>
            <ns2:amountPaid>
                <ns2:currency>MZN</ns2:currency>
                <ns2:amount>{fn:data($MSB_Response/ns1:output/valPago)}</ns2:amount>
            </ns2:amountPaid>
            <ns2:movementSequence>{fn:data($MSB_Response/ns1:output/seqMovimento)}</ns2:movementSequence>
                         <ns2:inssErrorMessage>{fn:data($MSB_Response/ns1:output/msgErroINSS)}</ns2:inssErrorMessage>
            <ns2:fileData>{fn:data($MSB_Response/ns1:output/base64File)}</ns2:fileData>
        </ns2:data>
    </ns2:Response>
};

local:func($MSB_Response)