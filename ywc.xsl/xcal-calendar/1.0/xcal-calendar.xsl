<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">

<xsl:function name="ywc:iCalxCal">
<xsl:param name="ical-data-raw" as="xs:string" />
    
    <xsl:variable name="ical-data" select='
            normalize-space(
                replace(
                    $ical-data-raw
                ,"&amp;","&amp;amp;")
                )'/>
    <xsl:variable name="ical-properties" select="substring-before($ical-data,' BEGIN:VEVENT')"/>
    <xsl:variable name="ical-events">
        <xsl:value-of select="concat('BEGIN:VEVENT ',substring-before(substring-after($ical-data,'BEGIN:VEVENT '),' END:VCALENDAR'))"/>
    </xsl:variable>

    <xsl:call-template name="xcal-calendar">
        <xsl:with-param name="input" select="$ical-properties"/>
        <xsl:with-param name="type" select="'calendar'"/>
        <xsl:with-param name="ical-properties-data" select="$ical-properties"/>
        <xsl:with-param name="ical-events" select="$ical-events"/>
        <xsl:with-param name="output-format" select="'xcalendar'"/>
    </xsl:call-template>

</xsl:function>

<xsl:template name="xcal-calendar">
    <xsl:param name="input"/>
    <xsl:param name="type" select="'event'"/>
    <xsl:param name="output-format" select="'xcalendar'"/>
    <xsl:param name="ical-properties-data" select="$input"/>
    <xsl:param name="ical-events" />
    <xsl:param name="remaining-event-data" select="substring-after($input, $ical-properties-data)"/>
    <xsl:choose>
        <xsl:when test="$output-format = 'xcalendar'">
            <iCalendar>
                <vcalendar>
                    <xsl:call-template name="properties">
                        <xsl:with-param name="input" select="$ical-properties-data"/>
                        <xsl:with-param name="type" select="$type"/>
                        <xsl:with-param name="output-format" select="$output-format"/>
                    </xsl:call-template>
                    <xsl:call-template name="xcal-events">
                        <xsl:with-param name="input" select="$ical-events"/>
                        <xsl:with-param name="type" select="'event'"/>
                        <xsl:with-param name="output-format" select="$output-format"/>
                    </xsl:call-template>
                </vcalendar>
            </iCalendar>
        </xsl:when>
        <xsl:when test="$output-format = 'xcalendar-encoded'">
            <code><pre>
            <xsl:text>&lt;iCalendar&gt;&#xd;</xsl:text>
            <xsl:text>&lt;vcalendar&#xd;</xsl:text>
            <xsl:call-template name="properties">
                <xsl:with-param name="input" select="$ical-properties-data"/>
                <xsl:with-param name="type" select="$type"/>
                <xsl:with-param name="output-format" select="$output-format"/>
            </xsl:call-template>
            <xsl:text>&gt;&#xd;</xsl:text>
            <xsl:call-template name="xcal-events">
                <xsl:with-param name="input" select="$ical-events"/>
                <xsl:with-param name="type" select="'event'"/>
                <xsl:with-param name="output-format" select="$output-format"/>
            </xsl:call-template>
            <xsl:text>&lt;/vcalendar&gt;&#xd;</xsl:text>
            <xsl:text>&lt;/iCalendar&gt;&#xd;</xsl:text>
            </pre></code>
        </xsl:when>
    </xsl:choose>
    <xsl:if test="$remaining-event-data != ''">
        <xsl:call-template name="xcal-calendar">
            <xsl:with-param name="input" select="$remaining-event-data"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="output-format" select="$output-format"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="xcal-events">
    <xsl:param name="input"/>
    <xsl:param name="type" select="'event'"/>
    <xsl:param name="output-format" select="'xcalendar'"/>
    <xsl:param name="ical-event-data" select="concat('BEGIN:VEVENT ',substring-before(substring-after($input,'BEGIN:VEVENT '),' END:VEVENT'),' END:VEVENT')"/>
    <xsl:param name="remaining-event-data" select="substring-after($input, $ical-event-data)"/>
    <xsl:choose>
        <xsl:when test="$output-format = 'xcalendar'">
            <vevent>
                <xsl:call-template name="properties">
                    <xsl:with-param name="input" select="$ical-event-data"/>
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="output-format" select="$output-format"/>
                </xsl:call-template>
            </vevent>
        </xsl:when>
        <xsl:when test="$output-format = 'xcalendar-encoded'">
            <xsl:text>&#x9;&lt;vevent&gt;&#xd;</xsl:text>
                <xsl:call-template name="properties">
                    <xsl:with-param name="input" select="$ical-event-data"/>
                    <xsl:with-param name="type" select="$type"/>
                    <xsl:with-param name="output-format" select="$output-format"/>
                </xsl:call-template>
            <xsl:text>&#x9;&lt;/vevent&gt;&#xd;</xsl:text>
        </xsl:when>
        <xsl:when test="$output-format = 'hcalendar'">
        </xsl:when>
    </xsl:choose>
    <xsl:if test="$remaining-event-data != ''">
        <xsl:call-template name="xcal-events">
            <xsl:with-param name="input" select="$remaining-event-data"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="output-format" select="$output-format"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="properties">
    <xsl:param name="input" />
<!--     <xsl:param name="input" select="$ical-data"/> -->
    <xsl:param name="type" select="'event'"/>
    <xsl:param name="output-format" select="'xcalendar'"/>
    <xsl:param name="property-and-attribute-caps" select="substring-before($input,':')"/>
    <xsl:param name="property-and-attribute" select="lower-case($property-and-attribute-caps)"/>
    <xsl:param name="property">
        <xsl:choose>
            <xsl:when test="contains($property-and-attribute,';')">
                <xsl:value-of select="substring-before($property-and-attribute,';')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$property-and-attribute"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="property-attribute" select="substring-after($property-and-attribute,';')"/>
    <xsl:param name="property-attribute-name" select="substring-before($property-attribute,'=')"/>
    <xsl:param name="property-attribute-value" select="substring-after($property-attribute,'=')"/>
    <xsl:param name="string-after-property" select="substring-after($input,':')"/>
    <xsl:param name="next-string" select="substring-before($string-after-property,':')"/>
    <xsl:param name="reverse-next-string">
        <xsl:call-template name="reverse">
            <xsl:with-param name="input" select="$next-string"/>
        </xsl:call-template>
    </xsl:param>
    <xsl:param name="reverse-next-property" select="substring-before($reverse-next-string,' ')"/>
    <xsl:param name="next-property">
        <xsl:call-template name="reverse">
            <xsl:with-param name="input" select="substring-before($reverse-next-string,' ')"/>
        </xsl:call-template>
    </xsl:param>
    <xsl:param name="string-before-next-property" select="substring-before($next-string, concat(' ',$next-property))"/>
    <xsl:param name="plural-values" select="contains($string-before-next-property,';')"/>
    <xsl:param name="multiple-items">
        <xsl:if test="$plural-values">
            <xsl:value-of select="lower-case($string-before-next-property)"/>
        </xsl:if>
    </xsl:param>
    <xsl:param name="items">
        <xsl:call-template name="items">
            <xsl:with-param name="input" select="$multiple-items"/>
            <xsl:with-param name="output-format" select="$output-format"/>
        </xsl:call-template>
    </xsl:param>
    <xsl:param name="value">
        <xsl:choose>
            <xsl:when test="$next-property != '' and contains($string-before-next-property,';') and $output-format = 'xcalendar-encoded'">
                <xsl:value-of select="$items"/>
            </xsl:when>
            <xsl:when test="$next-property != ''">
                <xsl:value-of select="$string-before-next-property"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string-after-property"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="remaining-string" select="substring-after($string-after-property,concat($value,' '))"/>
    <xsl:if test="$property != 'begin' and $property != 'end'">
        <xsl:choose>
            <xsl:when test="$type = 'event'">
                <xsl:choose>
                    <xsl:when test="$output-format = 'xcalendar'">
                        <xsl:choose>
                            <xsl:when test="$property-attribute-name = 'value'">
                                <xsl:element name="{$property}">
                                    <xsl:attribute name="{$property-attribute-name}"><xsl:value-of select="$property-attribute-value"/></xsl:attribute>
                                    <xsl:value-of select="$value"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$plural-values and $output-format = 'xcalendar'">
                                <xsl:element name="{$property}">
                                    <xsl:copy-of select="$items"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="{$property}">
                                    <xsl:value-of select="$value"/>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$output-format = 'xcalendar-encoded'">
                        <xsl:choose>
                            <xsl:when test="$property-attribute-name = 'value'">
                                <xsl:text>&#x9;&#x9;&lt;</xsl:text>
                                <xsl:value-of select="$property"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$property-attribute-name"/>
                                <xsl:text>="</xsl:text>
                                <xsl:value-of select="$property-attribute-value"/>
                                <xsl:text>"&gt;</xsl:text>
                                <xsl:value-of select="$value"/>
                                <xsl:text>&lt;/</xsl:text>
                                <xsl:value-of select="$property"/>
                                <xsl:text>&gt;&#xd;</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>&#x9;&#x9;&lt;</xsl:text>
                                <xsl:value-of select="$property"/>
                                <xsl:text>&gt;</xsl:text>
                                <xsl:value-of select="$value"/>
                                <xsl:text>&lt;/</xsl:text>
                                <xsl:value-of select="$property"/>
                                <xsl:text>&gt;&#xd;</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$type = 'calendar'">
                <xsl:choose>
                    <xsl:when test="$output-format = 'xcalendar'">
                        <xsl:attribute name="{$property}"><xsl:value-of select="$value"/></xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$output-format = 'xcalendar-encoded'">
                        <xsl:text>&#x9;</xsl:text>
                        <xsl:value-of select="$property"/>
                        <xsl:text>="</xsl:text>
                        <xsl:value-of select="$value"/>
                        <xsl:text>"</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:if>
    <xsl:if test="$remaining-string != ''">
        <xsl:if test="$property != 'begin' and $property != 'end' and $output-format = 'xcalendar-encoded' and $type = 'calendar'">
            <xsl:text>&#xd;</xsl:text>
        </xsl:if>
        <xsl:call-template name="properties">
            <xsl:with-param name="input" select="$remaining-string"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:with-param name="output-format" select="$output-format"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>


<xsl:template name="items">
    <xsl:param name="input"/>
    <xsl:param name="items" select="$input"/>
    <xsl:param name="output-format" select="'xcalendar'"/>
    <xsl:param name="delimiter" select="';'"/>
    <xsl:param name="item-and-value">
        <xsl:choose>
            <xsl:when test="contains($items,$delimiter)">
                <xsl:value-of select="substring-before($items,$delimiter)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$items"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="remaining-items" select="substring-after($items,$delimiter)"/>
    <xsl:param name="item" select="substring-before($item-and-value,'=')"/>
    <xsl:param name="value" select="substring-after($item-and-value,'=')"/>
    <xsl:choose>
        <xsl:when test="$output-format = 'xcalendar'">
            <item class="{$item}">
                <xsl:value-of select="$value"/>
            </item>
        </xsl:when>
        <xsl:when test="$output-format = 'xcalendar-encoded'">
            <xsl:text>&#xd;&#x9;&#x9;&#x9;&lt;</xsl:text>
            <xsl:value-of select="$item"/>
            <xsl:text>&gt;</xsl:text>
            <xsl:value-of select="$value"/>
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="$item"/>
            <xsl:text>&gt;</xsl:text>
        </xsl:when>
    </xsl:choose>
    <xsl:if test="$remaining-items != ''">
        <xsl:call-template name="items">
            <xsl:with-param name="input" select="$remaining-items"/>
            <xsl:with-param name="output-format" select="$output-format"/>
        </xsl:call-template>
    </xsl:if>
    <xsl:if test="$remaining-items = ''">
        <xsl:text>&#xd;&#x9;&#x9;</xsl:text>
    </xsl:if>
</xsl:template>


<xsl:template name="reverse">
    <xsl:param name="input"/>
    <xsl:variable name="length" select="string-length($input)"/>
    <xsl:choose>
        <xsl:when test="$length &lt; 2">
            <xsl:value-of select="$input"/>
        </xsl:when>     
        <xsl:when test="$length = 2">
            <xsl:value-of select="substring($input,2,1)"/>
            <xsl:value-of select="substring($input,1,1)"/>
        </xsl:when>     
        <xsl:otherwise>
            <xsl:variable name="middle" select="floor($length div 2)"/>
            <xsl:call-template name="reverse">
                <xsl:with-param name="input" select="substring($input,$middle + 1,$middle + 1)"/>
            </xsl:call-template>
            <xsl:call-template name="reverse">
                <xsl:with-param name="input" select="substring($input,1,$middle)"/>
            </xsl:call-template>
        </xsl:otherwise>        
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>