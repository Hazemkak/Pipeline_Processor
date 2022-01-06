
def decimalToBinary(n):
    return bin(n).replace("0b", "")

import os 

cwd = os.getcwd()
print(cwd)
file=open(cwd+"\code.txt", "r")
assembly = file.readlines()
bin_code= open(cwd+"\\bin.mem","w")
datamem= open(cwd+"\\data.mem","w")

bin_code.write("// memory data file (do not edit the following line - required for mem load use)\n// instance=/mips/insrcMem/ram\n// format=mti addressradix=d dataradix=b version=1.0 wordsperline=1\n"
)
datamem.write("// memory data file (do not edit the following line - required for mem load use)\n// instance=/mips/memo/ram_arr\n// format=mti addressradix=d dataradix=h version=1.0 wordsperline=1\n"
)

instrcss= ["0000000000000000" for _ in range(1048576)]
data= ["0000" for _ in range(1048576)]
instrcss[0]="1100100000000000"

num =0

c=0
for i in range(len(assembly)):
  
  if(c):
    c=0
    continue
  
  line = assembly[i]
  line=line.lower()
  table = line.maketrans(",()", "   ")
  line=line.translate(table)
  line=line.split()
  if(not line):
    continue
  if(line[0]=="#"):
    continue
  if(line[0].startswith("#")):
    continue

  if (line[0]==".org"):
    if(int(line[1],16)<=8):
      i+=1
      addr=assembly[i]
      addr=addr.translate(table)
      addr=addr.split()
      addr="0000"+addr[0]
      addr=addr[len(addr)-4:]
      data[int(line[1],16)]=addr
      c=1
      
    else:
      num=int(line[1],16)

    continue


  if line[0]=="nop":
    instrcss[num]="0000000000000000"

  elif line[0]=="hlt":
    instrcss[num]="0000100000000000"

  elif line[0]=="setc":
    instrcss[num]="0001000000000000"

  elif line[0]=="not":
    instrcss[num]="00011"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"01"

  elif line[0]=="inc":
    instrcss[num]="00100"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"01"

  elif line[0]=="out":
    instrcss[num]="00101"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"01"

  elif line[0]=="in":
    instrcss[num]="00110"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"00"

  elif line[0]=="mov":
    instrcss[num]="00111"
   
    src1="000"+decimalToBinary(int(line[1][1:]))
    dst ="000"+decimalToBinary(int(line[2][1:]))
    src1=src1[len(src1)-3:]
    dst=dst[len(dst)-3:]
    instrcss[num]+=dst+2*src1+"01"

  elif line[0]=="add":
    instrcss[num]="01000"
    src1="000"+decimalToBinary(int(line[2][1:]))
    src2="000"+decimalToBinary(int(line[3][1:]))
    dst ="000"+decimalToBinary(int(line[1][1:]))
    src1=src1[len(src1)-3:]
    src2=src2[len(src2)-3:]
    dst=dst[len(dst)-3:]
    instrcss[num]+=dst+src1+src2+"01"
  
  elif line[0]=="sub":
    instrcss[num]="01001"
    src1="000"+decimalToBinary(int(line[2][1:]))
    src2="000"+decimalToBinary(int(line[3][1:]))
    dst ="000"+decimalToBinary(int(line[1][1:]))
    src1=src1[len(src1)-3:]
    src2=src2[len(src2)-3:]
    dst=dst[len(dst)-3:]
    instrcss[num]+=dst+src1+src2+"01"

  elif line[0]=="and":
    instrcss[num]="01010"
    src1="000"+decimalToBinary(int(line[2][1:]))
    src2="000"+decimalToBinary(int(line[3][1:]))
    dst ="000"+decimalToBinary(int(line[1][1:]))
    src1=src1[len(src1)-3:]
    src2=src2[len(src2)-3:]
    dst=dst[len(dst)-3:]
    instrcss[num]+=dst+src1+src2+"01"

  elif line[0]=="iadd":
    instrcss[num]="01011"
    src1="000"+decimalToBinary(int(line[2][1:]))
    src1=src1[len(src1)-3:]
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    imm ="0000000000000000"+decimalToBinary(int(line[3],16))
    imm=imm[len(imm)-16:]
    instrcss[num]+=dst+2*src1+"11"
    num+=1
    instrcss[num]=imm

  elif line[0]=="push":
    instrcss[num]="01100"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"01"

  elif line[0]=="pop":
    instrcss[num]="01101"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"00"
    
  elif line[0]=="ldm":
    instrcss[num]="01110"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"10"
    imm ="0000000000000000"+decimalToBinary(int(line[2],16))
    imm=imm[len(imm)-16:]
    num+=1
    instrcss[num]=imm

  elif line[0]=="ldd":
    instrcss[num]="01111"
    src1="000"+decimalToBinary(int(line[3][1:]))
    src1=src1[len(src1)-3:]
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    imm ="0000000000000000"+decimalToBinary(int(line[2],16))
    imm=imm[len(imm)-16:]
    instrcss[num]+=dst+2*src1+"11"
    num+=1
    instrcss[num]=imm
    
  
  elif line[0]=="std":
    instrcss[num]="10000"
    src1="000"+decimalToBinary(int(line[1][1:]))
    src1=src1[len(src1)-3:]
    src2 ="000"+decimalToBinary(int(line[3][1:]))
    src2=src2[len(src2)-3:]
    imm ="0000000000000000"+decimalToBinary(int(line[2],16))
    imm=imm[len(imm)-16:]
    instrcss[num]+=2*src1+src2+"11"
    num+=1
    instrcss[num]=imm

  elif line[0]=="jz":
    instrcss[num]="10001"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"01"

  elif line[0]=="jn":
    instrcss[num]="10010"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"01"

  elif line[0]=="jc":
    instrcss[num]="10011"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"01"

  elif line[0]=="jmp":
    instrcss[num]="10100"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"01"

  elif line[0]=="call":
    instrcss[num]="10101"
    dst ="000"+decimalToBinary(int(line[1][1:]))
    dst=dst[len(dst)-3:]
    instrcss[num]+=3*dst+"01"

  elif line[0]=="ret":
    instrcss[num]="10110"
    instrcss[num]+=3*"000"+"00"

  
  elif line[0]=="int":
    instrcss[num]="10111"
    dst ="000"
    instrcss[num]+=3*dst+"10"
    imm ="0000000000000000"+decimalToBinary(int(line[1]))
    imm=imm[len(imm)-16:]
    num+=1
    instrcss[num]=imm

  elif line[0]=="rti":
    instrcss[num]="11000"
    instrcss[num]+=3*"000"+"00"

  elif line[0]=="reset":
    instrcss[num]="11001"
    instrcss[num]+="000"*3+"00"

  else:
    instrcss[num]="0000000000000000"

  
  print(line)
  print(num ,": ",instrcss[num])
  
  num+=1



for n in range(1048576):
  bin_code.write(f"{n}: "+instrcss[n]+"\n")
  datamem.write(f"{n}: "+data[n]+"\n")

datamem.close
file.close
bin_code.close
  

