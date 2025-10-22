xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/ReadParty";
(:: import schema at "ReadParty.xsd" ::)
declare namespace ns1="http://www.mozabank.org/nxsd/REST";
(:: import schema at "SchemaRest.xsd" ::)

declare variable $ReadPartyResp as element() (:: schema-element(ns1:Request) ::) external;
declare variable $partyId as xs:string external;
declare function local:func($ReadPartyResp as element() (:: schema-element(ns1:Request) ::),$partyId as xs:string) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response> 
        <ns2:data>  
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
            <ns2:status>{if(fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:status/ns1:codigo) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>
             {if(fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:status/ns1:codigo) = '0') then () else(
            <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>)
            
            }
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore>false</ns2:hasMore>
        <ns2:totalRecords>0</ns2:totalRecords>
        <ns2:startSequence>0</ns2:startSequence>
        <ns2:personalInfo>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:salutation></ns2:salutation>
            <ns2:gender></ns2:gender>
            <ns2:firstName>
                {fn:tokenize(fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:nomEntidade), ' ')[1]}
            </ns2:firstName>

            <ns2:middleName>
              {
               let $tokens := fn:tokenize(fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:nomEntidade), ' ')
                return
                if (fn:count($tokens) > 2) then
                fn:string-join($tokens[position() > 1 and position() < fn:count($tokens)], ' ')
                 else ''
              }
            </ns2:middleName>

            <ns2:lastName>
           {
            let $tokens := fn:tokenize(fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:nomEntidade), ' ')
            return $tokens[fn:count($tokens)]
           }
          </ns2:lastName>
            <ns2:maritalStatus></ns2:maritalStatus>
            <ns2:birthDate>
{let $date := fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:datNascimento) 
return 
if($date != '') then concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00') else()}
          </ns2:birthDate>
            <ns2:email>{fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:email1)}</ns2:email>
               <ns2:fullName>
{
  let $sexo := fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:sexo)
  let $prefix :=
    if ($sexo = 'M') then 'Mr. '
    else if ($sexo = 'F') then 'Ms. '
    else ''
  return concat($prefix, fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:nomEntidade))
}
</ns2:fullName>
            <ns2:partyType></ns2:partyType>
            <ns2:addressInfo>
                <ns2:line1>{fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:morada)}</ns2:line1>
                <ns2:line2>{fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:morada2)}</ns2:line2>
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
                <ns2:city>{fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:desPostal)}</ns2:city>
                <ns2:addressTypeDescription>RES</ns2:addressTypeDescription>
                <ns2:state></ns2:state>
                <ns2:country>MZ</ns2:country>
                <ns2:zipCode>{fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:codPostal)}</ns2:zipCode>
            </ns2:addressInfo>
        </ns2:personalInfo> 
		 <ns2:contactInfo>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:isEmailCommunicationAllowed></ns2:isEmailCommunicationAllowed>
            <ns2:preferredModeOfCommunication></ns2:preferredModeOfCommunication>
            <ns2:contactType>WMO</ns2:contactType> 
            <ns2:phone>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:areaCode></ns2:areaCode>
                <ns2:number>{fn:data($ReadPartyResp/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:telefone1)}</ns2:number>
                <ns2:extension></ns2:extension>
            </ns2:phone>  
            <ns2:fax></ns2:fax>
			<ns2:email/>
        </ns2:contactInfo>
        <ns2:partyId>{$partyId}</ns2:partyId>
        <ns2:location></ns2:location>
        <ns2:liabCCY></ns2:liabCCY>
        <ns2:shortName></ns2:shortName>
        <ns2:branch></ns2:branch>
      </ns2:data>
    </ns2:Response>
};

local:func($ReadPartyResp,$partyId)