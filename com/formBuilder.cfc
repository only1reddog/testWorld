<cfcomponent hint="i build forms" displayname="Form Builder">
	<cfscript>
		/**
		* AUTHOR: Glenn Hartong
		* v1.0.0 - June 2011
		* v1.0.1 - April 2012 - added makeDateSelect
		* v1.0.2 - May 2012 - fixed IE8 issue with "trim" line 24.
		* v1.0.3 - June 2012 - added target to startForm()
		*/
		
		/**
		* @Start the Form
		*/
		function jsValidate(array valArray, boolean useCDN=true){
			var rtnStr = '';
			var intRow = 1;
			
			if(useCDN){
				rtnStr = rtnStr & '<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"></script>';
			}
			rtnStr = rtnStr & '<script type="text/javascript">';
			rtnStr = rtnStr & '$(function(){$("form").submit(function(e){var errMsg = "";';
			for(intRow=1; intRow LTE arrayLen(valArray); intRow++){
				if(lcase(valArray[intRow].valType) eq 'required'){
					rtnStr = rtnStr & 'if(!$.trim($("###valArray[intRow].fieldID#").val()).length){errMsg = errMsg + "#valArray[intRow].errMsg#\n";}';
				}
				if(lcase(valArray[intRow].valType) eq 'custom'){
					rtnStr = rtnStr & 'if(#valArray[intRow].validationStr#){ errMsg = errMsg + "#valArray[intRow].errMsg#\n"; }';
				}
			}
			rtnStr = rtnStr & 'if(errMsg.length){ alert(errMsg); e.stopPropagation(); return false; }';
			rtnStr = rtnStr & 'return true; }); }); </script>';
		
			return rtnStr;
		}

		/**
		* @Start the Form
		*/
		function startForm(string action='', string method='post', string enctype='', string formID='', string target=''){
			var rtnStr = '';
			if(len(arguments.formID)){
				local.formID = arguments.formID;
			}
			else{
				local.formID = '';
			}
			
			rtnStr = '<form action="#action#" method="#method#"';
			if(len(enctype)){
				rtnStr = rtnStr & ' enctype="#enctype#"';
			}
			if(len(target)){
				rtnStr = rtnStr & ' target="#target#"';
			}
			rtnStr = rtnStr & '><ul class="form" id="#local.formID#">';
			
			return rtnStr;
		}
		
		/**
		* @Make a Hidden field
		* @Specify text or password with 'fieldType' argument
		*/
		function makeHidden(string fieldName='', string fieldID='', string fieldValue=''){
			var rtnStr = '';
			
			rtnStr = rtnStr & '<input type="hidden" name="#fieldName#" id="#len(fieldID)?fieldID:fieldName#"';
			rtnStr = rtnStr & ' value="#fieldValue#"';
			rtnStr = rtnStr & '/>';

			return rtnStr;
		}

		/**
		* @Make a Text field
		* @Specify text or password with 'fieldType' argument
		*/
		function makeText(string fieldLabel='', string fieldName='', string fieldID='', string fieldValue='', string fieldClass='', numeric fieldMaxLength=255, string fieldType='text', boolean disabled=false){
			var rtnStr = '';
			
			rtnStr = rtnStr & '<li><label for="#len(fieldID)?fieldID:fieldName#">#fieldLabel#</label>';
			if(len(fieldName)){
				rtnStr = rtnStr & '<input type="#fieldType#" name="#fieldName#" id="#len(fieldID)?fieldID:fieldName#" maxlength="#fieldMaxLength#"';
			}
			if(len(fieldValue)){
				rtnStr = rtnStr & ' value="#fieldValue#"';
			}
			if(len(fieldClass)){
				rtnStr = rtnStr & ' class="#fieldClass#"';
			}
			if(disabled){
				rtnStr = rtnStr & ' disabled="disabled"';
			}
			rtnStr = rtnStr & '/>';
			rtnStr = rtnStr & '</li>';

			return rtnStr;
		}

		/**
		* @Make a select box
		* Query can be anything, just specifiy optValue and optText
		* Array should be array of structs with optValue and optText keys
		*/
		function makeSelect(string fieldLabel='', string fieldName='', string fieldID='', string fieldSelectedValue='', string fieldClass='', query fieldQry, array fieldArray, string optValue, string optText, numeric selectSize=1, boolean multiSelect=false){
			var rtnStr = '';
			var intRow = 0;
			
			//start li and label
			rtnStr = rtnStr & '<li><label for="#len(fieldID)?fieldID:fieldName#">#fieldLabel#</label>';
			//start select tag
			rtnStr = rtnStr & '<select name="#fieldName#" id="#len(fieldID)?fieldID:fieldName#" size="#selectSize#"';
			if(multiSelect){
				rtnStr = rtnStr & ' multiple="true"';
			}
			if(len(fieldClass)){
				rtnStr = rtnStr & ' class="#fieldClass#"';
			}
			rtnStr = rtnStr & '>';
			//start options
			//array
			if(isDefined('fieldArray')){
				for(intRow=1;intRow LTE arrayLen(fieldArray);intRow++){
					rtnStr = rtnStr & '<option value="#trim(fieldArray[intRow].optValue)#"';
					if(isDefined('fieldSelectedValue') && fieldSelectedValue eq trim(fieldArray[intRow].optValue)){
						rtnStr= rtnStr & ' selected="selected"';
					}
					rtnStr = rtnStr & '>#trim(fieldArray[intRow].optText)#</option>';
				}
			}
			//more options
			//qry
			if(isDefined('fieldQry')){
				for(intRow=1;intRow LTE fieldQry.recordCount;intRow++){
					rtnStr = rtnStr & '<option value="#fieldQry[optValue][intRow]#"';
					if(isDefined('fieldSelectedValue') && fieldSelectedValue eq fieldQry[optValue][intRow]){
						rtnStr= rtnStr & ' selected="selected"';
					}
					rtnStr = rtnStr & '>#isDefined('optText')?fieldQry[optText][intRow]:fieldQry[optValue][intRow]#</option>';
				}
			}
			//end select tab and li
			rtnStr = rtnStr & '</select></li>';
			
			return rtnStr;
		}
		
		/**
		* @Make a select box with Month Day and Year drop downs
		*/
		function makeDateSelect(string fieldLabel='', any dateSelected, string monthOptionText='Select a Month', string monthID='monthID', boolean monthAsAString=true, any monthSelected=0, string dayOptionText='Select a Day', string dayID='dayID', any daySelected=0, string yearOptionText='Select a Year', string yearID='yearID', numeric yearStart='#year(now())-1#', numeric yearEnd='#year(now())+5#', any yearSelected=0){
			var m = 0;
			var d = 0;
			var y = 0;
			var local.thisMonth = 0;
			var local.thisDay = 0;
			var local.thisYear = 0;
			
			if(isNumeric(arguments.monthSelected) && arguments.monthSelected LTE 12){
				local.thisMonth = arguments.monthSelected;
			}
			if(isNumeric(arguments.daySelected) && arguments.daySelected LTE 31){
				local.thisDay = arguments.daySelected;
			}
			if(isNumeric(arguments.yearSelected)){
				local.thisYear = arguments.yearSelected;
			}
			if(isDate(arguments.monthSelected)){
				local.thisMonth = month(arguments.monthSelected);
			}
			if(isDate(arguments.daySelected)){
				local.thisDay = day(arguments.daySelected);
			}
			if(isDate(arguments.yearSelected)){
				local.thisYear = year(arguments.yearSelected);
			}
			if(isDefined('arguments.dateSelected') && isDate(arguments.dateSelected)){
				local.thisMonth = month(arguments.dateSelected);
				local.thisDay = day(arguments.dateSelected);
				local.thisYear = year(arguments.dateSelected);
			}
			
			savecontent variable="local.temp"{
				writeOutput('<li><label>#arguments.fieldLabel#</label>
				<div>
					<select name="#arguments.monthID#" id="#arguments.monthID#" class="dateSelect">
						<option value="0">#arguments.monthOptionText#</option>');
						for(m=1; m LTE 12; m++){
							writeOutput('<option value="#m#"');
							if(local.thisMonth eq m) writeOutput(' SELECTED');
							writeOutput('>#arguments.monthAsAString? monthAsString(m): m#</option>');
						}
					writeOutput('</select>
					<select name="#arguments.dayID#" id="#arguments.dayID#" class="dateSelect">
						<option value="0">#arguments.dayOptionText#</option>');
						for(d=1; d LTE 31; d++){
							writeOutput('<option value="#d#"');
							if(local.thisDay eq d) writeOutput(' SELECTED'); 
							writeOutput('>#d#</option>');
						}
					writeOutput('</select>                
					<select name="#arguments.yearID#" id="#arguments.yearID#" class="dateSelect">
						<option value="0">#arguments.yearOptionText#</option>');
						for(y=arguments.yearStart; y LTE arguments.yearEnd; y++){
							writeOutput('<option value="#y#"');
							if(local.thisYear eq y) writeOutput(' SELECTED'); 
							writeOutput('>#y#</option>');
						}
					writeOutput('</select>
				</div></li>');
			}  

			return local.temp;
		}
		
		/**
		* @Make a radio button field
		* Query can be anything, just specifiy optValue and optText
		* Array should be array of structs with optValue and optText keys
		*/
		function makeRadio(string fieldLabel='', string fieldName='', string fieldSelectedValue='', query fieldQry, array fieldArray, string optValue, string optText, string fieldClass='', boolean disabled=false){
			var rtnStr = '';
			var intRow = 0;
			
			//open li, field label and open option div
			rtnStr = rtnStr & '<li><label>#fieldLabel#</label><div>';
			
			//start options
			//array
			if(isDefined('fieldArray')){
				for(intRow=1;intRow LTE arrayLen(fieldArray);intRow++){
					rtnStr = rtnStr & '<label class="radioBtn';
					if(len(fieldClass)){
						rtnStr = rtnStr & ' #fieldClass#';
					}
					rtnStr = rtnStr & '"><input type="radio" name="#fieldName#" value="#fieldArray[intRow].optValue#"';
					if(isDefined('fieldSelectedValue') && fieldSelectedValue eq fieldArray[intRow].optValue){
						rtnStr = rtnStr & ' checked="checked"';
					}
					if(disabled){
						rtnStr = rtnStr & ' disabled="disabled"';
					}
					rtnStr = rtnStr & '/>#fieldArray[intRow].optText#</label>';
				}
			}
			//more options
			//qry
			if(isDefined('fieldQry')){
				for(intRow=1;intRow LTE fieldQry.recordCount;intRow++){
					rtnStr = rtnStr & '<label class="radioBtn';
					if(len(fieldClass)){
						rtnStr = rtnStr & ' #fieldClass#';
					}
					rtnStr = rtnStr & '"><input type="radio" name="#fieldName#" value="#fieldQry[optValue][intRow]#"';
					if(isDefined('fieldSelectedValue') && fieldSelectedValue eq fieldQry[optValue][intRow]){
						rtnStr= rtnStr & ' checked="checked"';
					}
					if(disabled){
						rtnStr = rtnStr & ' disabled="disabled"';
					}
					rtnStr = rtnStr & '/>#isDefined('optText')?fieldQry[optText][intRow]:fieldQry[optValue][intRow]#</label>';
				}
			}
			
			//close option div and li
			rtnStr = rtnStr & '</div></li>';

			return rtnStr;
		}

		/**
		* @Make a check box field
		* Query can be anything, just specifiy optValue and optText
		* Array should be array of structs with optValue and optText keys
		*/
		function makeCheckbox(string fieldLabel='', string fieldName='', string fieldSelectedValue='', query fieldQry, array fieldArray, string optValue, string optText, Boolean disabled=false){
			var rtnStr = '';
			var intRow = 0;
			
			//open li, field label and open option div
			rtnStr = rtnStr & '<li><label>#fieldLabel#</label><div>';
			
			//start options
			//array
			if(isDefined('fieldArray')){
				for(intRow=1;intRow LTE arrayLen(fieldArray);intRow++){
					rtnStr = rtnStr & '<label class="checkBtn"><input type="checkbox" name="#fieldName#" value="#fieldArray[intRow].optValue#"';
					if(isDefined('fieldSelectedValue') && listFind(fieldSelectedValue,fieldArray[intRow].optValue)){
						rtnStr = rtnStr & ' checked="checked"';
					}
					if(disabled){
						rtnStr = rtnStr & ' disabled="disabled"';
					}
					rtnStr = rtnStr & '/>#fieldArray[intRow].optText#</label>';
				}
			}
			//more options
			//qry
			if(isDefined('fieldQry')){
				for(intRow=1;intRow LTE fieldQry.recordCount;intRow++){
					rtnStr = rtnStr & '<label class="checkBtn"><input type="checkbox" name="#fieldName#" value="#fieldQry[optValue][intRow]#"';
					if(isDefined('fieldSelectedValue') && listFind(fieldSelectedValue,fieldQry[optValue][intRow])){
						rtnStr= rtnStr & ' checked="checked"';
					}
					if(disabled){
						rtnStr = rtnStr & ' disabled="disabled"';
					}
					rtnStr = rtnStr & '/>#isDefined('optText')?fieldQry[optText][intRow]:fieldQry[optValue][intRow]#</label>';
				}
			}
			
			//close option div and li
			rtnStr = rtnStr & '</div></li>';

			return rtnStr;
		}

		/**
		* @Make a text area
		*/
		function makeTextarea(string fieldLabel='', string fieldName='', string fieldID='', string fieldClass='', string fieldValue='', numeric numRows=5, numeric numCols=60, boolean disabled=false){
			var rtnStr = '';
			
			//start li and label
			rtnStr = rtnStr & '<li><label for="#len(fieldID)?fieldID:fieldName#">#fieldLabel#</label>';
			//start textarea
			rtnStr = rtnStr & '<textarea name="#fieldName#" id="#len(fieldID)?fieldID:fieldName#" rows="#numRows#" cols="#numCols#"';
			//class
			if(len(fieldClass)){
				rtnStr = rtnStr & ' class="#fieldClass#"';
			}
			//disabled
			if(disabled){
				rtnStr = rtnStr & ' disabled="disabled"';
			}
			//end textarea
			rtnStr = rtnStr & '>#fieldValue#</textarea></li>';
			
			return rtnStr;
		}

		/**
		* @Make a file field
		*/
		function makeFile(string fieldLabel='', string fieldName='', string fieldID='', string fieldClass=''){
			var rtnStr = '';
			
			rtnStr = rtnStr & '<li><label for="#len(fieldID)?fieldID:fieldName#">#fieldLabel#</label>';
			if(len(fieldName)){
				rtnStr = rtnStr & '<input type="file" name="#fieldName#" id="#len(fieldID)?fieldID:fieldName#"';
			}
			if(len(fieldClass)){
				rtnStr = rtnStr & ' class="#fieldClass#"';
			}
			rtnStr = rtnStr & '/>';
			rtnStr = rtnStr & '</li>';

			return rtnStr;
		}

		/**
		* @End the Form
		* @Includes cancel and submit button arguments
		*/
		function endForm(boolean hasSubmit=true, string submitText='Submit', string submitClass='submitBtn', boolean hasCancel=false, string cancelText='Cancel', string cancelClass="cancelBtn", string cancelURL='', boolean hasCustom=false, string customText='Custom', string customClass="customBtn", string customCall=''){
			var rtnStr = '';
			
			if(hasSubmit){
				rtnStr = '<li id="submit_li"><button type="submit" class="#submitClass#">#submitText#</button>';
			}
			if(hasCancel){
				rtnStr = rtnStr & '<button type="button" onclick="javascript:location.href=';
				rtnStr = rtnStr & "'#cancelURL#';";
				rtnStr = rtnStr & '" class="#cancelClass#">#cancelText#</button>';
			}
			if(hasCustom){
				rtnStr = rtnStr & '<button type="button"';
				if(customCall.length()){
					rtnStr = rtnStr & ' onclick="#customCall#"';
				}
				rtnStr = rtnStr & ' class="#customClass#">#customText#</button>';
			}
			rtnStr = rtnStr & '</li></ul></form>';
			
			return rtnStr;
		}
	</cfscript>
</cfcomponent>