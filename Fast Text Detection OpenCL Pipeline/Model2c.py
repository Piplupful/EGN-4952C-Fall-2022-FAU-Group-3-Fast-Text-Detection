import re,sys,os,math
from collections import defaultdict

IntList = ['X','Y','AVGQUADRANT_MACRO_VALUE','AVG_MACRO_VALUE', 'RANGE_MACRO_VALUE', 'MAX_MACRO_VALUE', 'MIN_MACRO_VALUE']

if len(sys.argv)<2:
    sys.exit('Usage: %s weka-text-tree-source' % sys.argv[0])

if not os.path.exists(sys.argv[1]):
    sys.exit('ERROR: File %s was not found!(nub)' % sys.argv[1])

logfile = open(sys.argv[1], "r").readlines()   
rownum=1
lastdepths=defaultdict() #GLOBAL VAR USED AS SUCH
vartypes=defaultdict() #GLOBAL VAR USED AS SUCH
prevdepth=-1;
braces=0                #GLOBAL VAR USED AS SUCH
conditionals=""
returntype=""           #GLOBAL VAR USED AS SUCH
indent_style="    "
base=indent_style #yeah, some people might have this be different...
treeCount= 1
mainFunction=""
internals=""
footer=""
fulloutput=""

#def header():
#    return "#include <iostream>\n\nusing namespace std;\n\n"
def header():
    return "\n"
def header2():
    hdr = '''// Copyright (c) 2019-2020 Intel Corporation
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <functional>
#include <set>

#include "av1_scd.h"

#if defined(ENABLE_ADAPTIVE_ENCODE)

namespace aenc {'''
    return hdr
def footerEnd():
    foot = '''
        return(sum > RF_DECISION_LEVEL + control);
    }
}
#endif // ENABLE_ADAPTIVE_ENCODE
'''
    return foot
def mainFHeader(treeCount):
    fh =  "\n    bool DTC(\n"
    fh += "        int X,   int Y,   int AVGQUADRANT_MACRO_VALUE,   int AVG_MACRO_VALUE,       int RANGE_MACRO_VALUE,\n"
    fh += "        int MAX_MACRO_VALUE,       int MIN_MACRO_VALUE\n"
    fh += "        const int RF_DECISION_LEVEL = {};\n\n".format(int(math.floor(treeCount / 2)))
    return fh

def formatString(data):
    return '{:1}'.format(data)

def functionCall(funcname,vartypes):
    fc = " "+ funcname + "("
    numvars = (len(vartypes.items()))
    i=1
    for name in vartypes:
        fct=vartypes[name]+" "+name
        if (i<numvars):
            fct+=", "
        else:
            fct+=") {\n"
        fc+=formatString(fct)
        i+=1
    return fc
def functionCall2(funcname,vartypes):
    fc2 = "        sum += "+ funcname + "("
    numvars = (len(vartypes.items()))
    i=1
    for name in vartypes:
        fct=name
        if (i<numvars):
            fct+=", "
        else:
            fct+=");\n"
        fc2+=fct
        i+=1
    return fc2

def getResult(line):
    global returntype
    res=""
    if (line.count(":")>0):
        remainder = (line[(line.find(":")):len(line)])
        res = ((re.search(r'[\d\w.-]+',remainder)).group())
        ret = re.search(r'[a-zA-Z]',res)
        if ret or returntype=="string":
            returntype="string"
            return base+indent + indent_style+"binMap[i] = \"" + res +"\";\n"
        else:
            signloc = res.rfind("-")
            if (signloc>0):
                returntype="string"
            else:
                if (returntype!="string"):
                    returntype="bool"
            return base+indent + indent_style+"binMap[i] = "  + res +";\n"

def eofBraces(braces,prevdepth): #not so sure about this, n2b tested
    i=0
    eof=""
    while (braces>0):
        indent_size = (prevdepth-i)*indent_style
        eof+=base+indent_size+"}\n"
        i+=1
        braces-=1
    return eof

def closingBraces():
    global lastdepths
    global braces
    ndeps = defaultdict() #temp dictionary for modification
    cbraces=""
    for dep in sorted(lastdepths.items(),reverse=True):
        if (depth<dep[0]):
            affix = base
            for i in range(dep[0]):
                affix+=indent_style
            cbraces+=affix+"}\n"
            braces-=1
        else:
            ndeps[dep[0]] = lastdepths[dep[0]]
    lastdepths = ndeps
    return cbraces

def checkType(num):
    stringtype = re.search(r'[a-zA-Z]',num)
    if stringtype:
        return "string"
    else:
        signloc = num.find("-")
        if (signloc>0):
            return "string"
        else:
            return "mfxU32"

def checkType2(varname):
    if(varname in IntList):
        return "int"
    #elif(varname in mfxI16List):
    #    return "mfxI16"

def buildLine(line):
    global vartypes
    varname=((re.search(r'[-_\w]+',line)).group())
    oper=((re.search(r'[<=>]+',line)).group())
    postop = (line[(line.find(oper)):len(line)])
    num=((re.search(r'[\d.\w-]+',postop)).group())
    #vartypes[varname] = checkType(num)
    vartypes[varname] = checkType2(varname)
    if vartypes[varname] == "string":
        num="\""+num+"\""
    if oper=="=":
        oper="=="
    full="if ("+varname+" "+oper+" "+num+")"
    return full;

def indentSize(depth):
    return indent_style*depth

def checkHeader(line):
    data = re.search(r' [<=>]* ',line)
    if(data):
        return 1
    else:
        return 0;

def checkEndTree(line, onTree):
    if(onTree):
        if(line == "\n"):
            return 1
        else:
            return 0
    else:
        return 0;

## "MAIN"

onTree = 0
output=header()
footer = footerEnd()
for line in logfile:
    if(checkHeader(line)):
        onTree = 1
        depth=(line.count("|"))+1
        indent=indentSize(depth)
        prefix=""
        conditionals+=closingBraces()
        if (depth in lastdepths):
            full=base+indent+"}\n"+base+indent+"else "
            conditionals+=(prefix+full)
        else:
            braces+=1
            conditionals+=base+indent
        res=""
        lastdepths[depth]=rownum
        conditionals+=(buildLine(line)+" {\n")
        result = getResult(line)
        if result:
            conditionals+=result
        prevdepth=depth
        rownum+=1
    elif(checkEndTree(line, onTree)):
        onTree = 0
        conditionals+=eofBraces(braces,prevdepth)
        #file header bs
        output+="    "+returntype + functionCall("DTC"+hex(treeCount).split('x')[1].upper(),vartypes)
        output+=conditionals+base+"    //return 0;\n    }"
        output+=header()
        internals+=functionCall2("DTC"+hex(treeCount).split('x')[1].upper(),vartypes)
        lastdepths = defaultdict() #GLOBAL VAR USED AS SUCH
        prevdepth=-1;
        braces=0                #GLOBAL VAR USED AS SUCH
        conditionals=""
        returntype=""           #GLOBAL VAR USED AS SUCH
        treeCount+=1
        vartypes.clear()

if(onTree):
    conditionals+=eofBraces(braces,prevdepth)
    #file header bs
    output+="    " + returntype + functionCall("DTC"+hex(treeCount).split('x')[1].upper(),vartypes)
    output+=conditionals+base+"    //return 0;\n    }"
    output+=header()
    internals+=functionCall2("DTC"+hex(treeCount).split('x')[1].upper(),vartypes)
output+=mainFHeader(treeCount)
output+=internals+footer
fulloutput=header2()
fulloutput+=output
outname=sys.argv[1]+".cpp"
outfile=open(outname,"w")
outfile.write(fulloutput)
print(output)