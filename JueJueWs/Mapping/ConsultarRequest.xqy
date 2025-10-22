xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/JueJueWS.wsdl" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/JueEntityList";
(:: import schema at "../XSD/JueEntityList.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $accessToken as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$accessToken) as element() (:: schema-element(ns2:ConsultarEntidades) ::) {
    <ns2:ConsultarEntidades>
        <ns2:input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
        </ns2:input>
    </ns2:ConsultarEntidades>
};

local:func($Request,$accessToken)