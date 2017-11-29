extern "C"
{
	void kernel_print(const char* message);

	void kernel_main()
	{
		kernel_print("Hello, world!");

		while (true);
	}

	void kernel_print(const char* message)
	{
		char* screen = (char*)0xB8000;

		for (int i = 0; message[i] != 0; i += 2)
		{
			screen[i] = message[i];
		}
	}
}