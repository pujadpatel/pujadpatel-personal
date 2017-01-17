//  Puja Patel
//  ITP 16, Fall 2015
//  Homework 03
//  pujadpat@usc.edu


#include <iostream>

int main()
{
    //Part 1: Variable setup
    int answers[13]; //int array to hold answers
    double calculation = 0;
    std::string questions[13]=  //set up string array to hold questions
    {
        "Is it easy for you to communicate in social situations",
        "You are a person somewhat reserved and distant in communication",
        "You enjoy having a wide circle of acquaintances",
        "After prolonged socializing you feel you need to get away and be alone",
        "You spend your leisure time actively socializing with a group of people, attending parties, shopping, etc.",
        "You find it difficult to speak loudly",
        "You rapidly get involved in the social life of a new workplace",
        "Often you prefer to read a book than go to a party",
        "The more people you speak to, the better you feel",
        "You prefer to isolate yourself from outside noises",
        "When with a group of people, you enjoy being directly involved and being at the center of attention",
        "You prefer to spend your leisure time alone or relaxing in a tranquil atmosphere",
        "You feel at ease in a crowd"
    };
    
    //Part 2: Give the test
    std::cout << "Please answer these questions using the following numbers:" <<std::endl;
    std::cout << "[1. YES 2. yes 3. uncertain 4. no 5. NO]" <<std::endl <<std::endl;
    for (int i=0; i<13; i++)  //loops through array of questions, presenting one at a time
    {
        std::cout << questions[i]<< ": ";
        std::cin >> answers[i]; //stores user answers in array
    }
    
    //Part 3: Calculate test results
    for (int i=0; i<13; i++) //loops through answers array
    {
        if ((i+1)%2 == 1) //if question is negative, increment calculation depending on answer
        {
            if (answers[i] == 1)
            {
                calculation += 10;
            }
            else if (answers[i] == 2)
            {
                calculation += 5;
            }
            else if (answers[i] == 3)
            {
                calculation += 0;
            }
            else if (answers[i] == 4)
            {
                calculation -= 5;
            }
            else if (answers[i] == 5)
            {
                calculation -= 10;
            }
        }
        else if ((i+1)%2 == 0) //if question is positive, increment calculation depending on answer
        {
            if (answers[i] == 1)
            {
                calculation -= 10;
            }
            else if (answers[i] == 2)
            {
                calculation -= 5;
            }
            else if (answers[i] == 3)
            {
                calculation += 0;
            }
            else if (answers[i] == 4)
            {
                calculation += 5;
            }
            else if (answers[i] == 5)
            {
                calculation += 10;
            }
        }
    }
    
    //Part 4: Display the results
    std::cout << std::endl << "Here are your results:" <<std::endl;
    double result = (calculation/130)*100; //calculates percentage
    if (int(result) >= 0) //if result is positive/extrovert
    {
        std::cout<< int(result) << "% Extrovert";
    }
    else if (int(result) < 0) //if result is negative/introvert
    {
        std::cout<< int(result)*-1 << "% Introvert";
    }
    
    return 0;
}
