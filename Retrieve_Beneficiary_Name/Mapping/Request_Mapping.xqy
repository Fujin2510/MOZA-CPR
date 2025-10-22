xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../Schema/TFCM.wsdl" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/DW_TFCM_BENE_NAME";
(:: import schema at "../Schema/DW_TFCM_BENE_NAME.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $accessToken as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$accessToken as xs:string) as element() (:: schema-element(ns2:getBeneficiaryName) ::) {
    <ns2:getBeneficiaryName>
        <input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
            <cellular>{fn:data($Request/ns1:phonenumber)}</cellular>
            <wallet>{fn:data($Request/ns1:mobWalletCode)}</wallet>
        </input>
    </ns2:getBeneficiaryName>
};

local:func($Request, $accessToken)