xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://msb.mozabanco.co.mz";
(:: import schema at "../Schema/CompraRecargaOperadora.wsdl" ::)
declare namespace ns2 = "http://www.mozabanca.org/obdx/OPERATOR_LIST";
(:: import schema at "../Schema/OPERATOR_LIST.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:ConsultaOperadoraResponse) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:ConsultaOperadoraResponse) ::)) 
  as element() (:: schema-element(ns2:Response) ::) {

  <ns2:Response>
    <ns2:data>
        <ns2:dictionaryArray/>
    <ns2:referenceNo/>
    <ns2:result>
      <ns2:dictionaryArray/>
      <ns2:externalReferenceId/>
      <ns2:status>{
        if (fn:data($Response/ns1:response/status/codigo) = 0) 
        then 'SUCCESS' 
        else 'FAILURE'
      }</ns2:status>
      
      {
        if (fn:data($Response/ns1:response/status/codigo) != 0) then (
          <ns2:errorList>
            <ns2:code>ERR001</ns2:code>
            <ns2:message>Invalid backend response</ns2:message>
          </ns2:errorList>
        ) else ()
      }

      <ns2:warningList/>
    </ns2:result>
    <ns2:hasMore/>
    <ns2:totalRecords/>
    <ns2:startSequence/>

    {
      for $op in $Response/ns1:response/operadoras
      return
        <ns2:operatorList>
          <ns2:dictionaryArray/>
          <ns2:operatorCode>{fn:data($op/codigo)}</ns2:operatorCode>
          <ns2:operatorName>{fn:data($op/nome)}</ns2:operatorName>
        </ns2:operatorList>
    }
    </ns2:data>
   

  </ns2:Response>
};

local:func($Response)