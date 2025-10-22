xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../XSDs/ConsultarEntidade.wsdl" ::)
declare namespace ns2="http://www.mozabank.org/PASI_ENTITY_LIST";
(:: import schema at "../XSDs/PASI_ENTITY_LIST.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:ConsultarEntidadeResponse) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:ConsultarEntidadeResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
           <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
            <ns2:status>{if (fn:data($MSB_Response/ns1:response/status/codigo) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>
            <ns2:errorList></ns2:errorList>
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
		
	  	{
      for $op in $MSB_Response/ns1:response/entidades/entidade
      return
		
       <ns2:entityList>
           
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:entityCode>{fn:data($op/codEntidade)}</ns2:entityCode>
                <ns2:entityName>{fn:data($op/nomeEntidade)}</ns2:entityName>
        </ns2:entityList>
		}
        </ns2:data>
        
    </ns2:Response>
};

local:func($MSB_Response)