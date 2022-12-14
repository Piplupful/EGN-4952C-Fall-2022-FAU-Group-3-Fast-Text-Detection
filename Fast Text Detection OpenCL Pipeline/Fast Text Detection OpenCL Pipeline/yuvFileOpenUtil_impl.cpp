#include <Windows.h>
#include <ShObjIdl.h>
#include <regex>
#include <iostream>

using namespace std;

FILE* openYUVFile(uint64_t* width, uint64_t* height, string inputFolderPath, string yuvFileName)
{
	FILE* fp;

	string fullPath = inputFolderPath + yuvFileName;

	//Open File through fopen_s, filepath found through File Explorer.
	fopen_s(&fp, fullPath.c_str(), "rb");

	if (fp)
	{
		string widthS;
		string heightS;
		string s = yuvFileName;

		widthS = regex_replace(
			s,
			std::regex("[^0-9]*([0-9]+).*"),
			std::string("$1")
		);

		s = s.substr(s.find_first_of("0123456789") + 1);	//Remove everything before Width
		s = s.substr(s.find_first_of("x") + 1);				//Remove Width and x

		heightS = regex_replace(
			s,
			std::regex("[^0-9]*([0-9]+).*"),
			std::string("$1")
		);

		*width = (uint64_t)stoi(widthS);
		*height = (uint64_t)stoi(heightS);

		return fp;
	}

	return NULL;
}

int openYUVFile_Win(uint64_t* width, uint64_t* height, char* fileName, char* filePath)
{
	const COMDLG_FILTERSPEC c_rgSaveTypes[] =
	{
		{L"YUV 4:2:0 (*.yuv)",       L"*.yuv"},
	};

	string widthS;
	string heightS;

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

	if (hr != 0)
	{
		cerr << "Error opening File.\n";
		return 2;
	}

	//Pull Width x Height from YUV file name.	File name format: Name_With_No_Numbers_WidthxHeight_etc.yuv
	wcstombs(filePath, pszFilePath, 1000);	//file path for fopen_s

	wcstombs(fileName, pszName, 1000);		//file name to pull Width and Height

	string s = fileName;

	widthS = regex_replace(
		s,
		std::regex("[^0-9]*([0-9]+).*"),
		std::string("$1")
	);

	s = s.substr(s.find_first_of("0123456789") + 1);	//Remove everything before Width
	s = s.substr(s.find_first_of("x") + 1);				//Remove Width and x

	heightS = regex_replace(
		s,
		std::regex("[^0-9]*([0-9]+).*"),
		std::string("$1")
	);

	*width = stoi(widthS);
	*height = stoi(heightS);

	return 0;
}