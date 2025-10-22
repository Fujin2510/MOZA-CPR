xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://msb.mozabanco.co.mz";
(:: import schema at "ExtractosWs.wsdl" ::)

declare variable $accessToken as xs:string external;
declare variable $STMTMonth as xs:string external;
declare variable $STMTYear as xs:string external;
declare variable $CC_STMT_RESP as element() (:: schema-element(ns1:ConsultarExtractosResponse) ::) external;

declare function local:func(
  $accessToken as xs:string,
  $STMTMonth as xs:string,
  $STMTYear as xs:string,
  $CC_STMT_RESP as element() (:: schema-element(ns1:ConsultarExtractosResponse) ::)
) as element() (:: schema-element(ns1:EmitirExtractos) ::) {
    <ns1:EmitirExtractos>
        <ns1:input>
            <chaveConfirmacao>
                <chave/>
                <posicoes/>
            </chaveConfirmacao>
            <sessao>
                <id>{fn:data($accessToken)}</id>
                <versao/>
            </sessao>
            {
              for $CCSTMT in $CC_STMT_RESP/ns1:output/extractos/extracto
              let $dataExtracto := fn:string($CCSTMT/dataExtracto)
              let $month := substring($dataExtracto, 6, 2)
              let $year := substring($dataExtracto, 1, 4)
              where $month = $STMTMonth
                and $year = $STMTYear
              return (
                  <nomeExtOriginal>{fn:string($CCSTMT/nomeExtOriginal)}</nomeExtOriginal>,
                  <nomeFichOriginal>{fn:string($CCSTMT/nomeFichOriginal)}</nomeFichOriginal>
              )
            }
        </ns1:input>
    </ns1:EmitirExtractos>
};

local:func($accessToken,$STMTMonth,$STMTYear,$CC_STMT_RESP)