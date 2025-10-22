xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/TFCM%201.wsdl" ::)
declare namespace ns1="http://www.mozabank.org/DW_TFCM_TXN_COST";
(:: import schema at "../XSD/dw_tfcm_txn_cost.xsd" ::)
declare variable $accessToken as xs:string external;

declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($OBDX_Request as element() (:: schema-element(ns1:Request) ::),$accessToken as xs:string) as element() (:: schema-element(ns2:getTransactionCost) ::) {
    <ns2:getTransactionCost>
        <input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
            <amount>{fn:data($OBDX_Request/ns1:amount)}</amount>
        </input>
    </ns2:getTransactionCost>
};

local:func($OBDX_Request ,$accessToken)