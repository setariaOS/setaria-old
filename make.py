import os
import shutil
import sys

def preprocessor(type):
	need_preprocessor_files = [ "./kernel/makefile" ]

	include_files = { "kernel:entrypoint":"" }

	if type == "x86-64":
		f = open("./make/kernel_entrypoint64", "r")
		include_files["kernel:entrypoint"] = f.read()
		f.close()

	for path in need_preprocessor_files:
		f = open(path, "r")
		f_text = f.read()
		f.close()

		for key, value in include_files.items():
			preprocessor = "<<include|" + key + ">>"
			f_text = f_text.replace(preprocessor, value)
		
		f = open(path, "w")
		f.write(f_text)
		f.close()

def do_run(type):
	if type == "x86-64":
		f = open("./run.bat", "w")
		f.write("qemu-system-x86_64 -L . -m 64 -fda ./setaria.img -localtime -M pc")
		f.close()

def do_m64():
	shutil.copy(os.path.join("./make", "root64"), "./")
	os.rename("root64", "makefile")

	shutil.copy(os.path.join("./make", "buildtool64"), "./")
	os.rename("buildtool64", "buildtool")

	shutil.copy(os.path.join("./make", "boot64"), "./boot")
	os.rename("./boot/boot64", "./boot/makefile")

	shutil.copy(os.path.join("./make", "kernel64"), "./kernel")
	os.rename("./kernel/kernel64", "./kernel/makefile")

def do_clean():
	if os.path.isfile("makefile"):
		os.remove("makefile")

	if os.path.isfile("buildtool"):
		os.remove("buildtool")

	if os.path.isfile("./boot/makefile"):
		os.remove("./boot/makefile")

	if os.path.isfile("./kernel/makefile"):
		os.remove("./kernel/makefile")

	if os.path.isfile("./run.bat"):
		os.remove("./run.bat")

if len(sys.argv) == 1:
	print("Fatal: No command lines. You can see a list of command lines that can be used as '--help' command line.")
	sys.exit(0)

if len(sys.argv) == 2:
	if sys.argv[1] == "--help":
		print("Command lines:")
		print("\t--help: See a list of command lines.")
		print("\t-run: Create a batch file for QEMU execution.")
		print("\t-m64: Make x86-64 build enviroment.")
		print("\t-clean: Delete the build enviroment that you built earlier.")

	elif sys.argv[1] == "-run":
		print("Fatal: '-run' command line can't be used alone.")

	elif sys.argv[1] == "-m64":
		do_m64()

	elif sys.argv[1] == "-clean":
		do_clean()

	else:
		print("Fatal: Unknown command lines. You can see a list of command lines that can be used as '--help' command line.")

elif len(sys.argv) == 3:
	used_run = False
	used_m64 = False
	used_clean = False
	type = ""

	for i in range(1, 3):
		if sys.argv[i] == "--help":
			print("Fatal: '--help' command line can be used alone.")
			sys.exit(0)

		elif sys.argv[i] == "-run":
			if used_run:
				print("Fatal: '-run' command line has already been used.")
				sys.exit(0)
			else:
				if used_clean:
					print("Fatal: '-run' command line can't be used with '-clean' command line.")
					sys.exit(0)
				used_run = True

		elif sys.argv[i] == "-m64":
			if used_m64:
				print("Fatal: '-m64' command line has already been used.")
				sys.exit(0)
			else:
				if used_clean:
					print("Fatal: '-m64' command line can't be used with '-clean' command line.")
					sys.exit(0)
				used_m64 = True
				type = "x86-64"

		elif sys.argv[i] == "-clean":
			if used_clean:
				print("Fatal: '-clean' command line has already been used.")
				sys.exit(0)
			else:
				if used_run:
					print("Fatal: '-clean' command line can't be used with '-run' command line.")
					sys.exit(0)
				elif used_m64:
					print("Fatal: '-clean' command line can't be used with '-m64' command line.")
					sys.exit(0)
				used_clean = True
		
		else:
			print("Fatal: Unknown command lines. You can see a list of command lines that can be used as '--help' command line.")
			sys.exit(0)

	if used_run:
		do_run(type)

	if used_m64:
		do_m64()
		preprocessor(type)
	
	if used_clean:
		do_clean()

else:
	print("Fatal: Can use up to two command lines.")