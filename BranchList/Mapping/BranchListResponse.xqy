xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://msb.mozabanco.co.mz";
(:: import schema at "../Xsd/BranchList.wsdl" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/branch_list";
(:: import schema at "../Xsd/BranchList.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:ConsultarUnidadesNegocioRetalhoResponse) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:ConsultarUnidadesNegocioRetalhoResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
<ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
       <ns2:status>  {if (fn:data($Response/ns1:output/status/codigo) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>                
            {if(fn:data($Response/ns1:output/status/codigo) = 0) then () else(
            <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>) } 
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
             {
  for $tx in $Response/ns1:output/unidadesNegocio/unidadeNegocio
  return
        <ns2:branchList>
          
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:branchId>{fn:data($tx/codigo)}</ns2:branchId>
            <ns2:branchName>{fn:data($tx/nome)}</ns2:branchName>
            <ns2:bankId></ns2:bankId>
            <ns2:localCurrency></ns2:localCurrency>
            <ns2:address>
             <ns2:line1>
{
  fn:normalize-space(
    substring-before(
      fn:data($tx/morada),
      ','
    )
  )
}
</ns2:line1> 
    <!-- <ns2:line1>Address has special characters. Will be handled by Oracle</ns2:line1>-->
<ns2:line2>
{
    replace(fn:normalize-space(
    substring-after(
      fn:data($tx/morada),
      ','
    )
  ),'º','')
}
</ns2:line2> 
<!--<ns2:line2>Address has special characters. Will be handled by Oracle</ns2:line2>-->
                <ns2:line3></ns2:line3>
                <ns2:line4></ns2:line4>
                <ns2:line5></ns2:line5>
                <ns2:line6></ns2:line6>
                <ns2:line7></ns2:line7>
                <ns2:line8></ns2:line8>
                <ns2:line9></ns2:line9>
                <ns2:line10></ns2:line10>
                <ns2:line11></ns2:line11>
                <ns2:line12></ns2:line12>
                <ns2:city>MZ</ns2:city>
                <ns2:addressTypeDescription>{fn:data($tx/modelo)}</ns2:addressTypeDescription>
                <ns2:state></ns2:state>
                <ns2:country>MZ</ns2:country>
                <ns2:zipCode></ns2:zipCode>
            </ns2:address>
            
        </ns2:branchList>
        }
</ns2:data>
    </ns2:Response>
};

local:func($Response)