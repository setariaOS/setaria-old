extern "C"
{
	void kernel_print(const char* message);

	void kernel_entrypoint_main()
	{
		char array[50];

		int i = 0;
		for (char c = 'A'; c != 'Z' + 1; ++c, ++i)
		{
			array[i] = c;
		}

		for (char c = 'a'; c != 'z' + 1; ++c, ++i)
		{
			array[i] = c;
		}

		kernel_print(array);

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