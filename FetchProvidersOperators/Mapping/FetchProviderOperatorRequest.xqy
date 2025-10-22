xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../Schema/CompraRecargaOperadora.wsdl" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/OPERATOR_LIST";
(:: import schema at "../Schema/OPERATOR_LIST.xsd" ::)


declare variable $FetchProviderOperatorRequest as element() (:: schema-element(ns1:Request) ::) external;
declare variable $accessToken as xs:string external;

declare function local:func($FetchProviderOperatorRequest as element() (:: schema-element(ns1:Request) ::),$accessToken as xs:string) as element() (:: schema-element(ns2:ConsultaOperadora) ::) {
    <ns2:ConsultaOperadora>
        <arg0>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
        </arg0>
    </ns2:ConsultaOperadora>
};

local:func($FetchProviderOperatorRequest , $accessToken)