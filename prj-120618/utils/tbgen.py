#! /usr/bin/python

'''
Created on 2010-4-23

@author: Xiongfei(Alex) Guo
'''

import re
import sys

class tbgen(object):
	'''
	verilog test bench auto generation
	'''


	def __init__(self, vfile_name = None, ofile_name = None):
		self.vfile_name = vfile_name
		self.vfile = None
		self.ofile_name = ofile_name
		if(ofile_name == None):
			self.ofile = sys.stdout
		self.vcont = ""
		self.mod_name = ""
		self.pin_list = []
		self.clock_name = 'clk'
		self.reset_name = 'rst'
		
		if vfile_name == None:
			sys.stderr.write("ERROR: You aren't specfic a input file name.\n")
			sys.exit(1)
		else:
			self.open()
		self.parser()
		self.open_outputfile()

	def open(self, vfile_name = None):
		if vfile_name != None:
			self.vfile_name = vfile_name
			
		try:
			self.vfile = open(self.vfile_name, 'r')
			self.vcont = self.vfile.read() 
		except Exception, e:
			print "ERROR:Open and read file error.\n ERROR:\t%s" % e
			sys.exit(1)
			
	def open_outputfile(self, ofile_name = None):
		try:
			if(ofile_name == None):
				if(self.ofile_name == None):
					ofname = "tb_%s.v" % self.mod_name
					self.ofile = open(ofname, 'w')
					print "Your are not specify a output file name, use '%s' instead." % ofname 
				else:
					self.ofile = open(self.ofile_name, 'w')
					print "Output file is '%s'." % self.ofile_name
			else:
				self.ofile = open(ofile_name, 'w')
				print "Output file is '%s'." % ofile_name
		except Exception, e:
			print "ERROR:open and write output file error. \n ERROR:\t%s" % e
			sys.exit(1)
				
	def clean_other(self, cont):
		## clean '// ...'
		cont = re.sub(r"//[^\n^\r]*", '\n', cont)
		## clean '/* ... */'
		cont = re.sub(r"/\*.*\*/", '', cont)
		## clean '`define ..., etc.'
		#cont = re.sub(r"[^\n^\r]+`[^\n^\r]*", '\n', cont)
		## clean tables
		cont = re.sub(r'\t+', ' ', cont)
		## clean '\n' * '\r'
		#cont = re.sub(r'[\n\r]+', '', cont)
		return cont
		
	def parser(self):
		print "Parsering..."
		# print vf_cont 
		mod_pattern = r"module[\s]+(\S*)[\s]*\([^\)]*\)[\s\S]*"  
		
		module_result = re.findall(mod_pattern, self.clean_other(self.vcont))
		#print module_result
		self.mod_name = module_result[0]
		
		self.parser_inoutput()
		self.find_clk_rst()
			 
	
	def parser_inoutput(self):
		pin_list = self.clean_other(self.vcont) 
		#print pin_list
		comp_pin_list_pre = []
		for i in re.findall(r'(input|output|inout)[\s]+([^;,]+)[\s]*[;,\)]', pin_list):
			comp_pin_list_pre.append((i[0], re.sub(r"^reg[\s]*", "", i[1])))
			
		comp_pin_list = []
		type_name = ['reg', 'wire', 'wire', "ERROR"]
		for i in comp_pin_list_pre:
			x = re.split(r']', i[1])
			type = 0;
			if i[0] == 'input':
				type = 0
			elif i[0] == 'output':
				type = 1
			elif i[0] == 'inout':
				type = 2
			else:
				type = 3

			if len(x) == 2:
				x[1] = re.sub('[\s]*', '', x[1])
				comp_pin_list.append((i[0], x[1], x[0] + ']', type_name[type]))
			else:
				comp_pin_list.append((i[0], x[0], '', type_name[type]))
		
		self.pin_list = comp_pin_list
		# for i in self.pin_list: print i
		
	def print_dut(self):
		max_len = 0
		for cpin_name in self.pin_list:
			pin_name = cpin_name[1]
			if len(pin_name) > max_len:
				max_len = len(pin_name)
		
		
		self.printo( "%s uut (\n" % self.mod_name )
		self.printo( "\t.%s %s( %s )" % (self.pin_list[0][1], ' ' * (max_len - len(self.pin_list[0][1])), self.pin_list[0][1]) )
		for cpin_name in self.pin_list[1:]:
			pin_name = cpin_name[1]
			self.printo( ",\n\t.%s %s( %s )" % (pin_name, ' ' * (max_len - len(pin_name)), pin_name) )
		self.printo( "\n);\n" )
		
	def print_wires(self):
		# calculate length
		max_len = 0;
		for cpin_name in self.pin_list:
			pin_name = cpin_name[2]
			
			if len(pin_name) > max_len:
				max_len = len(pin_name)
		for cpin_name in self.pin_list:
			self.printo("%s\t%s%s%s;\n" % (cpin_name[3], cpin_name[2], '\t' * ((max_len/8 - len(cpin_name[2])/8)+1), cpin_name[1]))
		
		self.printo("\n");
	def print_clock_gen(self):
		fsdb = "\t$fsdbDumpfile(\"db_tb_%s.fsdb\");\n\t$fsdbDumpvars(0, tb_%s);\n" % (self.mod_name, self.mod_name)

		clock_gen_text = "\nparameter PERIOD = 10;\n\ninitial begin\n%s\tCLK = 1'b0;\n\t#(PERIOD/2);\n\tforever\n\t\t#(PERIOD/2) CLK = ~CLK;\nend\n\n" % fsdb
		self.printo(re.sub('CLK', self.clock_name, clock_gen_text))
		
	def find_clk_rst(self):
		for pin in self.pin_list:
			if re.match(r'[\S]*(clk|clock)[\S]*', pin[1]):
				self.clock_name = pin[1]
				print "I think your clock signal is '%s'." % pin[1]
				break

		for pin in self.pin_list:
			if re.match(r'rst|reset', pin[1]):
				self.reset_name = pin[1]
				print "I think your reset signal is '%s'." % pin[1]
				break

	def print_module_head(self):
		self.printo("`include \"timescale.v\"\nmodule tb_%s;\n\n" % self.mod_name)
		
	def print_module_end(self):
		self.printo("endmodule\n")

	def printo(self, cont):
		self.ofile.write(cont)
		
	def close(self):
		if self.vfile != None:
			self.vfile.close()
		print "Output finished.\n\n"
		

if __name__ == "__main__":
	print "***************** tbgen - Auto generate a testbench. *****************\nauthor: Xiongfei(Alex) G.\n"  
	ofile_name = None
	if len(sys.argv) == 1:
		sys.stderr.write("ERROR: You aren't specfic a input file name.\n")
		print "Usage: tbgen input_verilog_file_name [output_testbench_file_name]"
		sys.exit(1)
	elif len(sys.argv) == 3:
		ofile_name = sys.argv[2]
		
	tbg = tbgen(sys.argv[1], ofile_name)

	tbg.print_module_head()
	tbg.print_wires()
	tbg.print_dut()
	tbg.print_clock_gen()
	tbg.print_module_end()
	tbg.close()
