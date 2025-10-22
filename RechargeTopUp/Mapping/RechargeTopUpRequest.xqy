xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/CompraRecargaOperadora.wsdl" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/operator_recharge";
(:: import schema at "../XSD/OPERATOR_RECHARGE.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare variable $accessToken as xs:string external;
declare variable $userIdVar as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$accessToken as xs:string,$userIdVar as xs:string) as element() (:: schema-element(ns2:ComprarRecarga) ::) {
    <ns2:ComprarRecarga>
        <arg0>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
            <codigoOperadora>{fn:data($Request/ns1:operatorCode)}</codigoOperadora>
            <moeda>{fn:data($Request/ns1:currency)}</moeda>
            <montante>{xs:string(fn:data($Request/ns1:amount))}</montante>
            <numeroConta>{fn:data($Request/ns1:accountNumber)}</numeroConta>
            <numeroTelefone>{fn:data($Request/ns1:phoneNumber)}</numeroTelefone>
            <user>{ $userIdVar }</user>
        </arg0>
    </ns2:ComprarRecarga>
};

local:func($Request , $accessToken, $userIdVar)