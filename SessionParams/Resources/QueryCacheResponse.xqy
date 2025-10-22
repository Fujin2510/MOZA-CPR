xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://xmlns.oracle.com/pcbpel/adapter/db/top/Query_Cauching";
(:: import schema at "Query_Cauching_table.xsd" ::)

declare variable $QueryCacheResp as element() (:: schema-element(ns1:OverviewWidgetCollection) ::) external;

declare function local:func($QueryCacheResp as element() (:: schema-element(ns1:OverviewWidgetCollection) ::)) as element() (:: schema-element(ns1:OverviewWidgetCollection) ::) {
    <ns1:OverviewWidgetCollection>
        <ns1:OverviewWidget>
            <ns1:sessionid>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:sessionid)}</ns1:sessionid>
            
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:status and fn:normalize-space($QueryCacheResp/ns1:OverviewWidget/ns1:status) = 'SUCCESS')
                then <ns1:status>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:status)}</ns1:status>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:eventtimestamp)
                then <ns1:eventtimestamp>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:eventtimestamp)}</ns1:eventtimestamp>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:partyid)
                then <ns1:partyid>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:partyid)}</ns1:partyid>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:partyCasaAccountsListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:partyCasaAccountsListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:partyCasaAccountsListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:partyCasaAccountsListResponse)}</ns1:partyCasaAccountsListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:partyTdAccountsListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:partyTdAccountsListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:partyTdAccountsListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:partyTdAccountsListResponse)}</ns1:partyTdAccountsListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:casaListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:casaListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:casaListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:casaListResponse)}</ns1:casaListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:partyLoanAccountsListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:partyLoanAccountsListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:partyLoanAccountsListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:partyLoanAccountsListResponse)}</ns1:partyLoanAccountsListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:tdListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:tdListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:tdListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:tdListResponse)}</ns1:tdListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:loanAccountListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:loanAccountListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:loanAccountListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:loanAccountListResponse)}</ns1:loanAccountListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:partyCardAccountsListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:partyCardAccountsListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:partyCardAccountsListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:partyCardAccountsListResponse)}</ns1:partyCardAccountsListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:creditCardReadResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:creditCardReadResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:creditCardReadResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:creditCardReadResponse)}</ns1:creditCardReadResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:debitCardListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:debitCardListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:debitCardListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:debitCardListResponse)}</ns1:debitCardListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:readPartyResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:readPartyResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:readPartyResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:readPartyResponse)}</ns1:readPartyResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:casaAccountPartiesResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:casaAccountPartiesResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:casaAccountPartiesResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:casaAccountPartiesResponse)}</ns1:casaAccountPartiesResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:casaStatementItemListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:casaStatementItemListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:casaStatementItemListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:casaStatementItemListResponse)}</ns1:casaStatementItemListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:loanAccountPartiesResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:loanAccountPartiesResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:loanAccountPartiesResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:loanAccountPartiesResponse)}</ns1:loanAccountPartiesResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:loanDetailsResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:loanDetailsResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:loanDetailsResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:loanDetailsResponse)}</ns1:loanDetailsResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:id)
                then <ns1:id>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:id)}</ns1:id>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:partyAddressListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:partyAddressListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:partyAddressListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:partyAddressListResponse)}</ns1:partyAddressListResponse>
                else ()
            }
            {
                if ($QueryCacheResp/ns1:OverviewWidget/ns1:partyContactsListResponse 
                    and substring(substring-after($QueryCacheResp/ns1:OverviewWidget/ns1:partyContactsListResponse,'status>'),1,7) = 'SUCCESS')
                then <ns1:partyContactsListResponse>{fn:data($QueryCacheResp/ns1:OverviewWidget/ns1:partyContactsListResponse)}</ns1:partyContactsListResponse>
                else ()
            }
        </ns1:OverviewWidget>
    </ns1:OverviewWidgetCollection>
};

local:func($QueryCacheResp)