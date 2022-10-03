#include <Windows.h>
#include <ShObjIdl.h>
#include <iostream>

int openCSVFile(char* fileName, char* filePath)
{
	const COMDLG_FILTERSPEC c_rgSaveTypes[] =
	{
		{L"csv (*.csv)",       L"*.csv"},
	};

	HRESULT hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED |
		COINIT_DISABLE_OLE1DDE);
	PWSTR pszFilePath;
	PWSTR pszName;
	if (SUCCEEDED(hr))
	{
		IFileOpenDialog* pFileOpen;

		// Create the FileOpenDialog object.
		hr = CoCreateInstance(CLSID_FileOpenDialog, NULL, CLSCTX_ALL,
			IID_IFileOpenDialog, reinterpret_cast<void**>(&pFileOpen));

		if (SUCCEEDED(hr))
		{
			// Show the Open dialog box.
			pFileOpen->SetFileTypes(ARRAYSIZE(c_rgSaveTypes), c_rgSaveTypes);
			hr = pFileOpen->Show(NULL);

			// Get the file name from the dialog box.
			if (SUCCEEDED(hr))
			{
				IShellItem* pItem;
				hr = pFileOpen->GetResult(&pItem);
				if (SUCCEEDED(hr))
				{
					hr = pItem->GetDisplayName(SIGDN_FILESYSPATH, &pszFilePath);
					pItem->GetDisplayName(SIGDN_NORMALDISPLAY, &pszName);
					// Display the file name to the user.
					if (SUCCEEDED(hr))
					{
						CoTaskMemFree(pszFilePath);
					}
					pItem->Release();
				}
			}
			pFileOpen->Release();
		}
		CoUninitialize();
	}

	wcstombs(filePath, pszFilePath, 1000);	//file path for fopen_s

	wcstombs(fileName, pszName, 1000);		//file name to pull Width and Height

	return 0;
}