xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "SmsWS.wsdl" ::)
declare namespace ns1="http://www.mozabank.org/OBDX/SMS";
(:: import schema at "SmsDispatch.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $Token as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$Token as xs:string) as element() (:: schema-element(ns2:enviarSms) ::) {
    <ns2:enviarSms>
        <arg0>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$Token}</id>
                <versao></versao>
            </sessao>
            <destinatario>{fn:data($Request/ns1:recipient)}</destinatario>
            <mensagem>{fn:data($Request/ns1:messageContent)}</mensagem>
            <relEntrega>{fn:data($Request/ns1:deliveryReportRequestFlag)}</relEntrega>
        </arg0>
    </ns2:enviarSms>
};

local:func($Request,$Token)