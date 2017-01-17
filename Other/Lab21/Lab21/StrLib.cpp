#include "StrLib.h"

std::vector<std::string> strSplit(const std::string& str, char splitChar)
{
	std::vector<std::string> retVal;
	// Copy into temp since we will rewrite it
	std::string temp = str;

	// Find first instance of split char
	size_t index = temp.find_first_of(splitChar);
	while (index != std::string::npos)
	{
		// Add the first half to the vector
		retVal.push_back(temp.substr(0, index));
		// Update the string to the second half
		temp = temp.substr(index + 1);
		// Find the next instance of split char
		index = temp.find_first_of(splitChar);
	}

	retVal.push_back(temp);

	return retVal;
}
