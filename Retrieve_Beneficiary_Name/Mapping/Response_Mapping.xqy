xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://msb.mozabanco.co.mz";
(:: import schema at "../Schema/TFCM.wsdl" ::)
declare namespace ns2 = "http://www.mozabanca.org/obdx/DW_TFCM_BENE_NAME";
(:: import schema at "../Schema/DW_TFCM_BENE_NAME.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:getBeneficiaryNameResponse) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:getBeneficiaryNameResponse) ::)) 
  as element() (:: schema-element(ns2:Response) ::) {

  let $statusCode := xs:string(fn:data($Response/ns1:response/status/codigo))
  let $detailCode := normalize-space($Response/ns1:response/status/detalhes/detalhe/codigo)
  let $detailMsg  := normalize-space($Response/ns1:response/status/detalhes/detalhe/mensagem)
  let $errMsg     := normalize-space($Response/ns1:response/status/mensagens)
let $errCode := if (string-length($detailCode) > 0) then $detailCode else ()

  return
    <ns2:Response>
      <ns2:data>
        <ns2:dictionaryArray/>
        <ns2:referenceNo/>
        <ns2:result>
          <ns2:dictionaryArray/>
          <ns2:externalReferenceId/>

<ns2:status>
{
  if ($statusCode = '0' or $statusCode = 'P' or $statusCode = 'B') 
  then 'SUCCESS' 
  else 'FAILURE'
}
</ns2:status>

          {
  if ($statusCode = '0') then ()
  
  else
  <ns2:errorList>
<ns2:code>
{
  if (string-length($detailCode) > 0) 
  then dvm:lookup(
         'CommonErrorHandlerService/ErrorCodes.dvm',
         'MSBCode',
         $detailCode,
         'ErrorCode',
         $detailCode
       )
  else ()
}
</ns2:code>

    <ns2:message>
      {
        if (string-length($detailCode) > 0) then
          dvm:lookup(
            'CommonErrorHandlerService/ErrorCodes.dvm',
            'MSBCode',
            $detailCode,
            'ErrorMessageEN',
            "Invalid backend response"
          )
        else if (string-length($errMsg) > 0) then
          $errMsg              (: original message from backend :)
        else
          "Invalid backend response"
      }
    </ns2:message>
  </ns2:errorList>

}


          <ns2:warningList/>
        </ns2:result>
        
        <ns2:hasMore/>
        <ns2:totalRecords/>
        <ns2:startSequence/>
        <ns2:BeneMobNumber>{ fn:data($Response/ns1:response/cellular) }</ns2:BeneMobNumber>
        <ns2:mobWalletCode>{ fn:data($Response/ns1:response/walletID) }</ns2:mobWalletCode>
        <ns2:costumerName>{ fn:data($Response/ns1:response/costumerName) }</ns2:costumerName>
      </ns2:data>
    </ns2:Response>
};

local:func($Response)