<%--
    Mango - Open Source M2M - http://mango.serotoninsoftware.com
    Copyright (C) 2006-2011 Serotonin Software Technologies Inc.
    @author Matthew Lohbihler
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see http://www.gnu.org/licenses/.
--%>
<%@ include file="/WEB-INF/jsp/include/tech.jsp"%>
<tag:page dwr="ViewDwr"
	js="view,dygraphs/dygraph-dev,dygraph-extra,dygraphsSplineUtils,dygraphsCharts"
	css="jQuery/plugins/jquery-ui/css/south-street/jquery-ui-1.10.3.custom.min,jQuery/plugins/datetimepicker/jquery-ui-timepicker-addon,jQuery/plugins/jpicker/css/jPicker-1.1.6.min" 
	jqplugins="jquery-ui/js/jquery-ui-1.10.3.custom.min,jpicker/jpicker-1.1.6.min,datetimepicker/jquery-ui-timepicker-addon" >
  <script type="text/javascript" src="resources/wz_jsgraphics.js"></script>
  <script type="text/javascript" src="resources/shortcut.js"></script>
  <script type="text/javascript" src="resources/customClientScripts/customView.js"></script>
  <link href="resources/js-ui/app/css/chunk-vendors.css" rel="stylesheet" type="text/css">
  <link href="resources/js-ui/app/css/app.css" rel="stylesheet" type="text/css">
  <!-- added bysteve -->
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBuCIAfY1ODCoVTvJyBtkZe-irKy0ljPXY"></script> 
  <!-- sweetalert replced with js slert because of not found in folder -->
  <!-- <link
	href="resources/app/bower_components/sweetalert2/dist/sweetalert2.min.css"
	rel="stylesheet" type="text/css"> -->
    <style>
    	 table {
             border-collapse: separate !important;
             border-spacing: 2px !important;
             padding: 3px;
         }
         .rowTable {
             background-color: #F0F0F0;
         }
         .rowTableAlt {
             background-color: #DCDCDC;
         }
		 #viewContent,.viewContent{
			 display: none;
		 }
		 .viewContent{
			float: left;position: relative;display: block;
		 }
		.overlay {
		padding: 5px;
		border: 1px solid #39B54A;
		background: rgba(255, 255, 255, 0.6);
		}
    </style>
    <!-- <script type="text/javascript" src="resources/app/bower_components/sweetalert2/dist/sweetalert2.min.js"></script> -->

	<script type="text/javascript">
	
	jQuery.noConflict();
	
	shortcut.add("Ctrl+Shift+F",function() {

		setCookie("fullScreen","no");
		
		document.getElementById('mainHeader').style.display = "compact";
  	  	document.getElementById('subHeader').style.display = "compact";
  	  	document.getElementById('graphical').style.display = "compact";
  	  	
  		location.reload(true);

		
	});
	
	//check replace alert
	jQuery.ajax({
        type: "GET",
        dataType: "json",
        url:'/ScadaBR/api/config/replacealert',
            success: function(data){
              if (data==true) {
				  console.log(data)
				alert(data)
            	//   window.alert =  function(message) {
				// 	alert(data)
            	//         swal({
            	//          title: message,
            	//          text: "I will close in 6 seconds.",
            	//          timer: 6000,
            	//          showConfirmButton: true
            	//        });
            	//  }
              }
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
              //no op
            }
    });
	
	<c:if test="${!empty currentView}">
      mango.view.initNormalView();
    </c:if>
    
    var nVer = navigator.appVersion;
    var nAgt = navigator.userAgent;
    var browserName  = navigator.appName;
    var fullVersion  = ''+parseFloat(navigator.appVersion); 
    var majorVersion = parseInt(navigator.appVersion,10);
    var nameOffset,verOffset,ix;

    // In Opera, the true version is after "Opera" or after "Version"
    if ((verOffset=nAgt.indexOf("Opera"))!=-1) {
     browserName = "Opera";
     fullVersion = nAgt.substring(verOffset+6);
     if ((verOffset=nAgt.indexOf("Version"))!=-1) 
       fullVersion = nAgt.substring(verOffset+8);
    }
    // In MSIE, the true version is after "MSIE" in userAgent
    else if ((verOffset=nAgt.indexOf("MSIE"))!=-1) {
     browserName = "Microsoft Internet Explorer";
     fullVersion = nAgt.substring(verOffset+5);
    }
    // In Chrome, the true version is after "Chrome" 
    else if ((verOffset=nAgt.indexOf("Chrome"))!=-1) {
     browserName = "Chrome";
     fullVersion = nAgt.substring(verOffset+7);
    }
    // In Safari, the true version is after "Safari" or after "Version" 
    else if ((verOffset=nAgt.indexOf("Safari"))!=-1) {
     browserName = "Safari";
     fullVersion = nAgt.substring(verOffset+7);
     if ((verOffset=nAgt.indexOf("Version"))!=-1) 
       fullVersion = nAgt.substring(verOffset+8);
    }
    // In Firefox, the true version is after "Firefox" 
    else if ((verOffset=nAgt.indexOf("Firefox"))!=-1) {
     browserName = "Firefox";
     fullVersion = nAgt.substring(verOffset+8);
    }
    // In most other browsers, "name/version" is at the end of userAgent 
    else if ( (nameOffset=nAgt.lastIndexOf(' ')+1) < 
              (verOffset=nAgt.lastIndexOf('/')) ) 
    {
     browserName = nAgt.substring(nameOffset,verOffset);
     fullVersion = nAgt.substring(verOffset+1);
     if (browserName.toLowerCase()==browserName.toUpperCase()) {
      browserName = navigator.appName;
     }
    }
    // trim the fullVersion string at semicolon/space if present
    if ((ix=fullVersion.indexOf(";"))!=-1)
       fullVersion=fullVersion.substring(0,ix);
    if ((ix=fullVersion.indexOf(" "))!=-1)
       fullVersion=fullVersion.substring(0,ix);

    majorVersion = parseInt(''+fullVersion,10);
    if (isNaN(majorVersion)) {
     fullVersion  = ''+parseFloat(navigator.appVersion); 
     majorVersion = parseInt(navigator.appVersion,10);
    }
    
    function unshare() {
        ViewDwr.deleteViewShare(function() { window.location = 'views.shtm'; });
    }
    
    function setCookie(c_name,value)
    {
    	var exdate=new Date();
    	exdate.setDate(exdate.getDate() + 365);
    	var c_value=escape(value) + ("; expires="+exdate.toUTCString());
    	document.cookie=c_name + "=" + c_value;
    }
    
    function getCookie(c_name)
    {
    	var i,x,y,ARRcookies=document.cookie.split(";");
    	
    	for (i=0;i<ARRcookies.length;i++)
    	{
      		x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
      		y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
      		x=x.replace(/^\s+|\s+$/g,"");
      		
      		if (x==c_name)
        	{
        		return unescape(y);
        	}
      	}
    	
    }
    
	function toggleDisplay(){
  	  	
		document.getElementById('mainHeader').style.display = "none";
  	  	document.getElementById('subHeader').style.display = "none";
  	  	document.getElementById('graphical').style.display = "none";
  	  	jQuery('#fsOut').fadeOut(10000, function(){});
  	  	
	}
	
	function fullScreen(){
  	  	
		document.getElementById('fsOut').style.display = "block";
		document.getElementById('mainHeader').style.display = "none";
  	  	document.getElementById('subHeader').style.display = "none";
  	  	document.getElementById('graphical').style.display = "none";
		jQuery('#fsOut').fadeOut(10000, function(){});

  	  	setCookie("fullScreen","yes");
  	  	
	}
	
	function checkFullScreen(){
  	  	
		var check = getCookie("fullScreen");
		
		if(check!=null && check!=""){
			
			if(check=="yes"){
				toggleDisplay();
// 				document.getElementById('fsOut').style.display = "block";
			}
			
			if(check=="no"){
				document.getElementById('fsOut').style.display = "none";
			}
		}
  	  	
	}
		
	function keyListen(e) {
        var keycode = e.keyCode;
        
        if(keycode == '116') {
        	e.returnValue=false;
        	e.keyCode=false;
        	return false;
        };
	}

	function callkeydownhandler(evnt) {
   		keyListen(evnt);
	}

	
</script>

	<table class="subPageHeader" id="graphical">
		<tr>
			<td class="smallTitle"><fmt:message key="views.title" /> <tag:help
					id="graphicalViews" /></td>
			<td width="50"></td>
			<c:if test="${fn:length(views) != 0}">
				<td>
					<tag:img png="arrow_out" title="viewEdit.fullScreen" onclick="fullScreen()" />
					<!-- <input type="button" name="buttonFull" value="Full Screen" onClick="fullScreen();" /> -->
				</td>
			</c:if>
			<td align="right"><sst:select value="${currentView.id}"
					onchange="window.location='?viewId='+ this.value;">
					<c:forEach items="${views}" var="aView">
						<sst:option value="${aView.key}">${sst:escapeLessThan(aView.value)}</sst:option>
					</c:forEach>
				</sst:select> <c:if test="${!empty currentView}">
					<c:choose>
						<c:when test="${owner}">
							<a href="view_edit.shtm?viewId=${currentView.id}"><tag:img
									png="icon_view_edit" title="viewEdit.editView" /> </a>
						</c:when>
						<c:otherwise>
							<!-- Apenas Admin pode remover compartilhamento
							 <tag:img png="icon_view_delete" title="viewEdit.deleteView"
								onclick="unshare()" />-->
						</c:otherwise>
					</c:choose>
				</c:if> <a href="view_edit.shtm"><tag:img png="icon_view_new"
						title="views.newView" /> </a></td>
		</tr>
		
	</table>

	<table > 
		<tr>
			<td class="smallTitle" id="fsOut">
				<fmt:message key="fullScreenOut"/>
			</td>
		</tr>
	</table>

	<tag:displayView view="${currentView}" emptyMessageKey="views.noViews" />
	<div class="viewContent">
		<div id="mapAreaOptions" >
		<span></span>
		</div>
		<div id="map"  style="position: absolute;top: 0;left: 0;width: 100%;height: 100%;">
		</div>
	</div>
</tag:page>
<script type="text/javascript">
// ============================================================================

//draggable methods
DraggableOverlay.prototype = new google.maps.OverlayView();
	DraggableOverlay.prototype.onAdd = function() {
		var container=document.createElement('div'),
			that=this;
			// console.clear();
			console.log(typeof this.get('content'))
			console.log(typeof this.get('content').nodeName)
		if(this.get('content') && typeof this.get('content').nodeName!=='undefined')
		{
			container.appendChild(this.get('content'));
		}
		else
		{
			if(this.get('content') && typeof this.get('content')==='string')
			{
				container.innerHTML=this.get('content');
			}
			else
			{
				return;
			}
		}
		container.style.position='absolute';
		container.draggable=true;
			google.maps.event.addDomListener(
			this.get('map').getDiv(),'mouseleave', function(){
				google.maps.event.trigger(container,'mouseup');
			}
			);
			google.maps.event.addDomListener(container, 'mousedown', function(e){
			this.style.cursor='move';
			that.map.set('draggable',false);
			that.set('origin',e);

			that.moveHandler  = google.maps.event.addDomListener(that.get('map').getDiv(),
																'mousemove',
																function(e){
				var origin = that.get('origin'),
					left   = origin.clientX-e.clientX,
					top    = origin.clientY-e.clientY,
					pos    = that.getProjection()
							.fromLatLngToDivPixel(that.get('position')),
					latLng = that.getProjection()
							.fromDivPixelToLatLng(new google.maps.Point(pos.x-left,
																		pos.y-top));
					that.set('origin',e);
					that.set('position',latLng);
					that.draw();
				});
			}
		);
			
		google.maps.event.addDomListener(container,'mouseup',function(){
		if(that.map)
		that.map.set('draggable',true);
		this.style.cursor='default';
		google.maps.event.removeListener(that.moveHandler);
		});
			
		
		this.set('container',container)
		this.getPanes().floatPane.appendChild(container);
		google.maps.event.addDomListener(container, "click", function(e) {
		e.preventDefault();
		e.stopPropagation();
		})
  	}

  	function DraggableOverlay(map,position,content)
  	{
		if(typeof draw==='function'){
		this.draw=draw;
		}
		this.setValues({position:position,container:null,
						content:content,map:map});
  	}
	DraggableOverlay.prototype.draw = function() {
		if(this.get('position') && this.get('container')) 
		{
			var pos = this.getProjection().fromLatLngToDivPixel(this.get('position'));
			this.get('container').style.left = pos.x + 'px';
			this.get('container').style.top = pos.y + 'px';
		}
	};
	DraggableOverlay.prototype.onRemove = function() {
		this.get('container').parentNode.removeChild(this.get('container'));
		this.set('container',null)
	};
//=============================================================================
</script>
<script type="text/javascript">
	var responseComponentData='${currentView.mapData}',//getting backend data
		mapInfoWindowContent="Info Window content!!",
		markers=[];
		
		responseComponentData=responseComponentData?JSON.parse(responseComponentData):responseComponentData;
		console.log(responseComponentData);
//-----------------
	window.onload=function(){
		checkFullScreen();
		// alert(typeof responseComponentData)
		// alert(responseComponentData)
		// console.clear();
		// console.log()
		if(responseComponentData){
			document.querySelector('.viewContent').style.display="block";
			document.querySelector('.viewContent').appendChild(document.querySelector('#viewContent img'));
			initMap(responseComponentData);
			console.log(responseComponentData)
		}
		else{
			document.getElementById('viewContent').style.display="block";
		}
	}
//=============================================================================
//iniialize map
function initMap() {
	
      var initialCenter,initialZoom,initialInfoContent;
      if(responseComponentData && responseComponentData.center && responseComponentData.center.lat){
        initialCenter = {'lat':responseComponentData.center.lat,"lng":responseComponentData.center.lng}
      }
      else{
        initialCenter = { lat: 28, lng: 77 }
      }
      if(responseComponentData && responseComponentData.zoom){
        initialZoom=responseComponentData.zoom;
      }
      else{
        initialZoom=5;
      }
	  
    renderedMap = new google.maps.Map(document.getElementById("map"), {
      zoom: initialZoom,
      center: initialCenter,
      mapTypeId: "terrain",
    });
   
    if(responseComponentData && responseComponentData.marker && responseComponentData.marker.length){
      renderAllSavedMrkers(renderedMap);//if there are saved markers
    }
  }
//=============================================================================
//looping throught all markers
	function renderAllSavedMrkers(renderedMap){
		// responseComponentData
		responseComponentData.marker.forEach(function(elem,idx){
			addMarker(elem);
		})
  	}
//=============================================================================
//add maker from save info
	function addMarker(location) {
		console.log("location.content")
		console.log(location)
		let mpInfoCntnt=location.content && location.content.length?location.content:'infoContent';
		var marker=new DraggableOverlay(
				renderedMap, new google.maps.LatLng({"lat":location.lat,"lng":location.lng}),
				'<div class="overlay" onclick="javascript:void(0)">'+mpInfoCntnt+'</div>'
			);
			marker["id"]=location.id;
		//update markers array
		markers.push(marker);
	}
//=============================================================================
</script>
<%@ include file="/WEB-INF/jsp/include/vue/vue-app.js.jsp"%>
<%@ include file="/WEB-INF/jsp/include/vue/vue-view.js.jsp"%>
<%@ include file="/WEB-INF/jsp/include/vue/vue-charts.js.jsp"%>