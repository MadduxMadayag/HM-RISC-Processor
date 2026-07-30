def convert(inFile, outFile1, outFile2):
	assembly_file = open(inFile, 'r')
	machine_file = open(outFile1, 'w')
	lut_file = open(outFile2, 'w')
	#assembly = list(assembly_file.read().split('\n'))

	# Read and clean up input lines
	assembly_raw = assembly_file.read().split('\n')
	assembly = []
	for line in assembly_raw:
		line = line.strip()
		if '//' in line:
			line = line[:line.index('//')].strip()  # Remove inline comments
		if not line:
			continue  # Skip empty or comment-only lines
		assembly.append(line)

	#keep track of index and file line number
	lineNum = 0
	labelsNum = 0
	count = 1

	#dictionaries to ease conversion of opcodes/operands to binary
	opcodes = {'add' : '0000', 'and' : '0001', 'cmp' : '0010', 'lsl' : '0011',
	'lsr' : '0100', 'mov' : '0101', 'orr' : '0110', 'not' : '0111', 'ldr' : '100', 
	'str' : '101', 'bne' : '1100', 'blt' : '1101', 'ldi' : '111'}
	register = {'r0' : '0', 'r1' : '1'} 
	registersA = {'r0' : '00', 'r1' : '01', 'r2' : '10', 'r3' : '11', }
	registersB = {'r0' : '000', 'r1' : '001', 'r2' : '010', 'r3' : '011',
	'r4' : '100', 'r5' : '101', 'r6' : '110', 'r7' : '111'}

	#reads through assembly and collects labels to populate lookup table
	lut = {}
	for line in assembly:
		instr = line.split()
		
		# print(instr)
		lineNum += 1
		#check if it is a label or not
		if instr[0] not in opcodes:
			lut[instr[0].replace(':', '')] = labelsNum
			lut_file.write(format(lineNum-count, '06b') + '\n')
			labelsNum += 1
			count += 1
	

	#reads through file to convert instructions to machine code
	for line in assembly:
		output = ""
		instr = line.split(); #split to get instruction and different operands
		#make sure it is an instruction, skip over labels
		if instr[0] in opcodes:
			output += opcodes[instr[0]]
			del instr[0]
			# ldi 
			# (3) opcode (6) immediate
			if output == '111':
				imm = bin(int(instr[0]))[2:]
				#pad to 6 bits for immediate
				for i in range(0, 6-len(imm)):
					imm = '0'+imm
				output += imm
			# ldr and str
			# (3) opcode (1)register (5) address
			elif output in ('100', '101'):
				# remove commas from register operand names and check
				instr[0] = instr[0].replace(',', '')
				if instr[0] in register:
					output += register[instr[0]]
				del instr[0]
				adr = bin(int(instr[0]))[2:]
				# pad for 5 bits address
				for i in range(0, 5-len(adr)):
					adr = '0'+adr
				output += adr
			else:
			# rest of instructions
			# (4) opcode (2) registerA (3) registerB
				# remove commas from register operand names and check
				instr[0] = instr[0].replace(',', '')
				if instr[0] in registersA:
					output += registersA[instr[0]]
				del instr[0]
				if instr[0] in registersB:
					output += registersB[instr[0]]
			#write binary to machine code output file
			machine_file.write(str(output) +  '\n') #'\t// ' + line + '\n') # rewrite this to omit/add annotations

	assembly_file.close()
	machine_file.close()
	#lut_file.close()

#convert("assembly.txt", "machine.txt", "lut.txt")
convert("P3Assembly.txt", "P3MC.txt", "P3LUT.txt")
#convert("cordic.txt", "c_machine.txt", "c_lut.txt")
#convert("division.txt", "d_machine.txt", "d_lut.txt")