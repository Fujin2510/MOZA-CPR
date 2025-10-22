xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "SmsWS.wsdl" ::)
declare namespace ns2="http://www.mozabank.org/OBDX/SMS";
(:: import schema at "SmsDispatch.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:enviarSmsResponse) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:enviarSmsResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:result>
                <ns2:status>{if(fn:data($Response/return/smsStatus/codigo) = '0')then  'SUCCESS' else 'FAILURE'}</ns2:status>
            </ns2:result>
            <ns2:recipient>{fn:data($Response/return/smssEnviadas/destinatario)}</ns2:recipient>
            <ns2:uniqueMsgId>{fn:data($Response/return/smssEnviadas/idMensagem)}</ns2:uniqueMsgId>
        </ns2:data>
    </ns2:Response>
};

local:func($Response)