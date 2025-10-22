xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/JueJueWS.wsdl" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/JueEntityPayment";
(:: import schema at "../XSD/JueEntityPayment.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare variable $accessToken as xs:string external;
declare variable $user as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$accessToken as xs:string,$user as xs:string) as element() (:: schema-element(ns2:Pagar) ::) {
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
            <conta>{fn:data($Request/ns1:accountNumber)}</conta>
            <entidade>{fn:data($Request/ns1:entityCode)}</entidade>
            <referencia>{fn:data($Request/ns1:paymentReference)}</referencia>
            <user>{$user}</user>
            <valor>{fn:data($Request/ns1:amount)}</valor>
        </ns2:input>
    </ns2:Pagar>
};

local:func($Request, $accessToken,$user)