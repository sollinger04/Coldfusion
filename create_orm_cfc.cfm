<form method="post">
Datasource:<input type="text" name="tempdsn" value="<cfoutput>#application.datasource#</cfoutput>"><br>
Table Name:<input type="text" name="tablename" value=""><br>
<input type="submit">
</form>

<cfif isdefined('form.tablename') AND isdefined('form.tempdsn')>
  <cfquery name="temp" datasource="#form.tempdsn#" >
		SELECT * FROM information_schema.columns
		WHERE table_name = '#form.tablename#'
		ORDER BY ordinal_position
	</cfquery>
<cfsavecontent variable="pageText" >
<cfoutput>
component  output="false" persistent="true" table="#temp.table_name#" accessors="true"
{<cfloop query="temp" >
	<cfset datatype = ''>
	<cfswitch expression="#temp.data_type#" >
		<cfcase value="int"><cfset datatype = 'cf_sql_integer'><cfset sqldt = 'numeric'></cfcase>
		<cfcase value="text"><cfset datatype = 'cf_sql_longvarchar'><cfset sqldt = 'string'></cfcase>
		<cfcase value="numeric"><cfset datatype = 'cf_sql_numeric'><cfset sqldt = 'numeric'></cfcase>
		<cfcase value="datetime"><cfset datatype = 'cf_sql_date'><cfset sqldt = 'datetime'></cfcase>
		<cfcase value="bit"><cfset datatype = 'cf_sql_bit'><cfset sqldt = 'char'></cfcase>
		<cfcase value="varchar"><cfset datatype = 'cf_sql_varchar'><cfset sqldt = 'string'></cfcase>
	</cfswitch>
	property name="#column_name#"		column="#column_name#"		getter="true" 	<cfif currentrow eq 1>setter="false" 	fieldtype="id" 	generator="identity"<cfelse>setter="true" <cfif sqldt eq 'datetime'>ORMtype="date"<cfelse>type="#sqldt#"</cfif>	sqltype="#datatype#"</cfif>;</cfloop>

	public function init(){
		return this;
	}
}
</cfoutput>
</cfsavecontent>

<cffile action="write" file="#expandpath('/cfc/#temp.table_name#.cfc')#" output="#pageText#" >

</cfif>
