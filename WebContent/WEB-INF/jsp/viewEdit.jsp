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
<%@ include file="/WEB-INF/jsp/include/tech.jsp" %>
<%@page import="com.serotonin.mango.view.ShareUser"%>

 
<tag:page dwr="ViewDwr" onload="doOnload"
	js="view,dygraph-combined,dygraph-extra,dygraphsSplineUtils,dygraphsCharts"
	css="jQuery/plugins/chosen/chosen,jQuery/plugins/jpicker/css/jPicker-1.1.6.min,jQuery/plugins/jquery-ui/css/south-street/jquery-ui-1.10.3.custom.min" 
  jqplugins="chosen/chosen.jquery.min,jpicker/jpicker-1.1.6.min,jquery-ui/js/jquery-ui-1.10.3.custom.min" >
  <!-- created & added stylesheet & remove css from this file. -->
  <!link href="resources/js-ui/app/css/viewedit.css" rel="stylesheet" type="text/css">
  <!!!!!!!!!!!!Stylimg Starts!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>
  <style>
    .resetTable__fontSize{
        font-size: 16px;
    }
    .backgroundImage{
      display: none;
    }
    .componentElemet{
      position: absolute;
      left: 0;
      right: 0;
      bottom: 0;
      top: 0;
      pointer-events: none;
    }
    div#componentElemet * {
      pointer-events: all;
    }
    .relative-table{
      position: relative;
    }
    .gm-style-iw-d >div>div{
      position: relative !important ;  
      top: 0 !important;
      left: 0 !important;
    }
    .gm-style-iw-d .controlsDiv{
      position: relative;
      float: left;
      visibility: visible !important;
      margin-top: 5px;
      clear: left;
    }
    
    .gm-style-iw-d .wirelessTempHumSensorContent:not(:empty),.overlay .wirelessTempHumSensorContent:not(:empty){
      min-width: 201px;
      height: 100px;
      margin-left: 21px;
      position: relative;
    }
    .gm-style-iw-d .componentPt{
      display: block;
      float: left;
    }
    .overlay .componentPt{
      display: block;
      float: left;
    }
    .overlay .componentPt>div{
      position: relative !important;
    }
    #mapAreaOptions {
        display: none;
    }
    .overlay {
      position: relative;
      /* padding: 5px;
      border: 1px solid #39B54A;
      background: rgba(255, 255, 255, 0.6); */
    }
    .overlay> div{
      position: relative !important ;  
      top: 0 !important;
      left: 0 !important;
    }
    .overlay:hover .controlsDiv{
      visibility: visible !important;
    }
    .overlay .wirelessTempHumSensorContent>div:first-child {
      max-width: 201px;
      margin-bottom: 7px;
      top: 0 !important;
    }
    .overlay .wirelessTempHumSensorContent>div:not(:first-child) {
        min-width: 50%;
        left: 0 !important;
        top: 0 !important;
        float: left;
    }
    .overlay div .wirelessTempHumSensorContent>div {
        position: relative !important;
    }
    /* toggle visibility of map-img */
    td.map__active input, td.map__active br, td.map__active label:not([for="googleMap"]) {
        display: none;
    }
    td.img__active input, td.img__active br, td.img__active label[for="googleMap"] {
        display: none;
    }
    #componentGeneratorBtnInfo.map__active img{
      display: none;
    }
    #componentGeneratorBtnInfo.img__active span{
      display: none;
    }
    #componentGeneratorBtnInfo span {
      font-size: 12px;
      display: inline-block;
      vertical-align: middle;
      padding: 3px 5px;
      background: rgba(74, 147, 200, 0.09);
      color: #285a7d;
      border: 1px solid rgba(74, 147, 200, 0.25);
  }
  </style>
   <!!!!!!!!!!!!Stylimg Starts!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>
	<link href="resources/js-ui/app/css/chunk-vendors.css" rel="stylesheet" type="text/css">
  <link href="resources/js-ui/app/css/app.css" rel="stylesheet" type="text/css">
  <script type="text/javascript" src="resources/wz_jsgraphics.js"></script>
  <script type="text/javascript" src="resources/customClientScripts/customView.js"></script>
  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBuCIAfY1ODCoVTvJyBtkZe-irKy0ljPXY"></script> 
  <!script src="resources/js-ui/app/js/viewedit.js"><!/script>
  <! View Edit Script!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>
<script>

var markers = [], componentEditersRefsObject='',//toggle editors for views
    removingOverlayId='',removingOverlayConfirmType=1;//During deletion set get overlay id  & confirm type if no content generated
    // savedMarkersInfo=JSON.parse(localStorage.getItem('allMarkersArray'));/////

    var renderedMap='',mapInfoWindowContent="map Info Window Content",stringToHTML;//map info window content generating from the libarary
    var ActiveGraphicRendererId='',ActiveGraphicRendererImgSrc=null,//globaal var for storing selected icon
        ResponseOfGMapOverlayData='',//on edit store overlay data
        dwrComponentIdOfMap='';
// -----------------------------------------------------------------------------
  // stringToHTML = function (str) {
  //   var parser = new DOMParser();
  //   var doc = parser.parseFromString(str, 'text/html');
  //   return doc.body;
  // };
  //Loop to Render saved componennets over map
  function renderAllSavedMrkers(renderedMap){
    // ResponseOfGMapOverlayData
    ResponseOfGMapOverlayData.marker.forEach(function(elem,idx){
      addMarker(elem);
    })
  }
  // removing selected marker id
  function removeSelectedMarkers(id){
    console.log(markers)
    markers=markers.filter(function(elem,idx){
      if(elem.id == id){
        markers[idx].setMap(null)
      }
      return elem.id != id
    })
  };
// ============================================================================
//draggable methods
  DraggableOverlay.prototype = new google.maps.OverlayView();
  DraggableOverlay.prototype.onAdd = function() {
    var container=document.createElement('div'),
        that=this;
    if(this.get('content') && typeof this.get('content').nodeName!=='undefined'){
      container.appendChild(this.get('content'));
    }
    else{
      if(typeof this.get('content')==='string'){
        container.innerHTML=this.get('content');
      }
      else{
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
      that.map.set('draggable',false);
      if(e.target.nodeName != "INPUT")//stop dragging  condition
      {
        that.set('origin',e);
        this.style.cursor='move';
        that.moveHandler  = google.maps.event.addDomListener(that.get('map').getDiv(),
                                                          'mousemove', function(e){
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
      console.log(e.target.nodeName)
      if(e.target.nodeName != "INPUT")//Avoide click event
      {
        e.preventDefault();
        e.stopPropagation();
      }
      else{
        // event.target.click();
        event.stopPropagation();
      }
    })
    // This handler allows right click events on anchor tags within the popup
    var allowAnchorRightClicksHandler = function (e) {
        if (e.target.nodeName === "OBJECT" || e.target.nodeName === "EMBED") {
            e.cancelBubble = true;
            if (e.stopPropagation) {
                e.stopPropagation();
            }
        }
        google.maps.event.removeListener(that.moveHandler);
    };
    this.contextListener_ = google.maps.event.addDomListener(container, "contextmenu", allowAnchorRightClicksHandler);
    // google.maps.event.addDomListener(container, 'contextmenu', function () {
    //     google.maps.event.trigger(container, 'contextmenu');
    // });
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
//Render componennets over map on click
  function addMarkerOnClick(location,id,overlayContainer) {
    var marker=new DraggableOverlay( renderedMap, location, overlayContainer );
        marker["id"]=id;
        markers.push(marker);
  }
//Render saved componennets over map
  function addMarker(location) {
      var overlayContent=document.createElement("DIV");
      overlayContent.className="overlay";
      var mpInfoCntnt=location.content && location.content.length?location.content:'infoContent';
      var currNode=document.querySelector('#viewContent #'+location.dwrId);

      // var currNode='';
        if(currNode){
          currNode.removeAttribute('dojodragsource');
          overlayContent.appendChild(currNode);
            var pluginDelete=overlayContent.querySelector('.controlsDiv img[src="images/plugin_delete.png"]');
            var htmlDelete=overlayContent.querySelector('.controlsDiv img[src="images/html_delete.png"]');
            if(pluginDelete){
              pluginDelete.setAttribute("overlayId",location.id);
              pluginDelete.setAttribute("data-status",1);
            }
            if(htmlDelete){
              htmlDelete.setAttribute("overlayId",location.id);
              htmlDelete.setAttribute("data-status",1);
            }
        }
        else{
          overlayContent.append(mpInfoCntnt)
        }
    var marker=new DraggableOverlay(
              renderedMap, new google.maps.LatLng({"lat":location.lat,"lng":location.lng}),
              overlayContent
        );
        marker["id"]=location.id;
        marker["dwrId"]=location.dwrId;
        marker["type"]=location.content;
    //update markers array
    markers.push(marker);
  }
//=============================================================================
//removing all comp generator content & add in the current
  function RemovingAllHaveContentPopupWithCurrent(currentMarkerId){
      var overlayCompContainer=document.createElement("DIV");
          overlayCompContainer.className="overlay__compContWraper";
          overlayCompContainer.innerHTML=document.getElementById('componentEditersRefs').innerHTML;
      document.querySelectorAll('.overlay').forEach(function(elem,idx){
          if(elem.querySelector('.overlay__compContWraper'))
          elem.querySelector('.overlay__compContWraper').remove();
      })
      var newId="c"+currentMarkerId;
      document.getElementById(newId).before(overlayCompContainer)
  }
//=============================================================================
//iniialize map
  function initMap() {
      var initialCenter,initialZoom,initialInfoContent;
      if(ResponseOfGMapOverlayData && ResponseOfGMapOverlayData.center && ResponseOfGMapOverlayData.center.lat){
        initialCenter = {'lat':ResponseOfGMapOverlayData.center.lat,"lng":ResponseOfGMapOverlayData.center.lng}
      }
      else{
        initialCenter = { lat: 28, lng: 77 }
      }
      if(ResponseOfGMapOverlayData && ResponseOfGMapOverlayData.zoom){
        initialZoom=ResponseOfGMapOverlayData.zoom;
      }
      else{
        initialZoom=5;
      }
    renderedMap = new google.maps.Map(document.getElementById("map"), {
      zoom: initialZoom,
      center: initialCenter,
      mapTypeId: "terrain",
    });
   
    // This event listener will call addMarker() when the map is clicked.
    renderedMap.addListener("click", (event) => {
      var overlayContainer=document.createElement("DIV");
      overlayContainer.className="overlay";
      //   overlayContainer.innerHTML="<div id='overlay__compContWraper'>"+document.getElementById('componentEditersRefs').innerHTML+"</div>";
      var dynamicId=new Date().getTime();
      // var newMarker=event.latLng.toJSON();
      var newMarker=event.latLng;
      // addMarkerOnClick(newMarker,dynamicId,overlayContainer);
      var marker=new DraggableOverlay(renderedMap, newMarker, overlayContainer );
          marker["id"]=dynamicId;
          marker["type"]=document.getElementById('componentList').value;
      setTimeout(function(){
        addViewComponent(overlayContainer);//called the component
        setTimeout(function(){//updating events & setting attributes
            // console.log(overlayContainer)
            // console.log(typeof overlayContainer)
            marker["dwrId"]=overlayContainer.querySelector(':scope >div').getAttribute('id');
            
            markers.push(marker);
            var curentOCompIdSelector=$(overlayContainer.querySelector(':scope >div').getAttribute('id')+"Content");
            var curentOCompIdGSelector=$(overlayContainer.querySelector(':scope >div').getAttribute('id')+"Graph");
            var hasChildElems=curentOCompIdSelector && curentOCompIdSelector.innerHTML;
            var hasChildGElems=curentOCompIdGSelector && curentOCompIdGSelector.innerHTML;
            // console.log(curentOCompIdSelector)
            // console.log(hasChildElems)
            var pluginDelete=overlayContainer.querySelector('.controlsDiv img[src="images/plugin_delete.png"]');
            var editDelete=overlayContainer.querySelector('.controlsDiv img[src="images/pencil.png"]');
            var htmlDelete=overlayContainer.querySelector('.controlsDiv img[src="images/html_delete.png"]');
            if(hasChildElems || hasChildGElems){
              if(pluginDelete){
                pluginDelete.setAttribute("overlayId",dynamicId);
                pluginDelete.setAttribute("data-status",1);
              }
              if(htmlDelete){
                htmlDelete.setAttribute("overlayId",dynamicId);
                htmlDelete.setAttribute("data-status",1);
              }
            }
            else{
              if(pluginDelete){
                pluginDelete.setAttribute("overlayId",dynamicId);
                pluginDelete.setAttribute("data-status",0);
                // editDelete.click();
                // pluginDelete.click();
                console.warn('Content not generated for this component,refresh page!!');
              }
              if(htmlDelete){
                htmlDelete.setAttribute("overlayId",dynamicId);
                htmlDelete.setAttribute("data-status",0);
                // htmlDelete.click();
                console.warn('Content not generated for this component,refresh page!!');
              }
            }
        },1000)
      },50)
    });
  
    if(ResponseOfGMapOverlayData && ResponseOfGMapOverlayData.marker && ResponseOfGMapOverlayData.marker.length){
      setTimeout(function(){
        renderAllSavedMrkers(renderedMap);//if there are saved markers
      },1000)
    }
  }
  //=============================================================================
  function saveInfo(){
    // }
    // function saveInfoNew(){
      
    if($('googleMap').checked)
    {//run if map is selected
      var allMarkerObj={},markerObjectsData=[],centerInfo=renderedMap.center.toJSON();
      console.log(markers)
      markers.forEach(function(elem,idx){
        var position=elem.position.toJSON();
        // console.log(elem.content)
        markerObjectsData.push({'lat':position.lat,'lng':position.lng,"id":elem.id,"dwrId":elem.dwrId,"content": elem.type});
      });
      allMarkerObj["center"]={'lat':centerInfo.lat,'lng':centerInfo.lng}
      allMarkerObj["zoom"]=renderedMap.zoom;
      allMarkerObj["marker"]= markerObjectsData;

      console.log(allMarkerObj)
      // console.log(typeof allMarkerObj)
      document.getElementById("viewMapData").value=JSON.stringify(allMarkerObj);
      // ViewDwr.addMapData(JSON.stringify(allMarkerObj))
    }
  }
  //---------------------------------------------------------------------------------------

  function handleClick(myRadio) {
    currentValue = myRadio.value;
    if(myRadio.value == 'backgroundImages'){
        let bgImg = document.querySelectorAll('.backgroundImage');
    
        document.querySelectorAll('.backgroundImage')[0].style.display = "table-row";
        document.querySelectorAll('.backgroundImage')[1].style.display = "table-row";
        document.querySelector('#map-area .viewBackground').removeAttribute("id","");
        document.querySelector('#viewContent .viewBackground').setAttribute("id","viewBackground");
        document.getElementById('map-area').style.display = "none";
        document.getElementById('viewContent').style.display = "block";
        document.getElementById('mapAreaOptions').innerHTML='';
        document.getElementById('componentGeneratorBtnInfo').className='img__active';
        
    } else{
        document.querySelectorAll('.backgroundImage')[0].style.display = "none";
        document.querySelectorAll('.backgroundImage')[1].style.display = "none";
        document.querySelector('#viewContent .viewBackground').removeAttribute("id","");
        document.querySelector('#map-area .viewBackground').setAttribute("id","viewBackground");
        document.getElementById('map-area').style.display = "block";
        document.getElementById('viewContent').style.display = "none";
        document.getElementById('componentGeneratorBtnInfo').className='map__active';
        initMap();
        // console.clear()
    }
    resizeViewBackgroundToResolution(document.getElementById('view.resolution').value)
  }
</script>
<! View Edit Script Ends!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!>
  <script type="text/javascript">
    mango.view.initEditView();
    mango.share.dwr = ViewDwr;

    function doOnload() {
        hide("sharedUsersDiv");
        <c:forEach items="${form.view.viewComponents}" var="vc">
          <c:set var="compContent"><sst:convert obj="${vc}"/></c:set>
          createViewComponent(${mango:escapeScripts(compContent)}, false);
        </c:forEach>
        
        ViewDwr.editInit(function(result) {
            mango.share.users = result.shareUsers;
            mango.share.writeSharedUsers(result.viewUsers);
            dwr.util.addOptions($("componentList"), result.componentTypes, "key", "value");
            settingsEditor.setPointList(result.pointList);
            compoundEditor.setPointList(result.pointList);
            MiscDwr.notifyLongPoll(mango.longPoll.pollSessionId);
        });
        
        if(document.getElementById("viewBackground").src.includes("spacer.gif")){
        	var viewSize = document.getElementById("view.resolution").value;
        	resizeViewBackgroundToResolution(viewSize);
        } else {
        	document.getElementById("view.resolution").style.visibility = 'hidden';
        	document.getElementById("sizeLabel").style.visibility = 'hidden';
        }    
    }
    function addViewComponent(overlayContainer='') {
      // document.getElementById('mapAreaOptions').innerHTML='';
      ViewDwr.addComponent($get("componentList"), function(viewComponent) {
        console.log(viewComponent)
        if(!$('googleMap').checked){
          createViewComponent(viewComponent, true);
        }
        else{
          createMapViewComponent(viewComponent,overlayContainer);
        }
          MiscDwr.notifyLongPoll(mango.longPoll.pollSessionId);
      });
    }
    // function addViewComponent() {
    //     document.getElementById('mapAreaOptions').innerHTML='';
    //     ViewDwr.addComponent($get("componentList"), function(viewComponent) {
    //         createViewComponent(viewComponent, true);
    //         MiscDwr.notifyLongPoll(mango.longPoll.pollSessionId);
    //     });
    // }
    // -------------------------------------------------
    function createMapViewComponent(viewComponent,overlayContainer) {
        var content;
          console.log($("customTemplate").cloneNode(true))

        if (viewComponent.pointComponent)
            content = $("pointTemplate").cloneNode(true);
        else if (viewComponent.defName == 'imageChart')
            content = $("imageChartTemplate").cloneNode(true);
        else if (viewComponent.defName == 'enhancedImageChart')
        	content = $("enhancedImageChartTemplate").cloneNode(true);
        else if (viewComponent.compoundComponent)
          content = $("compoundTemplate").cloneNode(true)
        else if(viewComponent.customComponent)
          {//alarm list content generator
            content = $("customTemplate").cloneNode(true)
            // alert(content)
            console.log(content)
          }
        else
            content = $("htmlTemplate").cloneNode(true);


        var selectedView = overlayContainer;
        
        configureGMapComponentContent(content, viewComponent, selectedView);


        if (viewComponent.defName == 'simpleCompound') {
            childContent = $("compoundChildTemplate").cloneNode(true);
            configureGMapComponentContent(childContent, viewComponent.leadComponent, $("c"+ viewComponent.id +"Content"));
        }
        else if (viewComponent.defName == 'imageChart')
            ;
        else if (viewComponent.defName == 'enhancedImageChart') 
        { 
        	dygraphsCharts[viewComponent.id] = new DygraphsChart(null, viewComponent.id, false, true, viewComponent);
        }
        else if (viewComponent.compoundComponent) {
            // Compound components only have their static content set at page load.
            $set(content.id +"Content", viewComponent.staticContent);
            
            // Add the child components.
            var childContent;
            for (var i=0; i<viewComponent.childComponents.length; i++) {
                childContent = $("compoundChildTemplate").cloneNode(true);
                configureGMapComponentContent(childContent, viewComponent.childComponents[i].viewComponent,
                        $("c"+ viewComponent.id +"ChildComponents"));
            }
        }
      }
    //--------------------------------------------------
    function createViewComponent(viewComponent, center) {
        var content;
        
        if (viewComponent.pointComponent)
            content = $("pointTemplate").cloneNode(true);
        else if (viewComponent.defName == 'imageChart')
            content = $("imageChartTemplate").cloneNode(true);
        else if (viewComponent.defName == 'enhancedImageChart')
        	content = $("enhancedImageChartTemplate").cloneNode(true);
        else if (viewComponent.compoundComponent)
            content = $("compoundTemplate").cloneNode(true);
        else if(viewComponent.customComponent)
        	content = $("customTemplate").cloneNode(true);
        else
            content = $("htmlTemplate").cloneNode(true);
        
        var selectedView = $('googleMap').checked ? $("mapAreaOptions") : $("viewContent");
        
        configureComponentContent(content, viewComponent, selectedView, center);


        if (viewComponent.defName == 'simpleCompound') {
            childContent = $("compoundChildTemplate").cloneNode(true);
            configureComponentContent(childContent, viewComponent.leadComponent, $("c"+ viewComponent.id +"Content"),
                    false);
        }
        else if (viewComponent.defName == 'imageChart')
            ;
        else if (viewComponent.defName == 'enhancedImageChart') {
        	dygraphsCharts[viewComponent.id] = new DygraphsChart(null, viewComponent.id, false, true, viewComponent);
        }
        else if (viewComponent.compoundComponent) {
            // Compound components only have their static content set at page load.
            $set(content.id +"Content", viewComponent.staticContent);
            
            // Add the child components.
            var childContent;
            for (var i=0; i<viewComponent.childComponents.length; i++) {
                childContent = $("compoundChildTemplate").cloneNode(true);
                configureComponentContent(childContent, viewComponent.childComponents[i].viewComponent,
                        $("c"+ viewComponent.id +"ChildComponents"), false);
            }
        }
        
        addDnD(content.id);
        
        if (center)
            updateViewComponentLocation(content.id);

    }
    function configureGMapComponentContent(content, viewComponent, parent) {
        content.id = "c"+ viewComponent.id;
        content.viewComponentId = viewComponent.id;
        updateNodeIds(content, viewComponent.id);
        if(parent)
        parent.appendChild(content);
        
        if (viewComponent.defName == "html" || viewComponent.defName == "link" 
            || viewComponent.defName == "scriptButton" || viewComponent.defName == "flex"
            	|| viewComponent.defName == "chartComparator")
            // HTML components only get updated at page load and editing.
            updateHtmlComponentContent(content.id, viewComponent.content);
        
        show(content);

    }
    function configureComponentContent(content, viewComponent, parent, center) {
      // console.log('i thnik draging started!!!')
        content.id = "c"+ viewComponent.id;
        content.viewComponentId = viewComponent.id;
        updateNodeIds(content, viewComponent.id);
        parent.appendChild(content);
        
        if (viewComponent.defName == "html" || viewComponent.defName == "link" 
            || viewComponent.defName == "scriptButton" || viewComponent.defName == "flex"
            	|| viewComponent.defName == "chartComparator")
            // HTML components only get updated at page load and editing.
            updateHtmlComponentContent(content.id, viewComponent.content);
        
        show(content);
        
        if (center) {
            // Calculate the location for the new point. For now just put it in the center.
            var bkgd = $("viewBackground");
            var bkgdBox = dojo.html.getMarginBox(bkgd);
            var compContentBox = dojo.html.getMarginBox(content);
            content.style.left = parseInt((bkgdBox.width - compContentBox.width) / 2) +"px";
            content.style.top = parseInt((bkgdBox.height - compContentBox.height) / 2) +"px";
        }
        else {
            content.style.left = viewComponent.x +"px";
            content.style.top = viewComponent.y +"px";
        }

    }
    
    function updateNodeIds(elem, id) {
        var i;
        for (i=0; i<elem.attributes.length; i++) {
            if (elem.attributes[i].value && elem.attributes[i].value.indexOf("_TEMPLATE_") != -1)
                elem.attributes[i].value = elem.attributes[i].value.replace(/_TEMPLATE_/, id);
        }
        for (var i=0; i<elem.childNodes.length; i++) {
            if (elem.childNodes[i].attributes)
                updateNodeIds(elem.childNodes[i], id);
        }
    }
    function updateHtmlComponentContent(id, content) {
        if (!content || content == "")
            $set(id +"Content", '<img src="images/html.png" alt=""/>');
        else
            $set(id +"Content", content);
    }
    function openStaticEditor(viewComponentId) {
        closeEditors();
        RemovingAllHaveContentPopupWithCurrent(viewComponentId);
        staticEditor.open(viewComponentId);
    }
    function openSettingsEditor(cid) {
        closeEditors();
        RemovingAllHaveContentPopupWithCurrent(cid);
        settingsEditor.open(cid);
    }
    function UpdateGraphicRendererImage(){
      // console.log(ActiveGraphicRendererImgSrc)
      // console.log(ActiveGraphicRendererId)
      if(ActiveGraphicRendererImgSrc)
        document.getElementById(ActiveGraphicRendererId).querySelector('img').src=ActiveGraphicRendererImgSrc;
      else{
        if(ActiveGraphicRendererId)
        document.getElementById(ActiveGraphicRendererId).querySelector('img').src="images/icon_comp.png";
      }
    }
    
    function openGraphicRendererEditor(event,cid) {
      //setting selected icons
      ActiveGraphicRendererId=event.target.closest('.controlsDiv').parentNode.getAttribute("id")+"Content";
      // console.log(event.target.closest('.controlsDiv').parentNode.getAttribute("id"))
      closeEditors(); 
      RemovingAllHaveContentPopupWithCurrent(cid);
      graphicRendererEditor.open(cid);
    }
    
    function openCompoundEditor(cid) {
      closeEditors();
      RemovingAllHaveContentPopupWithCurrent(cid);
      compoundEditor.open(cid);
    }

    function openCustomEditor(cid) {
      console.log(cid)
      closeEditors();
      RemovingAllHaveContentPopupWithCurrent(cid);
      customEditor.open(cid);
    }
    
    function positionEditor(compId, editorId) {
      // Position and display the renderer editor.
      var pDim = getNodeBounds($("c"+ compId));
      var editDiv = $(editorId);
      var eWidth = jQuery("#" + editorId).outerWidth(true);
      var scrollL = document.documentElement.scrollLeft;
      if (pDim.x < (screen.width - eWidth - pDim.w + scrollL - 10)) {
          editDiv.style.left = (pDim.x + pDim.w + 5) +"px";
          editDiv.style.top = (pDim.y) +"px";
      } else {
          editDiv.style.left = (pDim.x - eWidth - 5) + "px";
          editDiv.style.top = (pDim.y) +"px";
      }
    }

    function positionCustomEditor(compId, editorId) {
      // Position and display the renderer editor.
      var pDim = getNodeBounds($("c"+ compId));
      var editDiv = $(editorId);
      var eWidth = jQuery("#" + editorId).outerWidth(true);
      var scrollL = document.documentElement.scrollLeft;
      editDiv.style.left = (pDim.x) +"px";
      editDiv.style.top = (pDim.y + pDim.h) +"px";
    }

    function closeEditors() {
      settingsEditor.close();
      graphicRendererEditor.close();
      staticEditor.close();
      compoundEditor.close();
      customEditor.close();
    }

    function updateViewComponentLocation(divId) {
      var div = $(divId);
      var lt = div.style.left;
      var tp = div.style.top;

      // Remove the 'px's from the positions.
      lt = lt.substring(0, lt.length-2);
      tp = tp.substring(0, tp.length-2);

      // Save the new location.
      ViewDwr.setViewComponentLocation(div.viewComponentId, lt, tp);
    }

    function addDnD(divId) {
      var div = $(divId);
      var dragSource = new dojo.dnd.HtmlDragMoveSource(div);
      dragSource.constrainTo($("viewBackground"));

      // Save the drag source in the div in case it gets deleted. See below.
      div.dragSource = dragSource;
      // Also, create a function to call on drag end to update the point view's location.
      div.onDragEnd = function() {updateViewComponentLocation(divId);};

      dojo.event.connect(dragSource, "onDragEnd", div.onDragEnd);
    }

    function deleteViewComponent(viewComponentId,overlayComp='') {
      closeEditors();
      // if(removingOverlayConfirmType){
        if(confirm('Are you sure you want delete?')) {
            ViewDwr.deleteViewComponent(viewComponentId);

            var div = $("c"+ viewComponentId);
          if($('googleMap').checked){
            // var parent=div.closest('.overlay');
            // parent.removeChild(div);
            if(removingOverlayId)
            removeSelectedMarkers(removingOverlayId)
          }
          else{
            // Unregister the drag source from the DnD manager.
            div.dragSource.unregister();
            // Disconnect the event handling for drag ends on this guy.
            let selectedView = $("viewContent");
            selectedView.removeChild(div);
          }
        }
      // }
      // else{
      //   ViewDwr.deleteViewComponent(viewComponentId);
      //   var div = $("c"+ viewComponentId);
      //   if($('googleMap').checked){
      //     // var parent=div.closest('.overlay');
      //     // parent.removeChild(div);
      //     if(removingOverlayId)
      //     removeSelectedMarkers(removingOverlayId)
      //   }
      //   else{
      //     // Unregister the drag source from the DnD manager.
      //     div.dragSource.unregister();
      //     // Disconnect the event handling for drag ends on this guy.
      //     let selectedView = $("viewContent");
      //     selectedView.removeChild(div);
      //   }
      //   // alert("Something went worng!! try again.");
      // }
    }

    function getViewComponentId(node) {
        removingOverlayId=node.getAttribute('overlayId');
        removingOverlayConfirmType=parseInt(node.getAttribute('data-status'));
        // console.log(node.getAttribute('data-status'))
        // console.log(removingOverlayConfirmType)
        while (!(node.viewComponentId))
            node = node.parentNode;
        return node.viewComponentId;
    }

    function iconizeClicked() {
        ViewDwr.getViewComponentIds(function(ids) {
          console.log(ids)
            var i, comp, content;
            if ($get("iconifyCB")) {
                mango.view.edit.iconize = true;
                for (i=0; i<ids.length; i++) {
                    comp = $("c"+ ids[i]);
                    content = $("c"+ ids[i] +"Content");
                    if (comp && !comp.savedContent)
                        comp.savedContent = content.innerHTML;
                    content.innerHTML = "<img src='images/plugin.png'/>";
                }
            }
            else {
                mango.view.edit.iconize = false;
                for (i=0; i<ids.length; i++) {
                    comp = $("c"+ ids[i]);
                    content = $("c"+ ids[i] +"Content");
                    if (comp && comp.savedState)
                        mango.view.setContent(comp.savedState);
                    else if (comp && comp.savedContent)
                        content.innerHTML = comp.savedContent;
                    else
                        content.innerHTML = '';
                    comp.savedState = null;
                    comp.savedContent = null;
                }
            }
        });
    }

    function resizeViewBackground(width, height) {
      var currentWidth = $("viewBackground").width;
      var currentHeight = $("viewBackground").height;

      if(width > currentWidth) {
        $("viewBackground").width = parseInt(width,10) + 30;
      }
      if(height > currentHeight) {
        $("viewBackground").height = parseInt(height,10) + 30;
      }
    }

    function resizeViewBackgroundToResolution(size) {
      if(document.getElementById("viewBackground").src.includes("spacer.gif")){
        switch(size) {
          case "0":
            $("viewBackground").width = 640;
            $("viewBackground").height = 480;
              break;
          case "1":
            $("viewBackground").width = 800;
            $("viewBackground").height = 600;
              break;
          case "2":
            $("viewBackground").width = 1024;
            $("viewBackground").height = 768;
              break;
          case "3":
            $("viewBackground").width = 1600;
            $("viewBackground").height = 1200;
              break;
          case "4":
            $("viewBackground").width = 1920;
            $("viewBackground").height = 1080;
              break;
          default:
            $("viewBackground").width = 1600;
            $("viewBackground").height = 1200;
        }
          } else {
            document.getElementById("view.resolution").style.visibility = 'hidden';
            document.getElementById("sizeLabel").style.visibility = 'hidden';
          }

    }

    function deleteConfirm(){
      if(document.getElementById("deleteCheckbox").checked) {
        document.getElementById("deleteButton").style.visibility = 'visible';
        setTimeout(function(){
          document.getElementById("deleteCheckbox").checked = false;
          document.getElementById("deleteButton").style.visibility = 'hidden';
        }, 3000);
      } else {
        document.getElementById("deleteButton").style.visibility = 'hidden';
      }
    }
    window.onbeforeunload = confirmExit;
    function confirmExit(){
        return false;
    }
  </script>
  <script>
    function validateName(event){
      if(document.getElementById('viewNameControl').value && document.getElementById('viewNameControl').value.trim()){
        // alert('validated!');
        // return true;
      }
      else{
        alert('Please enter view name!');
        // return false;
        event.preventDefault();
      }
    }
    window.onload = function() {
      var activeView=localStorage.getItem('ViewType');
      if(ResponseOfGMapOverlayData){
        if(activeView == 'map')
        {
          document.getElementById('backgroundImages').closest('td').className="map__active";
          document.getElementById('componentGeneratorBtnInfo').className="map__active";
        }
        $('googleMap').click();
      }
      else{
        if(activeView == 'img')
        {
          document.getElementById('backgroundImages').closest('td').className="img__active";
          document.getElementById('componentGeneratorBtnInfo').className="img__active";
        }
        $('backgroundImages').dispatchEvent(new Event('change'));
      }
      console.log(ResponseOfGMapOverlayData)
    };
  </script>
  <form name="view" onsubmit="validateName(event)" class="view-edit-form" style="margin-bottom: 40px;" action="" modelAttribute="form" method="post" enctype="multipart/form-data">
    <table class="resetTable__fontSize">
      <tr>
        <td valign="top">
          <div class="borderDiv marR">
            <table>
              <tr>
                <td colspan="3">
                  <tag:img png="icon_view" title="viewEdit.editView"/>
                  <span class="smallTitle"><fmt:message key="viewEdit.viewProperties"/></span>
                  <tag:help id="editingGraphicalViews"/>
                </td>
              </tr>

              <spring:bind path="form.view.name">
                <tr>
                  <td class="formLabelRequired" width="150" ><fmt:message key="viewEdit.name"/></td>
                  <td class="formField" width="250">
                  
                    <input id="viewNameControl" type="text" name="view.name" value="${status.value}"/>
                  </td>
                  <td class="formError">${status.errorMessage}</td>
                </tr>
              </spring:bind>
              <spring:bind path="form.view.mapData">
                    <input type="hidden" name="view.mapData" id="viewMapData" value=""/>
                    <script>
                      ResponseOfGMapOverlayData='${status.value}';
                      ResponseOfGMapOverlayData=ResponseOfGMapOverlayData?JSON.parse(ResponseOfGMapOverlayData): '';
                    </script>
              </spring:bind>

              <spring:bind path="form.view.xid">
                <tr>
                  <td class="formLabelRequired" width="150"><fmt:message key="common.xid"/></td>
                  <td class="formField" width="250">
                    <input type="text" name="view.xid" value="${status.value}"/>
                  </td>
                  <td class="formError">${status.errorMessage}</td>
                </tr>
              </spring:bind>
              <tr>
                  <td class="formLabelRequired" width="150">
                    Choose view 
                  </td>
                  <td>
                      <input type="radio" checked id="backgroundImages" onchange="handleClick(this);"  name="chooseView" value="backgroundImages" v-model="chooseView">
                      <label for="backgroundImages">Background images</label>
                      <br>
                      <input type="radio" id="googleMap" onchange="handleClick(this);" name="chooseView" value="googleMap" v-model="chooseView">
                      <label for="googleMap">Google Map</label>
                      <!-- <br> -->
                      <!-- <span>chooseView: {{ chooseView }}</span> -->
                    <!-- <input type="submit" name="upload" value="<fmt:message key="viewEdit.upload"/>" onclick="window.onbeforeunload = null;"/>
                    <input type="submit" name="clearImage" value="<fmt:message key="viewEdit.clearImage"/>" onclick="window.onbeforeunload = null;"/> -->
                  </td>
                  <td></td>
                </tr>
              <spring:bind path="form.backgroundImageMP" >
                <tr class="backgroundImage">
                  <td class="formLabelRequired"><fmt:message key="viewEdit.background"/></td>
                  <td class="formField">
                    <input type="file" name="backgroundImageMP"/>
                  </td>
                  <td class="formError">${status.errorMessage}</td>
                </tr>
              </spring:bind>
              <tr class="backgroundImage">
                <td colspan="2" align="center">
                  <input type="submit" name="upload" value="<fmt:message key="viewEdit.upload"/>" onclick="window.onbeforeunload = null;"/>
                  <input type="submit" name="clearImage" value="<fmt:message key="viewEdit.clearImage"/>" onclick="window.onbeforeunload = null;"/>
                </td>
                <td></td>
              </tr>

              <spring:bind path="form.view.anonymousAccess">
                <tr>
                  <td class="formLabelRequired" width="150"><fmt:message key="viewEdit.anonymous"/></td>
                  <td class="formField" width="250">
                    <sst:select name="view.anonymousAccess" value="${status.value}">
                      <sst:option value="<%= Integer.toString(ShareUser.ACCESS_NONE) %>"><fmt:message key="common.access.none"/></sst:option>
                      <sst:option value="<%= Integer.toString(ShareUser.ACCESS_READ) %>"><fmt:message key="common.access.read"/></sst:option>
                      <sst:option value="<%= Integer.toString(ShareUser.ACCESS_SET) %>"><fmt:message key="common.access.set"/></sst:option>
                    </sst:select>
                  </td>
                  <td class="formError">${status.errorMessage}</td>
                </tr>
              </spring:bind>

              <spring:bind path="form.view.resolution">
                <tr>
                  <td id="sizeLabel" class="formLabelRequired" width="150"><fmt:message key="viedEdit.viewSize" /></td>
                  <td class="formField" width="250">
                    <sst:select id="view.resolution" name="view.resolution" value="${status.value}" onchange="resizeViewBackgroundToResolution(this.options[this.selectedIndex].value)">
                      <sst:option value="<%= Integer.toString(0) %>"> 640x480</sst:option>
                      <sst:option value="<%= Integer.toString(1) %>"> 800x600</sst:option>
                      <sst:option value="<%= Integer.toString(2) %>"> 1024x768</sst:option>
                      <sst:option value="<%= Integer.toString(3) %>"> 1600x1200</sst:option>
                      <sst:option value="<%= Integer.toString(4) %>"> 1920x1024</sst:option>
                    </sst:select>
                  </td>
                  <td class="formError">${status.errorMessage}</td>
                </tr>
              </spring:bind>
            </table>
          </div>
        </td>
        <td valign="top">
          <div class="borderDiv" id="sharedUsersDiv">
            <tag:sharedUsers doxId="viewSharing" noUsersKey="share.noViewUsers"/>
          </div>
        </td>
      </tr>
    </table>
    <table class="resetTable__fontSize">
      <tr>
        <td>
          <fmt:message key="viewEdit.viewComponents"/>:
          <select id="componentList" ></select>
          <span id="componentGeneratorBtnInfo">
            <tag:img png="plugin_add" title="viewEdit.addViewComponent" onclick="addViewComponent()"/>
            <span>Click over map to add component to view!</span>
          </span>
        </td>
        <td style="width:30px;"></td>
        <td>
          <input type="checkbox" id="iconifyCB" onclick="iconizeClicked();"/>
          <label for="iconifyCB"><fmt:message key="viewEdit.iconify"/></label>
        </td>
      </tr>
    </table>

    <table class="relative-table" class="table" width="100%" cellspacing="0" cellpadding="0">
      <tr>
        <td>
          <table class="table" cellspacing="0" cellpadding="0">
              <tr>
                  <td colspan="3">
                      <div id="mapAreaOptions" >
                        <span></span>
                      </div>
                      <div id="map-area" style="float: left;position: relative;display: block;">
                          <div id="map"  style="position: absolute;top: 0;left: 0;width: 100%;height: 100%;">
                          </div>
                          <img  class="viewBackground img-responsive" src="images/spacer.gif" alt="" 
                          style="top:1px;left:1px;"/>
                      </div>
                    <div id="viewContent" class="borderDiv" style="left:0px;top:0px;float:left;
                            padding-right:1px;padding-bottom:1px;">
                      <c:choose>
                        <c:when test="${empty form.view.backgroundFilename}">
                          <img id="viewBackground" class="viewBackground" src="images/spacer.gif" alt="" width="740" height="500"
                                  style="top:1px;left:1px;"/>
                        </c:when>
                        <c:otherwise>
                          <img id="viewBackground" class="viewBackground" src="${form.view.backgroundFilename}" alt=""
                                  style="top:1px;left:1px;"/>
                        </c:otherwise>
                      </c:choose> 
                      <div id="componentEditersRefs">
                        <%@ include file="/WEB-INF/jsp/include/staticEditor.jsp" %>
                        <%@ include file="/WEB-INF/jsp/include/settingsEditor.jsp" %>
                        <%@ include file="/WEB-INF/jsp/include/graphicRendererEditor.jsp" %>
                        <%@ include file="/WEB-INF/jsp/include/compoundEditor.jsp" %>
                        <%@ include file="/WEB-INF/jsp/include/customEditor.jsp" %>
                      </div>
                    </div>
                  </td>
                </tr>
            <tr><td colspan="3">&nbsp;</td></tr>
            <tr>
              <td colspan="2" align="center">
                <!-- <input type="button" name="saveNew" value="<fmt:message key="common.save"/>" onclick="saveInfoNew();window.onbeforeunload = null;"/> -->
                <input type="submit" name="save" value="<fmt:message key="common.save"/>" onclick="saveInfo();window.onbeforeunload = null;"/>
                <input type="submit" name="cancel" value="<fmt:message key="common.cancel"/>"/>
                <label style="margin-left:15px;"><fmt:message key="viewEdit.viewDelete"/></label>
                <input id="deleteCheckbox" type="checkbox" onclick="deleteConfirm()" style="padding-top:10px; vertical-align: middle;"/>
				        <input id="deleteButton" type="submit" name="delete" onclick="window.onbeforeunload = null; return confirm('<fmt:message key="common.confirmDelete"/>')" value="<fmt:message key="viewEdit.viewDeleteConfirm"/>" style="visibility:hidden; margin-left:15px;"/>
              </td>
              <td></td>
            </tr>
          </table>
        
          <div id="pointTemplate" onmouseover="showLayer('c'+ getViewComponentId(this) +'Controls');"
                  onmouseout="hideLayer('c'+ getViewComponentId(this) +'Controls');"
                  style="position:absolute;left:0px;top:0px;display:none;">
            <div>TEST.............................</div>
            <div id="c_TEMPLATE_Content"><img src="images/icon_comp.png" alt=""/></div>
            <div id="c_TEMPLATE_Controls" class="controlsDiv">
              <table cellpadding="0" cellspacing="1">
                <tr onmouseover="showMenu('c'+ getViewComponentId(this) +'Info', 16, 0);"
                        onmouseout="hideLayer('c'+ getViewComponentId(this) +'Info');">
                  <td>
                    <img src="images/information.png" alt=""/>
                    <div id="c_TEMPLATE_Info" onmouseout="hideLayer(this);">
                      <tag:img png="hourglass" title="common.gettingData"/>
                    </div>
                  </td>
                </tr>
                <tr><td><tag:img png="plugin_edit" onclick="openSettingsEditor(getViewComponentId(this))"
                        title="viewEdit.editPointView"/></td></tr>
                <tr><td><tag:img png="graphic" onclick="openGraphicRendererEditor(event,getViewComponentId(this))"
                        title="viewEdit.editGraphicalRenderer"/></td></tr>
                <tr><td><tag:img png="plugin_delete" onclick="deleteViewComponent(getViewComponentId(this))"
                        title="viewEdit.deletePointView"/></td></tr>
              </table>
            </div>
            <div style="position:absolute;left:-16px;top:0px;z-index:1;">
              <div id="c_TEMPLATE_Warning" style="display:none;"
                      onmouseover="showMenu('c'+ getViewComponentId(this) +'Messages', 16, 0);"
                      onmouseout="hideLayer('c'+ getViewComponentId(this) +'Messages');">
                <tag:img png="warn" title="common.warning"/>
                <div id="c_TEMPLATE_Messages" onmouseout="hideLayer(this);" class="controlContent"></div>
              </div>
            </div>
          </div>
          <div id="htmlTemplate" onmouseover="showLayer('c'+ getViewComponentId(this) +'Controls');"
                  onmouseout="hideLayer('c'+ getViewComponentId(this) +'Controls');"
                  style="position:absolute;left:0px;top:0px;display:none;">
            <div id="c_TEMPLATE_Content"></div>
            <div id="c_TEMPLATE_Controls" class="controlsDiv">
              <table cellpadding="0" cellspacing="1">
                <tr><td><tag:img png="pencil" onclick="openStaticEditor(getViewComponentId(this))"
                        title="viewEdit.editStaticView"/></td></tr>
                <tr><td><tag:img png="html_delete" onclick="deleteViewComponent(getViewComponentId(this))"
                        title="viewEdit.deleteStaticView"/></td></tr>
              </table>
            </div>
          </div>
          <div id="imageChartTemplate" onmouseover="showLayer('c'+ getViewComponentId(this) +'Controls');"
                  onmouseout="hideLayer('c'+ getViewComponentId(this) +'Controls');"
                  style="position:absolute;left:0px;top:0px;display:none;">
            <span id="c_TEMPLATE_Content"></span>
            <div id="c_TEMPLATE_Controls" class="controlsDiv">
              <table cellpadding="0" cellspacing="1">
                <tr><td><tag:img png="plugin_edit" onclick="openCompoundEditor(getViewComponentId(this))"
                        title="viewEdit.editPointView"/></td></tr>
                <tr><td><tag:img png="plugin_delete" onclick="deleteViewComponent(getViewComponentId(this))"
                        title="viewEdit.deletePointView"/></td></tr>
              </table>
            </div>
          </div>
            
          <div id="enhancedImageChartTemplate" onmouseover="showLayer('c'+ getViewComponentId(this) +'Controls');"
                  onmouseout="hideLayer('c'+ getViewComponentId(this) +'Controls');"
                  style="position:absolute;left:0px;top:0px;display:none;">
            <div id="c_TEMPLATE_Content" style="display: none;"></div>
            <div id="c_TEMPLATE_Graph" class="enhancedImageChart"></div>
            <div id="c_TEMPLATE_LegendBox" class="enhancedImageChartLegend">
            	<b><fmt:message key="graphic.enhancedImageChart.legend"/></b>
				<div id="c_TEMPLATE_Legend"></div>
            </div>
            <div id="c_TEMPLATE_Controls" class="controlsDiv">
              <table cellpadding="0" cellspacing="1">
                <tr><td><tag:img png="plugin_edit" onclick="openCompoundEditor(getViewComponentId(this))"
                        title="viewEdit.editPointView"/></td></tr>
                <tr><td><tag:img png="plugin_delete" onclick="deleteViewComponent(getViewComponentId(this))"
                        title="viewEdit.deletePointView"/></td></tr>
              </table>
            </div>
          </div>
          
          <div id="compoundTemplate" onmouseover="showLayer('c'+ getViewComponentId(this) +'Controls');"
                  onmouseout="hideLayer('c'+ getViewComponentId(this) +'Controls');"
                  style="position:absolute;left:0px;top:0px;display:none;">
            <span id="c_TEMPLATE_Content" class="componentPt"></span>
            <div id="c_TEMPLATE_Controls" class="controlsDiv">
              <table cellpadding="0" cellspacing="1">
                <tr onmouseover="showMenu('c'+ getViewComponentId(this) +'Info', 16, 0);"
                        onmouseout="hideLayer('c'+ getViewComponentId(this) +'Info');">
                  <td>
                    <img src="images/information.png" alt=""/>
                    <div id="c_TEMPLATE_Info" onmouseout="hideLayer(this);">
                      <tag:img png="hourglass" title="common.gettingData"/>
                    </div>
                  </td>
                </tr>
                <tr><td><tag:img png="plugin_edit" onclick="openCompoundEditor(getViewComponentId(this))"
                        title="viewEdit.editPointView"/></td></tr>
                <tr><td><tag:img png="plugin_delete" onclick="deleteViewComponent(getViewComponentId(this))"
                        title="viewEdit.deletePointView"/></td></tr>
              </table>
            </div>
            
            <div id="c_TEMPLATE_ChildComponents" class="wirelessTempHumSensorContent"></div>
          </div>
          
          <div id="compoundChildTemplate" style="position:absolute;left:0px;top:0px;display:none;">
            <div id="c_TEMPLATE_Content"><img src="images/icon_comp.png" alt=""/></div>
          </div>
          
          <div id="customTemplate" onmouseover="showLayer('c'+ getViewComponentId(this) +'Controls');"
                  onmouseout="hideLayer('c'+ getViewComponentId(this) +'Controls');"
                  style="position:absolute;left:0px;top:0px;display:none;">
            <div id="c_TEMPLATE_Content"></div>
            <div id="c_TEMPLATE_Controls" class="controlsDiv">
              <table cellpadding="0" cellspacing="1">
                <tr><td><tag:img png="pencil" onclick="openCustomEditor(getViewComponentId(this))"
                        title="viewEdit.editStaticView"/></td></tr>
                <tr><td><tag:img png="html_delete" onclick="deleteViewComponent(getViewComponentId(this))"
                        title="viewEdit.deleteStaticView"/></td></tr>
              </table>
            </div>
          </div>
        </td>
      </tr>
    </table>
  </form>
</tag:page>
<script>
</script>
<%@ include file="/WEB-INF/jsp/include/vue/vue-app.js.jsp"%>
<%@ include file="/WEB-INF/jsp/include/vue/vue-view.js.jsp"%>

