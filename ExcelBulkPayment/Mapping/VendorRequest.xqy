xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://msb.mozabanco.co.mz";
(:: import schema at "../XSDs/PagamentoFicheiros.wsdl" ::)
declare namespace ns1="http://www.mozabanca.org/excelBulk";
(:: import schema at "../XSDs/ExcelBulkPayment.xsd" ::)

declare variable $partyIdVar as xs:string external;
declare variable $accessToken as xs:string external;
declare variable $OBDX_Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($OBDX_Request as element() (:: schema-element(ns1:Request) ::),$accessToken ,$partyIdVar as xs:string) as element() (:: schema-element(ns2:CarregarFicheiroFornecedor) ::) {
    <ns2:CarregarFicheiroFornecedor>
        <input>
            <chaveConfirmacao>
                <chave></chave>
                <posicoes></posicoes>
            </chaveConfirmacao>
            <sessao>
                <id>{$accessToken}</id>
                <versao></versao>
            </sessao>
            <contaPrincipal>{fn:data($OBDX_Request/ns1:debitAccountNumber)}</contaPrincipal>
           <dataProcEfectivo>
  {
    concat(
      substring(fn:data($OBDX_Request/ns1:valueDate/ns1:dateString), 1, 4), "-",  (: Year :)
      substring(fn:data($OBDX_Request/ns1:valueDate/ns1:dateString), 5, 2), "-",  (: Month :)
      substring(fn:data($OBDX_Request/ns1:valueDate/ns1:dateString), 7, 2)       (: Day :)
    )
  }
</dataProcEfectivo>


            <formato>{fn:data($OBDX_Request/ns1:fileFormatType)}</formato>
           <importanciaTotal>
  { fn-bea:format-number(xs:decimal(fn:data($OBDX_Request/ns1:totalAmount)) * 100, "0.00") }
</importanciaTotal>

            <indCancela>{fn:data($OBDX_Request/ns1:cancellationIndicator)}</indCancela>
            <indContinua>{fn:data($OBDX_Request/ns1:continueProcessingIndicator)}</indContinua>
            <nomeOriginal>{fn:data($OBDX_Request/ns1:fileName)}</nomeOriginal>
            <nomeOriginalAut>{fn:data($OBDX_Request/ns1:authFileName)}</nomeOriginalAut>
            <strFicheiroB64Aut>{fn:data($OBDX_Request/ns1:fileB64Auth)}</strFicheiroB64Aut>
            <strFicheiroB64Orig>{fn:data($OBDX_Request/ns1:fileContentBase64)}</strFicheiroB64Orig>
            <totalRegistos>{fn:data($OBDX_Request/ns1:totalRecords)}</totalRegistos>
            <username>INTUSR01</username>
        </input>
    </ns2:CarregarFicheiroFornecedor>
};

local:func($OBDX_Request,$accessToken,$partyIdVar)