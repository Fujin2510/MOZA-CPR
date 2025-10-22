xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../Xsd/BranchList.wsdl" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/branch_list";
(:: import schema at "../Xsd/BranchList.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $accessToken as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$accessToken as xs:string) as element() (:: schema-element(ns2:ConsultarUnidadesNegocioRetalho) ::) {
    <ns2:ConsultarUnidadesNegocioRetalho>
        <input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
            <codBalcao>{fn:data($Request/ns1:branchId)}</codBalcao>
        </input>
    </ns2:ConsultarUnidadesNegocioRetalho>
};

local:func($Request,$accessToken)