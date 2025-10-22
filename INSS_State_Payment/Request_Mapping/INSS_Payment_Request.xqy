xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/INSS.wsdl" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/INSS_PAYMENT";
(:: import schema at "../XSD/INSS_PAYMENT.xsd" ::)
declare variable $accessToken as xs:string external;

declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($OBDX_Request as element() (:: schema-element(ns1:Request) ::),$accessToken as xs:string) as element() (:: schema-element(ns2:Pagar) ::) {
    <ns2:Pagar>
        <ns2:input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
            <nome>{fn:data($OBDX_Request/ns1:taxPayerName)}</nome>
            <numConta>{fn:data($OBDX_Request/ns1:accountNumber)}</numConta>
            <numGuiaPagContribuicao>{fn:data($OBDX_Request/ns1:guideNumber)}</numGuiaPagContribuicao>
            <username></username>
        </ns2:input>
    </ns2:Pagar>
};

local:func($OBDX_Request ,$accessToken)