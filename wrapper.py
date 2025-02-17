#wrapper for pre processor so we dont lose our xml tree upon crash
import sys
import preprocess as pre
from importlib import reload
#import time
import traceback
import xml.etree.ElementTree as ET

xml_file = 'map.xml'
print("start xml parse")
tree = ET.parse(xml_file)
print("end xml parse")

if __name__ == "__main__":
    while True:
        #we load our gdfs, into ram in wrapper so we can edit
        #main script and not need to waste time loading data (for dev when i need to fix bugs faster)
        #these methods should never take parameters (unless they are file names), their job is ONLY to load the data
        #and keep it in this extra python process
        #all the processing and plotting is done in makeGraphs
        print("Starting process!")
        #used to have other pre prcoess steps here
        
        print("Starting main!")
        try:
            pre.createPreProcessFiles(tree)
        except:
            # import module 
            print("pre has failed")
            traceback.print_exc()
        print("Press enter to re-run the script, CTRL-C to exit")
        sys.stdin.readline()
        reload(pre)#asks python to load the new code