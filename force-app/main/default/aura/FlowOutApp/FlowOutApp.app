<aura:application access="GLOBAL" extends="ltng:outApp"
    implements="ltng:allowGuestAccess">

    <aura:dependency resource="lightning:flow" />
    <aura:dependency resource="c:storeLocatorMain"/>

    <aura:attribute name="staticResourceUrl" type="String" default="{!$Resource.cf_logo_greyscale}"/>

    <div>
        <img src="{!$Resource.cf_logo_greyscale}" alt="Logo"/>
    </div>

    <aura:handler name="init" value="{!this}" action="{!c.init}" />
</aura:application>