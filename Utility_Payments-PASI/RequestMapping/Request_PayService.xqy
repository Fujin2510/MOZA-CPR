xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSDs/ConsultarEntidade.wsdl" ::)
declare namespace ns2="http://www.mozabank.org/PASI_ENTITY_PAYMENT";
(:: import schema at "../XSDs/PASI_ENTITY_PAYMENT.xsd" ::)

declare variable $OBDX_Request as element() (:: schema-element(ns2:Request) ::) external;
declare variable $accessToken as xs:string external;
declare variable $partyIdVar as xs:string external;

declare function local:func($OBDX_Request as element() (:: schema-element(ns2:Request) ::),$partyIdVar,$accessToken as xs:string) as element() (:: schema-element(ns1:pagarServico) ::) {

    <ns1:pagarServico>
        <input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
            <entidade>{fn:data($OBDX_Request/ns2:entityCode)}</entidade>
            <moeda>{fn:data($OBDX_Request/ns2:currency)}</moeda>
            <montante>{fn:data($OBDX_Request/ns2:amount)}</montante>
            <numeroConta>{fn:data($OBDX_Request/ns2:accountNumber)}</numeroConta>
            <referencia>{fn:data($OBDX_Request/ns2:paymentReference)}</referencia>
            <user>{$partyIdVar}</user>
        </input>
    </ns1:pagarServico>
};

local:func($OBDX_Request ,$accessToken ,$partyIdVar)