xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/JueJueWS.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/JueEntityList";
(:: import schema at "../XSD/JueEntityList.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:ConsultarEntidadesResponse) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:ConsultarEntidadesResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                        <ns2:status>{if(fn:data($Response/ns1:output/status/codigo) = 0)
                then 'SUCCESS' else 'FAILURE'}</ns2:status>
{if(fn:data($Response/ns1:output/status/codigo) = 0) then () else(
            <ns2:errorList>
                <ns2:code></ns2:code>
                <ns2:message></ns2:message>
            </ns2:errorList>) }          
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
                 {
        for $e in $Response/ns1:output/entidades/entidade
        return
            <ns2:entityList>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:entityCode>{fn:data($e/codEntidade)}</ns2:entityCode>
                <ns2:entityNumber>{fn:data($e/numEntidade)}</ns2:entityNumber>
                <ns2:entityDesc>{fn:data($e/nomeEntidade)}</ns2:entityDesc>
                <ns2:currencyCode>{fn:data($e/moeda)}</ns2:currencyCode>
                <ns2:accountNumber>{fn:data($e/numConta)}</ns2:accountNumber>
            </ns2:entityList>
             }
        </ns2:data>
    </ns2:Response>
};

local:func($Response)