#not run at runtime, its used to preprocess openmap data
#using line relation data, we output platform data and line data
#uses data from https://www.openstreetmap.org/relation/3494092#map=11/47.5976/-122.2954&layers=T
import xml.etree.ElementTree as ET

def find_node_by_id(root, node_id):
    for node in root.findall('relation'):
        if node.get('id') == node_id:
            return node
    return None

def parseXML():
    xml_file = 'map.xml'
    print("start xml parse")
    tree = ET.parse(xml_file)
    print("end xml parse")
    return tree

#tree = parseXML() #loaded wrapper.py

def createPreProcessFiles(tree):
    root = tree.getroot()
    node_id = '3494092'#id="3494092"
    print("searching for node")
    node = find_node_by_id(root, node_id)

    if node is not None:
        print(f"Found node: {node.attrib}")
        
        platformsref = set()
        wayref = set()
        #my code can be mid as long as its a pre process trust
        
        print("locating platforms and way")
        for i in node.findall('member'):
            if i.get('type') == "node" and i.get('role') == "stop": #long lat, for station
                platformsref.add(i.get('ref'))
                print("platform found! " + i.get('ref'))
            elif i.get('type') == "way":
                if i.get('role') == "": #ignore platforms for now
                    wayref.add(i.get('ref'))
                    print("way found! " + i.get('ref'))
            '''
            <member type="node" ref="11806157928" role="stop"/>
            <member type="way" ref="1311417976" role="platform"/>
            <member type="way" ref="34746781" role=""/>
            '''

        #now that we found the relation node for the tram line, we need to get all the platforms
        print("writing platforms")
        with open("platfroms.txt",'w') as platforms:
            for i in root.findall('node'):
                if i.get('id') in platformsref:
                    for j in i.findall('tag'):
                        if j.get('k') == 'name':
                            platforms.write('"'+j.get('v')+'",'+i.get('lat')+','+i.get('lon')+"\n")
        print("wrote platforms!\nstarting node search")
        platformsref = 0

        nodedict = dict()
        noderef = set()

        for i in root.findall('way'):
            if i.get('id') in wayref:
                for j in i.findall('nd'):
                    ref = j.get('ref')
                    print("adding node" + ref)
                    noderef.add(ref)
                    nodedict[ref] = i.get('id')
                        #platforms.write('"'+j.get('v')+'",'+i.get('lat')+','+i.get('lon')+"\n")
        print("wrote nodes\n writing final dictionary")
        wayout = dict()
        with open("segments2.txt",'w') as segments:
            for i in root.findall('node'):
                if i.get('id') in noderef:
                    nodedict[i.get('id')] #comes out with way relation
                    wayout.setdefault(nodedict[i.get('id')],list()).append({"lat":i.get('lat'),"lon":i.get('lon')})
                    out = ET.tostring(i, encoding='unicode')
                    segments.write(out)
        print("wrote dictionary")
        wayref = 0
        nodedict = 0
        noderef = 0
        '''
        print("writing segments")
        with open("segments.txt",'w') as segments:
            out = ""
            for i in wayout.keys(): #scuffed but i dont care
                out += i + ","
                for j in wayout[i]:
                    out += str(j) + ","
                segments.write(out + "\n")
        print("wrote segments")
        '''
        print("done!")
        #wow thats really cursed, il probably shove it into json tmr or smth

        #then we need to get all the ways and all the points in the way, then write the points to a file 

        '''
        <member type="node" ref="11806157928" role="stop"/> turns into below
        <node id="11806157928" lat="47.8157347" lon="-122.2944665" version="4" timestamp="2024-08-31T07:05:15Z" changeset="156001224" uid="21016429" user="Jimmyisawkward">
            <tag k="description" v="Lynnwood from Angle Lake"/>
            <tag k="gtfs:feed" v="US-WA-ST"/>
            <tag k="gtfs:stop_id" v="N23-T1"/>
            <tag k="light_rail" v="yes"/>
            <tag k="name" v="Lynnwood City Center"/>
        '''
        '''
        <member type="way" ref="34746781" role=""/> turns into below
        <way id="34746781" version="35" timestamp="2024-08-31T11:55:12Z" changeset="156011690" uid="9159276" user="OrdinaryScarlett">
            <nd ref="4396958143"/>
            ....
            <tag k="bridge" v="yes"/>
            <tag k="electrified" v="contact_line"/>
            <tag k="frequency" v="0"/>
            <tag k="gauge" v="1435"/>
            <tag k="layer" v="3"/>
            <tag k="maxspeed" v="55 mph"/>
            <tag k="name" v="1 Line"/>
            <tag k="operator" v="Sound Transit"/>
            <tag k="operator:short" v="ST"/>
            <tag k="operator:wikidata" v="Q3965367"/>
            <tag k="operator:wikipedia" v="en:Sound Transit"/>
            <tag k="railway" v="light_rail"/>
            <tag k="railway:preferred_direction" v="forward"/>
            <tag k="voltage" v="1500"/>
        '''
        '''
        <nd ref="4396958143"/> turns into
        <node id="1768008161" lat="47.4519794" lon="-122.3001860" version="2" timestamp="2016-02-13T22:17:26Z" changeset="37195479" uid="2601744" user="sctrojan79"/>
        '''
    else:
        print("Node not found")
