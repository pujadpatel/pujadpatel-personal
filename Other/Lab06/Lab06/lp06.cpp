//  Puja Patel
//  ITP 165, Fall 2015
//  Lab practical 7
//  pujadpat@usc.edu


#include <iostream>

int main()
{
    //variables
    const std::string cipher = "EHTGDBWIUQRXLMVFSJCPYZKAON";
    std::string input;
    char letter;
    bool goAgain = true;
    std::string goAgainInput;
    
    //do-while loop
    do
    {
    std::cout << "Enter a word to encrypt: ";
    std::cin >> input;
        
    for (int i = 0; i < input.length(); i++)
    {
        letter = input[i];
        if (letter >= 'A' && letter <= 'Z')
        {
            int index = letter - 'A';
            input[i] = cipher[index];
        }
        if (letter >='a' && letter <= 'z')
        {
            int index = letter - 'a';
            input[i] = cipher[index];
        }
    }

        std::cout << "Your word encrypts to: " << input << std::endl;
        std::cout << "Would you like to go again (Y/N)? ";
        std::cin >> goAgainInput;
        if (goAgainInput == "Y" || goAgainInput == "y")
        {
            goAgain = true;   //if user wants to start over bool is set to true
        }
        else
        {
            goAgain = false;
        }

    }
    while (goAgain == true);

    return 0;
}
