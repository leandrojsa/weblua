<?xml version="1.0" encoding="ISO-8859-1"?>

<ncl id="main" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
	<head>
		<regionBase>			
			<region id="rgLua" width="100%" height="30%" top="70%" left="0" zIndex="1" />				
		</regionBase>
		
		<descriptorBase>
			<descriptor id="dLua" region="rgLua" focusIndex="luaIdx" />	
		</descriptorBase>	
		
		<connectorBase>
			<causalConnector id="onEndStart">
				<simpleCondition role="onEnd"/>
				<simpleAction role="start"/>
			</causalConnector>	
			
			<causalConnector id="onKeySelectionStop">
				<connectorParam name="key"/>
				<simpleCondition role="onSelection" key="$key"/>
				<simpleAction role="stop"/>
			</causalConnector>
			
			<causalConnector id="onBeginStop">
				<simpleCondition role="onBegin"/>
				<simpleAction role="stop"/>
			</causalConnector>
		</connectorBase>			
	</head>

	<body>
		<port id="pLua" component="lua"/>
		
		<media type="application/x-ginga-settings" id="programSettings">
	        <property name="service.currentKeyMaster" value="luaIdx"/>
		</media>
		
		<media id="lua" descriptor="dLua" src="example_twitter.lua" >
			<!--<area id="fechar"/> -->
		</media>
		
		<link xconnector="onEndStart">
			<bind component="video1" role="onEnd" />
			<bind component="video1" role="start" />				
		</link>
		
		<!--
		<link xconnector="onBeginStop">
			<bind component="lua" role="onBegin" interface="fechar" />
			<bind component="lua" role="stop" />
		</link>
		-->
		
		<link xconnector="onKeySelectionStop">
			<bind component="lua" role="onSelection">
				<bindParam name="key" value="RED"/>
			</bind>
			<bind component="lua" role="stop" />
		</link>
	</body>
</ncl>
