xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/servicebus/querycached";
(:: import schema at "InsertCacheService.xsd" ::)
declare namespace ns2="http://xmlns.oracle.com/pcbpel/adapter/db/top/InsertCachePayloadBS";
(:: import schema at "InsertCachePayloadBS_table.xsd" ::)

declare variable $Req as element() (:: schema-element(ns1:InsertCachedRequest) ::) external;

declare function local:func($Req as element() (:: schema-element(ns1:InsertCachedRequest) ::)) as element() (:: schema-element(ns2:OverviewWidgetCollection) ::) {
    <ns2:OverviewWidgetCollection>
        <ns2:OverviewWidget>
            <ns2:sessionid>{fn:data($Req/ns1:Session_Id)}</ns2:sessionid>
            {
                if ($Req/ns1:Status)
                then <ns2:status>{fn:data($Req/ns1:Status)}</ns2:status>
                else ()
            }
   <ns2:eventtimestamp>{fn:current-dateTime()}</ns2:eventtimestamp>
            {
                if ($Req/ns1:PartyID)
                then <ns2:partyid>{fn:data($Req/ns1:PartyID)}</ns2:partyid>
                else ()
            }
            {
                if ($Req/ns1:PartyCasaAccountsList_Response)
                then <ns2:partyCasaAccountsListResponse>{fn:data($Req/ns1:PartyCasaAccountsList_Response)}</ns2:partyCasaAccountsListResponse>
                else ()
            }
            {
                if ($Req/ns1:PartyTdAccountsList_Response)
                then <ns2:partyTdAccountsListResponse>{fn:data($Req/ns1:PartyTdAccountsList_Response)}</ns2:partyTdAccountsListResponse>
                else ()
            }
            {
                if ($Req/ns1:CasaList_Response)
                then <ns2:casaListResponse>{fn:data($Req/ns1:CasaList_Response)}</ns2:casaListResponse>
                else ()
            }
            {
                if ($Req/ns1:PartyLoanAccountsList_Response)
                then <ns2:partyLoanAccountsListResponse>{fn:data($Req/ns1:PartyLoanAccountsList_Response)}</ns2:partyLoanAccountsListResponse>
                else ()
            }
            {
                if ($Req/ns1:TDList_Response)
                then <ns2:tdListResponse>{fn:data($Req/ns1:TDList_Response)}</ns2:tdListResponse>
                else ()
            }
            {
                if ($Req/ns1:LoanAccountList_Response)
                then <ns2:loanAccountListResponse>{fn:data($Req/ns1:LoanAccountList_Response)}</ns2:loanAccountListResponse>
                else ()
            }
            {
                if ($Req/ns1:PartyCardAccountsList_Response)
                then <ns2:partyCardAccountsListResponse>{fn:data($Req/ns1:PartyCardAccountsList_Response)}</ns2:partyCardAccountsListResponse>
                else ()
            }
            {
                if ($Req/ns1:CreditCardRead_Response)
                then <ns2:creditCardReadResponse>{fn:data($Req/ns1:CreditCardRead_Response)}</ns2:creditCardReadResponse>
                else ()
            }
            {
                if ($Req/ns1:DebitCardListRead_Response)
                then <ns2:debitCardListResponse>{fn:data($Req/ns1:DebitCardListRead_Response)}</ns2:debitCardListResponse>
                else ()
            }
            {
                if ($Req/ns1:ReadParty_Response)
                then <ns2:readPartyResponse>{fn:data($Req/ns1:ReadParty_Response)}</ns2:readPartyResponse>
                else ()
            }
            {
                if ($Req/ns1:CasaAccountParties_Response)
                then <ns2:casaAccountPartiesResponse>{fn:data($Req/ns1:CasaAccountParties_Response)}</ns2:casaAccountPartiesResponse>
                else ()
            }
            {
                if ($Req/ns1:CasaStatementItemList_Response)
                then <ns2:casaStatementItemListResponse>{fn:data($Req/ns1:CasaStatementItemList_Response)}</ns2:casaStatementItemListResponse>
                else ()
            }
            {
                if ($Req/ns1:LoanAccountParties_Response)
                then <ns2:loanAccountPartiesResponse>{fn:data($Req/ns1:LoanAccountParties_Response)}</ns2:loanAccountPartiesResponse>
                else ()
            }
            {
                if ($Req/ns1:LoanDetails_Response)
                then <ns2:loanDetailsResponse>{fn:data($Req/ns1:LoanDetails_Response)}</ns2:loanDetailsResponse>
                else ()
            }
            {
                if ($Req/ns1:ID)
                then <ns2:id>{fn:data($Req/ns1:ID)}</ns2:id>
                else ()
            }
            {
                if ($Req/ns1:PartyAddressList_Response)
                then <ns2:partyAddressListResponse>{fn:data($Req/ns1:PartyAddressList_Response)}</ns2:partyAddressListResponse>
                else ()
            }
            {
                if ($Req/ns1:PartyContactsList_Response)
                then <ns2:partyContactsListResponse>{fn:data($Req/ns1:PartyContactsList_Response)}</ns2:partyContactsListResponse>
                else ()
            }
        </ns2:OverviewWidget>
    </ns2:OverviewWidgetCollection>
};

local:func($Req)