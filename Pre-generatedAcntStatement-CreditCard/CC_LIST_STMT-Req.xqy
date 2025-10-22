xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2 = "http://msb.mozabanco.co.mz";
(:: import schema at "ExtractosWs.wsdl" ::)
declare namespace ns1 = "http://www.mozabanca.org/obdx/CC_LIST_STMT";
(:: import schema at "CC_LIST_STMT_OBDX.xsd" ::)

declare variable $accessToken as xs:string external;
declare variable $accid as xs:string external;
declare variable $CC_LIST_STMT_Req as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func(
    $accessToken as xs:string,
    $accid as xs:string
   
) as element() (:: schema-element(ns2:ConsultarExtractos) ::) {
    <ns2:ConsultarExtractos>
        <ns2:input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{fn:data($accessToken)}</id>
                <versao></versao>
            </sessao>
            <dataExtracto></dataExtracto>
            <nomeExtOrigPag></nomeExtOrigPag>
            <nomeExtOriginal></nomeExtOriginal>
            <nomeFichOrigPag></nomeFichOrigPag>
            <nomeFichOriginal></nomeFichOriginal>
            <numCliente></numCliente>
            <numContaCartao>{fn:data($accid)}</numContaCartao>
            <numExtracto></numExtracto>
        </ns2:input>
    </ns2:ConsultarExtractos>
};

local:func($accessToken, $accid)