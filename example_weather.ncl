<?xml version="1.0" encoding="ISO-8859-1"?>
<ncl id="exemplo0" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
    <head>
        <regionBase>
            <region id="rgWidgetBackground" width="462px" height="134px" zIndex="1" left="40%" top="80%" />
            <region id="rgLua" width="100%" height="100%" />
            <region id="rgInfo" left="92.5%" top="91.7%" width="5.07%" height="6.21%" zIndex="2"/>
        </regionBase>
        
        <descriptorBase>
            <descriptor id="dLua" region="rgLua" focusIndex="luaIdx" />
            <descriptor id="dWidgetBackground" region="rgWidgetBackground" />
            <descriptor id="dInfo" region="rgInfo"/>
        </descriptorBase>
    
        <connectorBase>
        
            <causalConnector id="onBeginStop">
				<simpleCondition role="onBegin"/>
				<simpleAction role="stop"/>
			</causalConnector>
        
            <causalConnector id="onEndStart">
				<simpleCondition role="onEnd"/>
				<simpleAction role="start"/>
			</causalConnector>	
        
            <causalConnector id="onEndStop">
		          <simpleCondition role="onEnd"/>
		          <simpleAction role="stop"/>
	         </causalConnector>
	         
            <causalConnector id="onKeySelectionStart">
				<connectorParam name="key"/>
				<simpleCondition role="onSelection" key="$key"/>
    			    <simpleAction role="start" max="unbounded" qualifier="par"/>
			</causalConnector>
        
            <causalConnector id="onKeySelectionStop">
				<connectorParam name="key"/>
				<simpleCondition role="onSelection" key="$key"/>
    			    <simpleAction role="stop" max="unbounded" qualifier="par"/>
			</causalConnector>
        </connectorBase>
    </head>

    <body id="corpo">
        <port id="pInfo" component="info"/>
        <port id="pLua" component="lua" />
        
        <media id="settings" type="application/x-ginga-settings">
            <property name="service.currentKeyMaster" value="luaIdx"/>
        </media>
        
		<media id="info" src="media/info.png" descriptor="dInfo"/>
        <media id="background" src="media/widget_background.png" descriptor="dWidgetBackground" />
        
        <media id="lua" src="example_weather.lua" descriptor="dLua" />
        
        <link xconnector="onKeySelectionStart">
			<bind component="info" role="onSelection">
				<bindParam name="key" value="YELLOW"/>
			</bind>
			<bind component="background" role="start" />
		</link>
        
        <link xconnector="onKeySelectionStop">
			<bind component="background" role="onSelection">
				<bindParam name="key" value="RED"/>
			</bind>
			<bind component="background" role="stop" />
		</link>
		
		 <link xconnector="onBeginStop">
	         <bind role="onBegin" component="background" />
	         <bind role="stop" component="info" />
        </link>

        <link xconnector="onEndStop">
	         <bind role="onEnd" component="background" />
	         <bind role="stop" component="info" />
        </link>
    </body>
</ncl>
