xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "PagamentoFicheirosWs.wsdl" ::)
declare namespace ns1="http://www.mozabanca.org/bulkTranser";
(:: import schema at "Bulk_Transfer.xsd" ::)
declare variable $partyIdVar as xs:string external;
declare variable $accessToken as xs:string external;
declare variable $OBDX_Request as element() (:: schema-element(ns1:BulkStatusSyncRequest) ::) external;

declare function local:func($OBDX_Request as element() (:: schema-element(ns1:BulkStatusSyncRequest) ::),$partyIdVar ,$accessToken as xs:string) as element() (:: schema-element(ns2:ConsultarFicheiroFornecedorAceite) ::) {
    <ns2:ConsultarFicheiroFornecedorAceite>
        <input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
            <dataProcessamento> {
                concat(
                  substring(fn:data($OBDX_Request/ns1:valueDate/ns1:dateString), 1, 4), "-",  (: Year :)
                  substring(fn:data($OBDX_Request/ns1:valueDate/ns1:dateString), 5, 2), "-",  (: Month :)
                  substring(fn:data($OBDX_Request/ns1:valueDate/ns1:dateString), 7, 2)       (: Day :)
                )
              }</dataProcessamento>
            <numCliente>{fn:data($OBDX_Request/ns1:clientNumber)}</numCliente>
            <numFicheiro>{fn:data($OBDX_Request/ns1:externalFileRefId)}</numFicheiro>
            <username>INTUSR01</username>
        </input>
    </ns2:ConsultarFicheiroFornecedorAceite>
};

local:func($OBDX_Request , $partyIdVar, $accessToken)