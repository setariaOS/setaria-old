extern "C"
{
	void kernel_print(const char* message);

	void kernel_entrypoint_main()
	{
		const char* message = "Hello, world!";
		kernel_print(message);

		while (true);
	}

	void kernel_print(const char* message)
	{
		char* screen = (char*)0xB8000;

		for (int i = 0; message[i] != 0; ++i)
		{
			*screen = message[i];
			screen += 2;
		}
	}
}