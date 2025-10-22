xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "Organicas.wsdl" ::)
declare namespace ns1="http://www.mozabank.org/ccdo_branch_list";
(:: import schema at "../XSD/BRANCH_LIST.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $sessionIdVar as xs:string external;
declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$sessionIdVar) as element() (:: schema-element(ns2:ConsultarUnidadesNegocioRetalho) ::) {
    <ns2:ConsultarUnidadesNegocioRetalho>
        <input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$sessionIdVar}</id>
                <versao></versao>
            </sessao>
            <codBalcao>{fn:data($Request/ns1:branchId)}</codBalcao>
        </input>
    </ns2:ConsultarUnidadesNegocioRetalho>
};

local:func($Request,$sessionIdVar)