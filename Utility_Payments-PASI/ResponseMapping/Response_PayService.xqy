xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSDs/ConsultarEntidade.wsdl" ::)
declare namespace ns2="http://www.mozabank.org/PASI_ENTITY_PAYMENT";
(:: import schema at "../XSDs/PASI_ENTITY_PAYMENT.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:pagarServicoResponse) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:pagarServicoResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
             <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>{if (fn:data($MSB_Response/ns1:response/status/codigo) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:entityCode>{fn:data($MSB_Response/ns1:response/entidade)}</ns2:entityCode>
            <ns2:accountNumber>{fn:data($MSB_Response/ns1:response/numeroConta)}</ns2:accountNumber>
            <ns2:paymentReference>{fn:data($MSB_Response/ns1:response/numeroOperacao)}</ns2:paymentReference>
            <ns2:amount>{fn:data($MSB_Response/ns1:response/montante)}</ns2:amount>
            <ns2:currency>{fn:data($MSB_Response/ns1:response/moeda)}</ns2:currency>
        </ns2:data>
    </ns2:Response>
};

local:func($MSB_Response)