xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../XSDs/ConsultarEntidade.wsdl" ::)
declare namespace ns1="http://www.mozabank.org/PASI_ENTITY_LIST";
(:: import schema at "../XSDs/PASI_ENTITY_LIST.xsd" ::)

declare variable $accessToken as xs:string external;


declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;


declare function local:func($OBDX_Request as element() (:: schema-element(ns1:Request) ::),$accessToken as xs:string) as element() (:: schema-element(ns2:ConsultarEntidade) ::) {

    <ns2:ConsultarEntidade>
        <input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
        </input>
    </ns2:ConsultarEntidade>
};

local:func($OBDX_Request,$accessToken )