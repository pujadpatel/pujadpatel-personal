//  Puja Patel
//  ITP 165, Fall 2015
//  Homework 04
//  pujadpat@usc.edu

#include <iostream>
#include <string>

int main()
{
    //Part 1: variable setup
    
    std::string input;
    char letter;
    
    std::string morse[26]= //set up string array to hold morse code
    {
        ".-",       //A = morse[0]
        "-...",     //B = morse[1]
        "-.-.",     //C = morse[2]
        "-..",      //D = morse[3]
        ".",        //E = morse[4]
        "..-.",     //F = morse[5]
        "--.",      //G = morse[6]
        "....",     //H = morse[7]
        "..",       //I = morse[8]
        ".---",     //J = morse[9]
        "-.-",      //K = morse[10]
        ".-..",     //L = morse[11]
        "--",       //M = morse[12]
        "-.",       //N = morse[13]
        "---",      //O = morse[14]
        ".--.",     //P = morse[15]
        "--.-",     //Q = morse[16]
        ".-.",      //R = morse[17]
        "...",      //S = morse[18]
        "-",        //T = morse[19]
        "..-",      //U = morse[20]
        "...-",     //V = morse[21]
        ".--",      //W = morse[22]
        "-..-",     //X = morse[23]
        "-.--",     //Y = morse[24]
        "--,,"      //Z = morse[25]
    };

    std::cout << "Input a message to translate into Morse Code: ";
    std::getline (std::cin, input);             //save user message as input
    
    //Part 2: convert to visual morse code
    std::string inputInMorse = "";
    
    for (int i = 0; i < input.length(); i++) //loop through input
    {
        letter = input[i];
        if (letter >= 'A' && letter <= 'Z')  //for capital letters
        {
            int index = letter - 'A';        //set index for position of letter
            inputInMorse += morse[index] + " ";  //append output with morse code letter
        }
        if (letter >= 'a' && letter <= 'z')  //for lower case letters
        {
            int index = letter - 'a';
            inputInMorse += morse[index] + " ";
        }
        if (letter == ' ')
        {
            inputInMorse += " ";
        }
    }
    
    std::cout << std::endl << "Your message translated into Morse code is:" << std::endl;
    std::cout << inputInMorse;
    
    return 0;
}
