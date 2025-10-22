xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/TFCM%201.wsdl" ::)
declare namespace ns1="http://www.mozabank.org/DW_TFCM_TRANSFER";
(:: import schema at "../XSD/dw_tfcm_transfer.xsd" ::)
declare variable $accessToken as xs:string external;
declare variable $partyIdVar as xs:string external;

declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $counter as xs:int external;
declare function local:func($OBDX_Request as element() (:: schema-element(ns1:Request) ::),$accessToken as xs:string,$counter,$partyIdVar) as element() (:: schema-element(ns2:performSingleTransfer) ::) {
    <ns2:performSingleTransfer>
        <input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
            <accountNumber>{fn:data($OBDX_Request/ns1:transfers[$counter]/ns1:accountId)}</accountNumber>
            <amount>{fn:data($OBDX_Request/ns1:transfers[$counter]/ns1:amount)}</amount>
            <cellular>{fn:data($OBDX_Request/ns1:transfers[$counter]/ns1:beneMobNumber)}</cellular>
            <currency>{fn:data($OBDX_Request/ns1:transfers[$counter]/ns1:currency)}</currency>
            <description>{fn:data($OBDX_Request/ns1:transfers[$counter]/ns1:description)}</description>
            <user>{$partyIdVar}</user>
            <wallet>{fn:data($OBDX_Request/ns1:transfers[$counter]/ns1:mobWalletCode)}</wallet>
        </input>
    </ns2:performSingleTransfer>
};

local:func($OBDX_Request ,$accessToken,$counter,$partyIdVar)