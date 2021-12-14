def decimalToBinary(n):
    return bin(n).replace("0b", "")

import os 

cwd = os.getcwd()
print(cwd)
assembly = open(cwd+"\code.txt", "r")
bin_code= open(cwd+"\\bin.mem","w")

bin_code.write("// memory data file (do not edit the following line - required for mem load use)\n// instance=/mips/insrcMem/ram\n// format=mti addressradix=d dataradix=b version=1.0 wordsperline=1\n"
)
num=0
for line in assembly:
  
  line=line.lower()
  table = line.maketrans(",()", "   ")
  line=line.translate(table)
  line=line.split()
  instrc=str(num)+": "

  if line[0]=="nop":
    instrc+="0000000000000000"

  elif line[0]=="hlt":
    instrc+="0000100000000000"

  elif line[0]=="setc":
    instrc+="0001000000000000"

  elif line[0]=="not":
    instrc+="00011"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrc+=3*dst+"01"

  elif line[0]=="inc":
    instrc+="00100"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrc+=3*dst+"01"

  elif line[0]=="out":
    instrc+="00101"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrc+=3*dst+"01"

  elif line[0]=="in":
    instrc+="00110"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrc+=3*dst+"00"

  elif line[0]=="mov":
    instrc+="00111"
   
    src1="000"+decimalToBinary(int(line[1][1:]))
    dst ="000"+decimalToBinary(int(line[2][1:]))
    src1=src1[len(src1)-3:]
    dst=dst[len(dst)-3:]
    instrc+=dst+2*src1+"01"

  elif line[0]=="add":
    instrc+="01000"
    src1="000"+decimalToBinary(int(line[2][1:]))
    src2="000"+decimalToBinary(int(line[3][1:]))
    dst ="000"+decimalToBinary(int(line[1][1:]))
    src1=src1[len(src1)-3:]
    src2=src2[len(src2)-3:]
    dst=dst[len(dst)-3:]
    instrc+=dst+src1+src2+"01"
  
  elif line[0]=="sub":
    instrc+="01001"
    src1="000"+decimalToBinary(int(line[2][1:]))
    src2="000"+decimalToBinary(int(line[3][1:]))
    dst ="000"+decimalToBinary(int(line[1][1:]))
    src1=src1[len(src1)-3:]
    src2=src2[len(src2)-3:]
    dst=dst[len(dst)-3:]
    instrc+=dst+src1+src2+"01"

  elif line[0]=="and":
    instrc+="01010"
    src1="000"+decimalToBinary(int(line[2][1:]))
    src2="000"+decimalToBinary(int(line[3][1:]))
    dst ="000"+decimalToBinary(int(line[1][1:]))
    src1=src1[len(src1)-3:]
    src2=src2[len(src2)-3:]
    dst=dst[len(dst)-3:]
    instrc+=dst+src1+src2+"01"

  elif line[0]=="iadd":
    instrc+="01011"
    src1="000"+decimalToBinary(int(line[2][1:]))
    src1=src1[len(src1)-3:]
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    imm ="0000000000000000"+decimalToBinary(int(line[3]))
    imm=imm[len(imm)-16:]
    num+=1
    instrc+=dst+2*src1+"11\n"+str(num)+": "+imm
  
  elif line[0]=="push":
    instrc+="01100"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrc+=3*dst+"01"

  elif line[0]=="pop":
    instrc+="01101"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrc+=3*dst+"00"
    
  elif line[0]=="ldm":
    instrc+="01110"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrc+=3*dst+"01"
    imm ="0000000000000000"+decimalToBinary(int(line[2]))
    imm=imm[len(imm)-16:]
    num+=1
    instrc+="\n"+str(num)+": "+imm

  elif line[0]=="ldd":
    instrc+="01111"
    src1="000"+decimalToBinary(int(line[3][1:]))
    src1=src1[len(src1)-3:]
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    imm ="0000000000000000"+decimalToBinary(int(line[2]))
    imm=imm[len(imm)-16:]
    num+=1
    instrc+=dst+2*src1+"11\n"+str(num)+": "+imm
  
  elif line[0]=="std":
    instrc+="10000"
    src1="000"+decimalToBinary(int(line[1][1:]))
    src1=src1[len(src1)-3:]
    src2 ="000"+decimalToBinary(int(line[3][1:]))
    src2=src2[len(src2)-3:]
    imm ="0000000000000000"+decimalToBinary(int(line[2]))
    imm=imm[len(imm)-16:]
    num+=1
    instrc+=2*src2+src1+"11\n"+str(num)+": "+imm


  
  print(line)
  print(instrc)
  bin_code.write(instrc+"\n")
  num+=1


assembly.close
bin_code.close
  

