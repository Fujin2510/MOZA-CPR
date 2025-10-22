xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2 = "http://msb.mozabanco.co.mz";
(:: import schema at "../XSD/TFCM%201.wsdl" ::)

declare namespace ns1 = "http://www.mozabank.org/DW_TFCM_TRANSFER";
(:: import schema at "../XSD/dw_tfcm_transfer.xsd" ::)

declare variable $accessToken as xs:string external;
declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;

(:-----------------------------------------------------:)
(: Function to build a single performSingleTransfer request :)
declare function local:buildSingleRequest(
  $transfer as element(ns1:transfer),
  $accessToken as xs:string
) as element(ns2:performSingleTransfer) {
  <ns2:performSingleTransfer>
    <input>
      <chaveConfirmacao>
        <chave/>
        <posicoes/>
      </chaveConfirmacao>
      <sessao>
        <id>{$accessToken}</id>
        <versao/>
      </sessao>
      <accountNumber>{fn:data($transfer/ns1:accountId)}</accountNumber>
      <amount>{fn:data($transfer/ns1:amount)}</amount>
      <cellular>{fn:data($transfer/ns1:beneMobNumber)}</cellular>
      <currency>{fn:data($transfer/ns1:currency)}</currency>
      <description>{fn:data($transfer/ns1:description)}</description>
      <user/>
      <wallet>{fn:data($transfer/ns1:mobWalletCode)}</wallet>
    </input>
  </ns2:performSingleTransfer>
};

(:-----------------------------------------------------:)
(: Main construction loop for AllRequests :)

<AllRequests xmlns:ns2="http://msb.mozabanco.co.mz">
  {
    for $t in $OBDX_Request/ns1:transfers/ns1:transfer
    return local:buildSingleRequest($t, $accessToken)
  }
</AllRequests>